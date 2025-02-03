//
//  SavedViewController.swift
//  athletes
//
//  Created by ali john on 06/08/2024.
//

import UIKit

class SavedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var coursesModel = [CourseModel]()
    var userModel:UserModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupController()
    }

    private func setupController() {
        tableView.delegate = self
        tableView.dataSource = self
        fetchAllSavedCourses()
    }
    
    private func fetchAllSavedCourses() {
        PopupHelper.showAnimating(self)
        FirebaseData.getUserData(uid: FirebaseData.getCurrentUserId()) { error, userData in
            self.userModel = userData
            FirebaseData.getSaveCourses(id: FirebaseData.getCurrentUserId()) { error, courses in
                self.stopAnimating()
                if let courses = courses {
                    self.coursesModel = courses
                    self.tableView.reloadData()
                } else {
                    PopupHelper.alertWithOk(title: "Error", message: error?.localizedDescription ?? "", controler: self)
                }
            }
        }
        
    }
    
    @objc func didTapMarkButton(_ sender: UIButton) {
        let index = sender.tag
        let course = self.coursesModel[index]

        var saved = [String:Bool]()
        if let iss = course.isSaved {
            saved = iss
        }
        saved = [FirebaseData.getCurrentUserId():false]
        let cour = CourseModel()
        cour.isSaved = saved
        PopupHelper.showAnimating(self)
        FirebaseData.UpdateCourseData(courseID: course.docId , dic: cour) { error in
            self.stopAnimating()
            if let error = error {
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            } else {
                self.coursesModel.remove(at: index)
                self.tableView.reloadData()
            }
        }
    }
}

extension SavedViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.coursesModel.count == 0{
            tableView.setEmptyMessage("Click the saved icon on any course or video to save it in this section")
        }
        else{
            tableView.restore()
        }
        return coursesModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedTableViewCell", for: indexPath) as! SavedTableViewCell
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
