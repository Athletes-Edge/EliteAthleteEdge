//
//  ProgressTableViewCell.swift
//  athletes
//
//  Created by asim on 06/08/2024.
//

import UIKit

class ProgressTableViewCell: UITableViewCell {
    
    @IBOutlet weak var progessbar: UIProgressView!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var courseTitleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var markButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        progessbar.setProgress(0.0, animated: false)
        percentageLabel.text = ""
        titleImage.image = nil
        detailLabel.text = ""
        
    }
    
    func configureCell(course: CourseModel) {
        titleImage.imageURL(course.Imageurl ?? "")
        courseTitleLabel.text = course.title ?? ""
        let id = FirebaseData.getCurrentUserId()
        let isMarked = course.isSaved[id] ?? false
        markButton.setImage(isMarked  ? UIImage(named: "Icon bookmark 1") : UIImage(named: "group (4)"), for: .normal)
        //courseDurationLabel.text = convertMillisecondsToHoursMinutes(milliseconds: course.totalTime ?? 0 )
        if course.contentType == "course"{
            self.profileImage.image = UIImage(resource: .book)
        }
        else{
            self.profileImage.image = UIImage(resource: .video)
        }
        detailLabel.text = course.dscription ?? ""
        //guard let coachData = course.coachesData else { return }
        //coachNameLabel.text =  coachData.name ?? ""
        
        //let overViewCourse = course.courseOverviewData ?? []
        let quizanswer = course.courseQuizData ?? []
        let totalCourse = quizanswer.count
        var totalPercentage = 0.0
        for quiz in quizanswer {
            if let progress = (quiz.userAnswer[FirebaseData.getCurrentUserId()]) {
                
                totalPercentage += 1
            }
        }
        
        let coursePercentage = (totalPercentage / Double(totalCourse)) * 100
        if coursePercentage.isNaN{
            percentageLabel.text = "\(Int(0))% complete"
            progessbar.setProgress(Float(0), animated: true)
        }
        else{
            percentageLabel.text = "\(Int(coursePercentage))% complete"
            progessbar.setProgress(Float(coursePercentage / 100), animated: true)
        }
        
        
        // Set the progress for the progress bar (coursePercentage / 100 to get a Float between 0 and 1)
        
    }
}
