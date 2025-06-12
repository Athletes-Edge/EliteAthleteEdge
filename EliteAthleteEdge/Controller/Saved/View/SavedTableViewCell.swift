//
//  SavedTableViewCell.swift
//  athletes
//
//  Created by ali john on 06/08/2024.
//

import UIKit

class SavedTableViewCell: UITableViewCell {

    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var isProButton: UIButton!
    @IBOutlet weak var courseTitleLabel: UILabel!
    @IBOutlet weak var coachNameLabel: UILabel!
    @IBOutlet weak var markButton: UIButton!
    @IBOutlet weak var prereqButton: UIButton!
    @IBOutlet weak var prereqView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var mainView: UIView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(course: CourseModel) {
        titleImage.imageURL(course.Imageurl ?? "")
        courseTitleLabel.text = course.title ?? ""
        isProButton.isHidden = !course.isPro ?? false
        let id = FirebaseData.getCurrentUserId()
        let isMarked = course.isSaved[id] ?? false
        markButton.setImage( ((isMarked ) ? UIImage(named: "Icon bookmark 1") : UIImage(named: "group (4)")), for: .normal)
        if course.contentType == "course"{
            self.profileImage.image = UIImage(resource: .book)
        }
        else{
            self.profileImage.image = UIImage(resource: .video)
        }
        //guard let coachData = course.coachesData else { return }
        coachNameLabel.text =  course.dscription ?? ""
        
        if let requiredCourseData = course.requiredCourseData,requiredCourseData.count > 0{
            let isCompleted = requiredCourseData.filter { CourseModel1 in
                return CourseModel1.isCompleted[FirebaseData.getCurrentUserId()] ?? false == false
            }
            self.prereqView.isHidden = false
            if isCompleted.count > 0{
                self.mainView.backgroundColor = .lightGray
                
            }
            else{
                self.mainView.backgroundColor = .white
            }
        }
        else{
            self.mainView.backgroundColor = .white
            self.prereqView.isHidden = true
        }
    }
}
