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
                
                if let courses = courses {
                    self.coursesModel = courses
                    self.fetchAllRequiredCourses()
                } else {
                    self.stopAnimating()
                    PopupHelper.alertWithOk(title: "Error", message: error?.localizedDescription ?? "", controler: self)
                }
            }
        }
        
    }
    private func fetchAllRequiredCourses() {
        let dispatch = DispatchGroup()
        
        for dd in self.coursesModel{
            if let requiredCourse = dd.requiredCourse,requiredCourse.count > 0{
                dispatch.enter()
                FirebaseData.getCoursesByIds(courseIds: requiredCourse) { error, courses in
                    dd.requiredCourseData = courses
                    dispatch.leave()
                }
            }
        }
        dispatch.notify(queue: .main){
            self.stopAnimating()
            self.tableView.reloadData()
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
    @objc func didTapPreButton(_ sender: UIButton) {
        if let requiredCourseData = self.coursesModel[sender.tag].requiredCourseData,requiredCourseData.count > 0{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PreCourseViewController") as! PreCourseViewController
            vc.coursesModel = requiredCourseData
            vc.userModel = self.userModel
            self.navigationController?.pushViewController(vc, animated: true)
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
        cell.prereqButton.tag = indexPath.row
        cell.prereqButton.addTarget(self, action: #selector(didTapPreButton(_:)), for: .touchUpInside)
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
        if let requiredCourseData = data.requiredCourseData,requiredCourseData.count > 0{
            let isCompleted = requiredCourseData.filter { CourseModel1 in
                return CourseModel1.isCompleted[FirebaseData.getCurrentUserId()] ?? false == false
            }
            if isCompleted.count > 0{
                let alert = UIAlertController(title: "Alert", message: "This course requires you to complete all prerquisite courses first. Please finish them to unlock this content", preferredStyle: .alert)
                let open = UIAlertAction(title: "Open", style: .default){
                    act in
                    let btn = UIButton()
                    btn.tag = indexPath.row
                    self.didTapPreButton(btn)
                }
                let cancel = UIAlertAction(title: "Close", style: .default)
                alert.addAction(open)
                alert.addAction(cancel)
                self.present(alert, animated: true)
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
