//
//  HomeCollectionViewCell.swift
//  athletes
//
//  Created by asim on 06/08/2024.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var isProButton: UIButton!
    
    @IBOutlet weak var courseTitleLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var markButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(course: CourseModel) {
        titleImage.imageURL(course.Imageurl ?? "")
        courseTitleLabel.text = course.title ?? ""
        isProButton.isHidden = !course.isPro ?? true
        
        let id = FirebaseData.getCurrentUserId()
        let isMarked = course.isSaved[id] ?? false
        markButton.setImage((isMarked ) ? UIImage(named: "Icon bookmark 1") : UIImage(named: "group (4)"), for: .normal)
        if course.contentType == "course"{
            self.profileImage.image = UIImage(resource: .book)
        }
        else{
            self.profileImage.image = UIImage(resource: .video)
        }
        detailLabel.text = course.dscription ?? ""
        //guard let coachData = course.coachesData else { return }
        //coachNameLabel.text =  coachData.name ?? ""
        //profileImage.imageURL(coachData.profileImage ?? "")
        
        let overViewCourse = course.courseOverviewData ?? []
        
        var totalPercentage = 0.0
        for overView in overViewCourse {
            if let progress = (overView.duration) {
                totalPercentage += progress
            }
        }
        if let requiredCourseData = course.requiredCourseData,requiredCourseData.count > 0{
            let isCompleted = requiredCourseData.filter { CourseModel1 in
                return CourseModel1.isCompleted[FirebaseData.getCurrentUserId()] ?? false == false
            }
            if isCompleted.count > 0{
                self.mainView.backgroundColor = .white
                
            }
            else{
                self.mainView.backgroundColor = .white
            }
        }
        else{
            self.mainView.backgroundColor = .white
        }
    }
    
    
}
