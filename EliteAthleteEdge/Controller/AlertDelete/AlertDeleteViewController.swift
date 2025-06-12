//
//  AlertDeleteViewController.swift
//  Athlete
//
//  Created by ali john on 05/11/2024.
//

import UIKit

class AlertDeleteViewController: UIViewController {

    var deleagte:ProfileViewController!
    var indx:Int!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func yesBtn(_ sender:Any){
        self.dismiss(animated: true) {
            self.deleagte.deleteTeam(self.indx)
        }
    }
    @IBAction func noBtn(_ sender:Any){
        self.dismiss(animated: true)
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
class AlertBadgeViewController: UIViewController {

    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var ivImage:UIImageView!
    
    var deleagte:UIViewController!
    var course:CourseModel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadData()
        // Do any additional setup after loading the view.
    }
    

    func loadData(){
        PopupHelper.showAnimating(self)
        FirebaseData.getCourseBadgeData(courseID: self.course.id) { error, courses in
            self.stopAnimating()
            if let error = error{
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            self.lblName.text = "Congratulations, you've earned a check \(courses?.first?.title ?? "") badge"
            self.ivImage.imageURL(courses?.first?.icon ?? "")
            for course in courses ?? []{
                var data = [String]()
                if let completeUsers = course.completeUsers{
                    data = completeUsers
                }
                data.append(FirebaseData.getCurrentUserId())
                data = Array(Set(data))
                let badg = BadgeModel()
                badg.completeUsers = data
                FirebaseData.updateBadgeData(course.docId, dic: badg) { error in
                    self.stopAnimating()
                }
            }
        }
    }
    @IBAction func yesBtn(_ sender:Any){
        self.dismiss(animated: true) {
            
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
