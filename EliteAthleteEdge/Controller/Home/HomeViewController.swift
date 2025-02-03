//
//  HomeViewController.swift
//  athletes
//
//  Created by ali john on 06/08/2024.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    let locationModel = LocationManager()
    var coursesModel = [CourseModel]()
    var courses1Model = [CourseModel]()
    var categoriesModel = [CategoryModel]()
    var userModel = UserModel()
    var teamData:[TeamModel]!
    var selectedIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated:Bool){
        super.viewWillAppear(animated)
        setupController()
    }
    
    private func setupController() {
        tableView.delegate = self
        tableView.dataSource = self
        locationModel.delegate = self
        locationModel.requestLocationAccess()
        locationModel.startUpdatingLocation()
        
        fetchUserData()
    }
    
    private func fetchUserData() {
        PopupHelper.showAnimating(self)
        FirebaseData.getUserData(uid: FirebaseData.getCurrentUserId()) { error, userData in
            
            if let error = error{
                self.stopAnimating()
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            self.userModel = userData!
            self.fetchUserTeamData()
        }
    }
    private func fetchUserTeamData() {
        
        FirebaseData.getAllMyTeamData(uid:FirebaseData.getCurrentUserId()) { error, teamsData in
            
            if let error = error{
                self.stopAnimating()
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            self.teamData = teamsData
            self.fetchAllCourses()
        }
    }
    private func fetchAllCourses() {
        self.coursesModel.removeAll()
        
        if let team = self.teamData,team.count > 0{
            
            FirebaseData.getAllCoursesAndOverview(teamss: team.map({$0.docId})) { error, courses in
                
                if let error = error{
                    self.stopAnimating()
                    PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                    return
                }
                self.coursesModel = courses ?? []
                self.fetchAllCategories()

            }
        }
        else{
            self.stopAnimating()
            PopupHelper.showAlertControllerWithError(forErrorMessage: "No team found", forViewController: self)
        }
        
    }
    
    private func fetchAllCategories() {
        
        FirebaseData.getAllCategoriesData { error, courses in
            self.stopAnimating()
            if let error = error{
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            self.categoriesModel = courses ?? []
            var cat = [String]()
            for cours in self.coursesModel{
                for catid in cours.categoryId{
                    cat.append(catid)
                }
            }
            cat = Array(Set(cat))
            self.categoriesModel.removeAll { CategoryModel1 in
                return !cat.contains(CategoryModel1.docId)
            }
            self.loadFilterCategory()
        }
    }
    
    
    
    @objc func didTapViewAllVediosAndCourses() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchsViewController") as! SearchsViewController
        vc.coursesModel = self.coursesModel
        vc.userModel = self.userModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapMarkButton(_ sender: UIButton) {
        let index = sender.tag
        let course = self.coursesModel[index]
        
        var saved = [String:Bool]()
        if let iss = course.isSaved {
            saved = iss
        }
        saved = [FirebaseData.getCurrentUserId():true]
        let cour = CourseModel()
        cour.isSaved = saved
        PopupHelper.showAnimating(self)
        FirebaseData.UpdateCourseData(courseID: course.docId , dic: cour) { error in
            self.stopAnimating()
            if let error = error {
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            } else {
                self.coursesModel[index].isSaved = saved
                self.tableView.reloadData()
            }
        }
    }
    // MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.coursesModel.count == 0{
            tableView.setEmptyMessage("No course found yet.")
        }
        else{
            tableView.restore()
        }
        switch section{
        case 0:
            return 1
        case 1:
            return 1
        default:
            return self.courses1Model.count
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell") as! CategoryTableViewCell
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            DispatchQueue.main.async {
                cell.collectionView.reloadData()
            }
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProgressTableViewCell") as! ProgressTableViewCell
            cell.markButton.tag = indexPath.row
            cell.markButton.addTarget(self, action: #selector(didTapMarkButton(_:)), for: .touchUpInside)
            cell.configureCell(course: self.courses1Model[indexPath.row])
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
        cell.delegate = self
        cell.coursesData = self.coursesModel
        cell.viewAllCoursesButton.addTarget(self, action: #selector(didTapViewAllVediosAndCourses), for: .touchUpInside)
        cell.collectionView.reloadData()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2{
            let data = self.courses1Model[indexPath.row]
            if data.isPro{
                
                if let user = self.userModel.isSubsCribed,!user{
                    let vc = UIStoryboard.storyBoard(withName: .Courses).loadViewController(withIdentifier: .SubscriptionViewController) as! SubscriptionViewController
                    vc.delegate = self
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.modalTransitionStyle = .crossDissolve
                    self.present(vc, animated: true)
                    return
                }
            }
            
            if let course =  data.courseOverviewData, course.count == 0{
                PopupHelper.showAlertControllerWithError(forErrorMessage: "There is no course or video", forViewController: self)
                return
            }
            if data.contentType == "course"{
                let vc = UIStoryboard.storyBoard(withName: .Search).loadViewController(withIdentifier: .SearchDetailsViewController) as! SearchDetailsViewController
                vc.userModel = self.userModel
                vc.courseData = data
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else{
                let vc = UIStoryboard.storyBoard(withName: .Search).loadViewController(withIdentifier: .SearchDetails1ViewController) as! SearchDetails1ViewController
                vc.userModel = self.userModel
                vc.courseData = data
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
        }
    }
}
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categoriesModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        if indexPath.row == selectedIndex {
            cell.mainView.borderWidth = 1
            cell.mainView.borderColor = UIColor.bluee
            cell.lblName.textColor = UIColor.bluee
            cell.mainView.backgroundColor = UIColor.blue10
            cell.ivImage.imageURL(self.categoriesModel[indexPath.row].icon ?? "")
        } else {
            cell.mainView.borderWidth = 0
            cell.mainView.backgroundColor = UIColor.white
            cell.lblName.textColor = UIColor.lightGray
            cell.ivImage.imageURL(self.categoriesModel[indexPath.row].icon ?? "")
        }
        cell.lblName.text = self.categoriesModel[indexPath.row].title ?? ""
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        let vc = UIStoryboard.storyBoard(withName: .Search).loadViewController(withIdentifier: .CategoryCourseViewController) as! CategoryCourseViewController
        vc.categoryModel = self.categoriesModel[indexPath.row]
        //self.navigationController?.pushViewController(vc, animated: true)
        collectionView.reloadData()
        self.loadFilterCategory()
    }
    func loadFilterCategory(){
        let cate = self.categoriesModel[self.selectedIndex].docId
        self.courses1Model = self.coursesModel.filter({ CourseModel1 in
            return CourseModel1.categoryId.contains(where: {$0 == cate})
        })
        self.courses1Model = Array(self.courses1Model.prefix(5))
        self.tableView.reloadData()
    }
}
extension HomeViewController: HomeTableVeiwCellDelegate {
    func didTapCourse(indexPath: IndexPath) {
        let data = self.coursesModel[indexPath.row]
        if data.isPro{
            
            if let user = self.userModel.isSubsCribed,!user{
                let vc = UIStoryboard.storyBoard(withName: .Courses).loadViewController(withIdentifier: .SubscriptionViewController) as! SubscriptionViewController
                vc.delegate = self
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true)
                return
            }
        }
        
        if let course =  data.courseOverviewData, course.count == 0{
            PopupHelper.showAlertControllerWithError(forErrorMessage: "There is no course or video", forViewController: self)
            return
        }
        if data.contentType == "course"{
            let vc = UIStoryboard.storyBoard(withName: .Search).loadViewController(withIdentifier: .SearchDetailsViewController) as! SearchDetailsViewController
            vc.userModel = self.userModel
            vc.courseData = data
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let vc = UIStoryboard.storyBoard(withName: .Search).loadViewController(withIdentifier: .SearchDetails1ViewController) as! SearchDetails1ViewController
            vc.userModel = self.userModel
            vc.courseData = data
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func didTapBookMark(index: Int) {
        
        let course = self.coursesModel[index]

        var saved = [String:Bool]()
        if let iss = course.isSaved {
            saved = iss
        }
        saved = [FirebaseData.getCurrentUserId():true]
        let cour = CourseModel()
        cour.isSaved = saved
        PopupHelper.showAnimating(self)
        FirebaseData.UpdateCourseData(courseID: course.docId , dic: cour) { error in
            self.stopAnimating()
            if let error = error {
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            } else {
                self.coursesModel[index].isSaved = saved
                self.tableView.reloadData()
            }
        }
    }
}

extension HomeViewController: LocationManagerDelegate {
    func didUpdateLocation(location: LocationModel?) {
        guard let location = location else { return }
        let newCity = location.city
        let defaults = UserDefaults.standard
        let savedCity = defaults.string(forKey: "userCity")
        if newCity != savedCity {
            defaults.set(newCity, forKey: "userCity")
            let userModel = UserModel()
            userModel.lat = location.lat ?? 0.0
            userModel.lng = location.long ?? 0.0
            userModel.address = location.city
            FirebaseData.updateUserData(FirebaseData.getCurrentUserId(), dic: userModel) { error in
                
            }
        }
    }
}
