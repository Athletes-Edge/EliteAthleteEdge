//
//  CoursesViewController.swift
//  athletes
//
//  Created by ali john on 06/08/2024.
//

import UIKit

class CoursesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var coursesModel = [CourseModel]()
    var userModel = UserModel()
    var teamData:[TeamModel]!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }

    private func setupController() {
        tableView.delegate = self
        tableView.dataSource = self
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
                self.coursesModel = courses!
                self.fetchAllRequiredCourses()

            }
        }
        else{
            self.stopAnimating()
            PopupHelper.showAlertControllerWithError(forErrorMessage: "No team found", forViewController: self)
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
    
}
extension CoursesViewController: HomeTableVeiwCellDelegate {
    func didTapCourse(indexPath: IndexPath) {
        
    }
    
    @objc func didTapPreButton(_ sender: UIButton) {
        if let requiredCourseData = self.coursesModel[sender.tag].requiredCourseData,requiredCourseData.count > 0{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PreCourseViewController") as! PreCourseViewController
            vc.coursesModel = requiredCourseData
            vc.userModel = self.userModel
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
extension CoursesViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coursesModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoursesTableViewCell", for: indexPath) as! CoursesTableViewCell
        cell.delegate = self
        cell.markImage.tag = indexPath.row
        cell.prereqButton.tag = indexPath.row
        cell.prereqButton.addTarget(self, action: #selector(didTapPreButton(_:)), for: .touchUpInside)
        cell.configureCell(course: self.coursesModel[indexPath.row])
        
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
