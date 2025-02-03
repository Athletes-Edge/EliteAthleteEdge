//
//  SearchResultsViewController.swift
//  athletes
//
//  Created by Mac on 06/08/2024.
//

import UIKit
import LGSideMenuController

class SearchResultsViewController: UIViewController {
    
    @IBOutlet weak var ivtableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    var coursesModel = [CourseModel]()
    var filteredData = [CourseModel]()
    var categoriesModel = [CategoryModel]()
    var userModel = UserModel()
    var teamData:[TeamModel]!
    var isSearch = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }
    
    private func setupController() {
        ivtableView.delegate = self
        ivtableView.dataSource = self
        searchTextField.delegate = self
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
            self.ivtableView.reloadData()
        }
    }
    
    @objc func didTapMarkButton(_ sender: UIButton) {
        let index = sender.tag
        var course:CourseModel!
        if self.isSearch{
            course = self.filteredData[index]
        }
        else{
            course = self.coursesModel[index]
        }
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
                if self.isSearch{
                    self.filteredData[index].isSaved = saved
                }
                else{
                    self.coursesModel[index].isSaved = saved
                }
                self.ivtableView.reloadData()
            }
        }
    }
    
    @IBAction func btnfilter(_ sender: Any) {
        let vc = UIStoryboard.storyBoard(withName: .Search).loadViewControllersss(withIdentifier: "SearchViewController") as! SearchViewController
        let filteredCourses = self.coursesModel.filter { $0.rating > 4 }
        let sortedCourses = filteredCourses.sorted { $0.rating > $1.rating }
        let top5Courses = Array(sortedCourses.prefix(5))
        
        
        vc.categoryArray = categoriesModel
        vc.topFiveSearch = top5Courses
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchResultsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSearch{
            return filteredData.count
        }
        else{
            return coursesModel.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultsTableViewCell", for: indexPath) as! SearchResultsTableViewCell
        cell.markButton.tag = indexPath.row
        cell.markButton.addTarget(self, action: #selector(didTapMarkButton(_:)), for: .touchUpInside)
        if self.isSearch{
            cell.configureCell(course: filteredData[indexPath.row])
        }
        else{
            cell.configureCell(course: coursesModel[indexPath.row])
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var data:CourseModel!
        if self.isSearch{
            data = self.filteredData[indexPath.row]
        }
        else{
            data = self.coursesModel[indexPath.row]
        }
        
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

extension SearchResultsViewController: SearchViewControllerDelegate {
    func filterData(categories: [CategoryModel], topSearch: [CourseModel]) {
        if topSearch.count > 0{
            self.isSearch = true
            filteredData = coursesModel.filter({ CourseModel1 in
                let top = topSearch.filter { CourseModel2 in
                    return CourseModel1.title == CourseModel2.title
                }
                if top.count > 0{
                    return true
                }
                return false
            })
            if categories.count > 0{
                let fiter = coursesModel.filter({ CourseModel1 in
                    let cate = categories.filter { category in
                        return CourseModel1.categoryId.contains(where: {$0 == category.docId})
                    }
                    if cate.count > 0{
                        return true
                    }
                    return false
                })
                if fiter.count > 0{
                    filteredData.append(contentsOf: Array(fiter))
                }
            }
        }
        else if categories.count > 0{
            self.isSearch = true
            filteredData = coursesModel.filter({ CourseModel1 in
                let cate = categories.filter { category in
                    return CourseModel1.categoryId.contains(where: {$0 == category.docId})
                }
                if cate.count > 0{
                    return true
                }
                return false
            })
        }
        self.ivtableView.reloadData()
    }
}


extension SearchResultsViewController: UITextFieldDelegate {

    
    @IBAction func textchanged(_ textField:UITextField){
        if let text = textField.text,!text.isEmpty{
            self.filteredData = self.coursesModel.filter({ CourseModel1 in
                return CourseModel1.title.lowercased().contains(text.lowercased())
            })
            self.isSearch = true
        }
        else{
            self.isSearch = false
        }
        self.ivtableView.reloadData()
    }

}
