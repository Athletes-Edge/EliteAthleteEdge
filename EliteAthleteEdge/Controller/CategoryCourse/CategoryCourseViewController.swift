//
//  CategoryCourseViewController.swift
//  Athlete
//
//  Created by ali john on 04/11/2024.
//

import UIKit

class CategoryCourseViewController: UIViewController {

    @IBOutlet weak var ivtableView: UITableView!
    var coursesModel = [CourseModel]()
    var categoryModel:CategoryModel!
    var userModel = UserModel()
    var teamData:[TeamModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }
    
    private func setupController() {
        ivtableView.delegate = self
        ivtableView.dataSource = self
        
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
                self.stopAnimating()
                if let error = error{
                    
                    PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                    return
                }
                self.coursesModel = courses ?? []
                self.coursesModel.removeAll { CourseModel1 in
                    return !CourseModel1.categoryId.contains(self.categoryModel.docId)
                }
                self.ivtableView.reloadData()

            }
        }
        else{
            self.stopAnimating()
            PopupHelper.showAlertControllerWithError(forErrorMessage: "No team found", forViewController: self)
        }
        
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
                self.ivtableView.reloadData()
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension CategoryCourseViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coursesModel.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultsTableViewCell", for: indexPath) as! SearchResultsTableViewCell
        cell.markButton.tag = indexPath.row
        cell.markButton.addTarget(self, action: #selector(didTapMarkButton(_:)), for: .touchUpInside)
        cell.configureCell(course: coursesModel[indexPath.row])
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
}
