//
//  ProfileViewController.swift
//  athletes
//
//  Created by Mac on 06/08/2024.
//




struct dataprofile{
    
    var name:dataprofiles
    var color:UIColor?
    var colorbg:UIColor?
    var icon:UIImage
    
    
}
enum dataprofiles:String{
    case HoursLearned = "Hours Learned",PointsAchieved = "Points Achieved", MyReviews = "My Reviews"
}
import UIKit
import YPImagePicker

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var config = YPImagePickerConfiguration()
    var picker: YPImagePicker?
    
    var array = [
        dataprofile(name: .HoursLearned, color: UIColor().colorsFromAsset(name: .orangeColor),colorbg: UIColor().colorsFromAsset(name: .orangeColor30), icon: UIImage(named: "Icon hourglass half")!),
        dataprofile(name: .PointsAchieved, color: UIColor().colorsFromAsset(name: .greenColor),colorbg:UIColor().colorsFromAsset(name: .greenColor30) , icon: UIImage(named: "Icon trophy")!)
        //dataprofile(name: .MyReviews, color: UIColor().colorsFromAsset(name: .greenColor),colorbg:UIColor().colorsFromAsset(name: .greenColor30) , icon: UIImage(named: "_x32_6")!)
    ]
    
    var userData = UserModel()
    var teamArray = [TeamModel]()
    var completedCourse = [CourseModel]()
    var progressArray = [CourseModel]()
    var reviewArray = [ReviewModel]()
    var hoursLearned:Double! = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated:Bool){
        super.viewWillAppear(animated)
        setupController()
    }
    private func setupController() {
        config.showsPhotoFilters = false
        config.showsVideoTrimmer = false
        config.showsCrop = .none
        config.shouldSaveNewPicturesToAlbum = false
        config.library.defaultMultipleSelection = false
        config.targetImageSize = YPImageSize.original
        self.getUserData()
    }
    
    private func getUserData() {
        PopupHelper.showAnimating(self)
        FirebaseData.getUserData(uid: FirebaseData.getCurrentUserId()) { error, userData in
            if let error = error{
                self.stopAnimating()
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            self.userData = userData!
            FirebaseData.getAllMyTeamData(uid: FirebaseData.getCurrentUserId()) { error, teamsData in
                
                if let error = error{
                    
                    PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                    return
                }
                self.teamArray = teamsData ?? []
                FirebaseData.getAllCourses(teamss: self.teamArray.map({$0.docId})) { error, courses in
                    
                    
                    if let error = error{
                        self.stopAnimating()
                        PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                        return
                    }
                    if let courses = courses{
                        self.completedCourse = courses.filter({ CourseModel1 in
                            if let completed = CourseModel1.isCompleted{
                                if completed[FirebaseData.getCurrentUserId()] ?? false{
                                    return true
                                }
                            }
                            return false
                        })
                        self.progressArray = courses.filter({ CourseModel1 in
                            if let completed = CourseModel1.isCompleted{
                                if completed[FirebaseData.getCurrentUserId()] ?? false{
                                    return false
                                }
                                else{
                                    return true
                                }
                            }
                            return true
                        })
                        
                    }
                    FirebaseData.getAllLearnCoursesHours(uid: FirebaseData.getCurrentUserId()) { error, courses in
                        
                        if let error = error{
                            self.stopAnimating()
                            PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                            return
                        }
                        var count:Double = 0
                        if let courses = courses{
                            for data in courses{
                                count += (data.watchHours / 1000)
                            }
                            self.hoursLearned = count
                        }
                        
                        FirebaseData.getAllCommentsCours(uid: FirebaseData.getCurrentUserId()) { error, courses in
                            self.stopAnimating()
                            if let error = error{
                                
                                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                                return
                            }
                            self.reviewArray = courses ?? []
                            self.tableView.reloadData()
                        }
                    }
                    
                }
                
            }
        }
    }
    
    @objc func didTapProfileImage() {
        picker = YPImagePicker(configuration: self.config)
        picker?.didFinishPicking { [unowned picker] items, _ in
            if let image = items.singlePhoto?.image {
                self.saveProfileImage(image: image)
            }
            picker?.dismiss(animated: true, completion: nil)
        }
        present(picker ?? YPImagePicker(), animated: true, completion: nil)
    }
    @objc func didtapUpgrade(){
        let vc = UIStoryboard.storyBoard(withName: .Courses).loadViewController(withIdentifier: .SubscriptionViewController) as! SubscriptionViewController
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }
    private func saveProfileImage(image: UIImage) {
        PopupHelper.showAnimating(self)
        FirebaseData.uploadProfileImage(image: image, name: FirebaseData.getCurrentUserId(), folder: "ProfileImage") { url, error, index in
            if let url = url {
                self.userData.userImage = url
                self.updateUserData(userModel: self.userData)
                } else {
                self.stopAnimating()
                PopupHelper.alertWithOk(title: "Error", message: error?.localizedDescription ?? "", controler: self)
            }
        }
    }
    
    private func updateUserData(userModel: UserModel, forceNaviagte: Bool = false) {
        FirebaseData.updateUserData(userModel.userId, dic: userModel) { error in
            self.stopAnimating()
            if let error = error {
                PopupHelper.alertWithOk(title: "Error", message: error.localizedDescription, controler: self)
            } else {
                self.userData = userModel
                self.tableView.reloadData()
            }
        }
    }
    private func logoutUser() {
        PopupHelper.showAnimating(self)
        FirebaseData.logoutUserData { error in
            self.stopAnimating()
            if let error = error {
                PopupHelper.alertWithOk(title: "Error", message: error.localizedDescription , controler: self)
            } else {
                self.goToLogin()
            }
        }
    }
    
    private func goToLogin() {
        DispatchQueue.main.async {
            let vc = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .NavLoginViewController)
            UIApplication.shared.setRootViewController(vc)

        }
    }
    
    @IBAction func logout(_ sender:Any){
                PopupHelper.alertWithYesNo(title: "Logout Confirmation", message: "Are you sure you want to log out?", controller: self) {  isOkay in
                    if isOkay {
                        self.logoutUser()
                    }
                }
    }
    func deleteTeam(_ indx:Int){
        PopupHelper.showAnimating(self)
        FirebaseData.deleteTeam(uid: self.teamArray[indx].docId) { error in
            self.stopAnimating()
            if let error = error{
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            self.teamArray.remove(at: indx)
            self.tableView.reloadData()
        }
    }

}

