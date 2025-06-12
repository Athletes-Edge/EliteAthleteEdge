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
    case HoursLearned = "Hours Learned",Points = "Points", Badge = "Badge"
}
import UIKit
import YPImagePicker

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var config = YPImagePickerConfiguration()
    var picker: YPImagePicker?
    
    var array = [
        dataprofile(name: .HoursLearned, color: UIColor().colorsFromAsset(name: .orangeColor),colorbg: UIColor().colorsFromAsset(name: .orangeColor30), icon: UIImage(resource: .group195)),
        dataprofile(name: .Points, color: UIColor().colorsFromAsset(name: .greenColor),colorbg:UIColor().colorsFromAsset(name: .greenColor30) , icon: UIImage(resource: .group197))
    ]
    var array1 = [
        dataprofile(name: .Badge, color: UIColor().colorsFromAsset(name: .greenColor),colorbg:UIColor().colorsFromAsset(name: .greenColor30) , icon: UIImage(resource: .x326))
    ]
    var userData = UserModel()
    var teamArray = [TeamModel]()
    var completedCourse = [CourseModel]()
    var progressArray = [CourseModel]()
    var allCourseArray = [CourseModel]()
    var badgeArray = [BadgeModel]()
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
    
    func getUserData() {
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
                        self.allCourseArray = courses
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
                        FirebaseData.getUserBadgeData(userId: FirebaseData.getCurrentUserId()) { error, courses in
                            self.stopAnimating()
                            self.badgeArray = courses ?? []
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
        if self.userData.isSubsCribed{
            let alert = UIAlertController(title: "Cancel Subscription ", message: "Are you sure want to cancel subscription?", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .default)
            let ok = UIAlertAction(title: "Yes", style: .default) { actt in
                let data = self.userData.pm_id
                var datadic = [String:Any]()
                datadic[Constant.subscriptionIds] = [data]
                self.callWebService(data: datadic,action: .cancel_subscriptions, .post)
            }
            alert.addAction(cancel)
            alert.addAction(ok)
            self.present(alert, animated: true)
        }
        else{
            let vc = UIStoryboard.storyBoard(withName: .Courses).loadViewController(withIdentifier: .SubscriptionViewController) as! SubscriptionViewController
            vc.delegate = self
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true)
            
        }
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
    func deleteData(){
        let user = UserModel()
        user.pm_id = ""
        user.isSubsCribed = false
        PopupHelper.showAnimating(self)
        FirebaseData.updateUserData(FirebaseData.getCurrentUserId(), dic: user) { error in
            self.stopAnimating()
            self.getUserData()
        }
    }
    func callWebService(_ id:String? = nil,data: [String:Any]? = nil, action:webserviceUrl,_ httpMethod:httpMethod,_ index:Int? = nil){
        
        WebServicesHelper.callWebService(Parameters: data,suburl: id, action: action, httpMethodName: httpMethod,index) { (indx,action,isNetwork, error, dataDict) in
            self.stopAnimating()
            if isNetwork{
                if let err = error{
                    PopupHelper.showAlertControllerWithError(forErrorMessage: err, forViewController: self)
                }
                else{
                    if let dic = dataDict as? Dictionary<String,Any>{
                        switch action {
                        case .cancel_subscriptions:
                            if let cards = dic["results"] as? [[String:Any]]{
                                
                                self.deleteData()
                            }
                            else if let msg = dic[Constant.message] as? String{
                                PopupHelper.showAlertControllerWithError(forErrorMessage: msg, forViewController: self)
                            }
                        
                        default:
                            break
                        }
                        
                    }
                    else{
                        PopupHelper.showAlertControllerWithError(forErrorMessage: "something went wrong", forViewController: self)
                    }
                }
            }
            else{
                PopupHelper.alertWithNetwork(title: "Network Connection", message: "Please connect your internet connection", controler: self)
                
            }
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
        return 4
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = Bundle.main.loadNibNamed("profieHeader", owner: self)?.first as! profieHeader
        if section == 1 {
            headerView.lblname.text = "TOTAL STATISTICS"
        } else if section == 2 {
            headerView.lblname.text = "BADGES"
        } else if section == 3 {
            headerView.lblname.text = "MY TEAM"
        }
        else {
            headerView.lblname.text = ""
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ((section == 1 || section == 2 || section == 3) ?  35.0 : 0.0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1{
            return self.array.count
        }
        else if section == 2{
            return self.array1.count
        }
        else if section == 3{
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
            case .Points:
                cell.btncolor.setTitle("\(self.userData.pointsSkill ?? 0)", for: .normal)
            default:
                break
            }
            cell.lblname.text = self.array[indexPath.row].name.rawValue
            return cell
        }
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfilestatsTableViewCell", for: indexPath) as! ProfilestatsTableViewCell
            cell.btncolor.backgroundColor = self.array1[indexPath.row].colorbg
            cell.btncolor.setTitleColor(self.array1[indexPath.row].color, for: .normal)
            cell.ivIcons.image = self.array1[indexPath.row].icon
            switch self.array1[indexPath.row].name{
            case .Badge:
                cell.btncolor.setTitle("\(self.badgeArray.count)", for: .normal)
                switch self.badgeArray.count{
                case 1:
                    cell.badge1.imageURL(self.badgeArray[0].icon ?? "")
                    cell.badge1.isHidden = false
                case 2:
                    cell.badge1.imageURL(self.badgeArray[0].icon ?? "")
                    cell.badge1.isHidden = false
                    cell.badge2.imageURL(self.badgeArray[1].icon ?? "")
                    cell.badge2.isHidden = false
                default:
                    break
                }
            default:
                break
            }
            cell.lblname.text = self.array1[indexPath.row].name.rawValue
            return cell
        }
        else if indexPath.section == 3 {
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
            cell.myCourseLabel.text = "\(self.allCourseArray.count)"
            
            if self.userData.isSubsCribed{
                cell.upgradeBtn.text = "Active"
                cell.cancelLabel.isHidden = false
                cell.upgradeLabel.text = "Upgraded"
//                if let gests = cell.upgradeView.gestureRecognizers{
//                    for gest in gests{
//                        cell.upgradeView.removeGestureRecognizer(gest)
//                    }
//                }
            }
            else{
                cell.upgradeLabel.text = "Upgrade Now"
                cell.cancelLabel.isHidden = true
                cell.upgradeBtn.text = "Inactive"
            }
            cell.upgradeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didtapUpgrade)))
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2{
            switch self.array1[indexPath.row].name{
            case .Badge:
                let vc = UIStoryboard.storyBoard(withName: .Profile).loadViewController(withIdentifier: .BadgeViewController) as! BadgeViewController
                vc.badgeArray = self.badgeArray
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        }
        else
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
