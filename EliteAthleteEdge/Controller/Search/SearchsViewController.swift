//
//  SearchsViewController.swift
//  athletes
//
//  Created by ali john on 06/08/2024.
//

import UIKit

class SearchsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var coursesModel = [CourseModel]()
    
    var userModel = UserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    private func setupViewController() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    private func paidCourse(_ data: CourseModel) {
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
    
    private func freeCourse(courseData: CourseModel) {
        if courseData.contentType == "course"{
            let vc = UIStoryboard.storyBoard(withName: .Search).loadViewController(withIdentifier: .SearchDetailsViewController) as! SearchDetailsViewController
            vc.userModel = self.userModel
            vc.courseData = courseData
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let vc = UIStoryboard.storyBoard(withName: .Search).loadViewController(withIdentifier: .SearchDetails1ViewController) as! SearchDetails1ViewController
            vc.userModel = self.userModel
            vc.courseData = courseData
            self.navigationController?.pushViewController(vc, animated: true)
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
                self.tableView.reloadData()
            }
        }
    }
}

extension SearchsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coursesModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchsTableViewCell", for: indexPath) as! SearchsTableViewCell
        cell.markButton.tag = indexPath.row
        cell.markButton.addTarget(self, action: #selector(didTapMarkButton(_:)), for: .touchUpInside)
        cell.configureCell(course: coursesModel[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let courseData =  self.coursesModel[indexPath.row]
        courseData.isPro ?  paidCourse( courseData) : freeCourse(courseData: courseData)
    }
}