extension ProfileViewController:UITableViewDelegate,UITableViewDataSource{
    
    @objc func btngotoansers(_ sender:UIButton){
        let vc = UIStoryboard.storyBoard(withName: .Profile).loadViewControllersss(withIdentifier: "StatisticViewController")
        //self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func btnedit(_ sender:UIButton){
        let vc = UIStoryboard.storyBoard(withName: .Profile).loadViewControllersss(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        vc.userData = self.userData
        vc.teamArray = self.teamArray
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = Bundle.main.loadNibNamed("profieHeader", owner: self)?.first as! profieHeader
        if section == 1 {
            headerView.lblname.text = "TOTAL STATISTICS"
        } else if section == 2 {
            headerView.lblname.text = "MY TEAM"
        } else {
            headerView.lblname.text = ""
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ((section == 1 || section == 2) ?  35.0 : 0.0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1{
            return self.array.count
        }
        else if section == 2{
            return self.teamArray.count
        }
        else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfilestatsTableViewCell", for: indexPath) as! ProfilestatsTableViewCell
            cell.btncolor.backgroundColor = self.array[indexPath.row].colorbg
            cell.btncolor.setTitleColor(self.array[indexPath.row].color, for: .normal)
            cell.ivIcons.image = self.array[indexPath.row].icon
            switch self.array[indexPath.row].name{
            case .HoursLearned:
                cell.btncolor.setTitle(Int64(self.hoursLearned).secondsToTime(), for: .normal)
            case .PointsAchieved:
                cell.btncolor.setTitle("\(self.userData.pointsSkill ?? 0)", for: .normal)
            case .MyReviews:
                cell.btncolor.setTitle("\(self.reviewArray.count)", for: .normal)
            }
            cell.lblname.text = self.array[indexPath.row].name.rawValue
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTeamTableViewCell", for: indexPath) as! ProfileTeamTableViewCell
            let data = self.teamArray[indexPath.row]
            cell.ivIcons.imageURL( data.image ?? "")
            cell.lblname.text = data.name ?? ""
            return cell
        }
//        else if indexPath.section ==  {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "buttonTableViewCell", for: indexPath) as! buttonTableViewCell
//            cell.btnseerestults.addTarget(self, action: #selector(self.btngotoansers), for: .touchUpInside)
//            return cell
//        }
        else  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfiletopTableViewCell", for: indexPath) as! ProfiletopTableViewCell
            cell.btnedit.addTarget(self, action: #selector(self.btnedit), for: .touchUpInside)
            cell.profileImage.isUserInteractionEnabled = true
            cell.profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapProfileImage)))
            cell.profileImage.imageURL(self.userData.userImage ?? "")
            cell.userNameLabel.text = userData.userName ?? ""
            //cell.cityLabel.text = userData.address ?? ""
            cell.completeLabel.text = "\(self.completedCourse.count)"
            cell.progressLabel.text = "\(self.progressArray.count)"
            
            if self.userData.isSubsCribed{
                cell.upgradeBtn.setTitle("Active", for: .normal)
                if let gests = cell.upgradeView.gestureRecognizers{
                    for gest in gests{
                        cell.upgradeView.removeGestureRecognizer(gest)
                    }
                }
            }
            else{
                cell.upgradeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didtapUpgrade)))
                cell.upgradeBtn.setTitle("Inactive", for: .normal)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.section == 1{
//            switch self.array[indexPath.row].name{
//            case .MyReviews:
//                let vc = UIStoryboard.storyBoard(withName: .Profile).loadViewController(withIdentifier: .MyReviewViewController) as! MyReviewViewController
//                vc.reviewArray = self.reviewArray
//                self.navigationController?.pushViewController(vc, animated: true)
//            default:
//                break
//            }
//        }
//        else
        if indexPath.section == 2{
            let vc = UIStoryboard.storyBoard(withName: .Profile).loadViewController(withIdentifier: .AlertDeleteViewController) as! AlertDeleteViewController
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            vc.indx = indexPath.row
            self.present(vc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
