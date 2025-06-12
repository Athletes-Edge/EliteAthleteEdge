//
//  CoursesTableViewCell.swift
//  athletes
//
//  Created by ali john on 06/08/2024.
//

import UIKit

class CoursesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var progessbar: UIProgressView!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var coachNameLabel: UILabel!
    @IBOutlet weak var markImage: UIButton!
    @IBOutlet weak var prereqButton: UIButton!
    @IBOutlet weak var prereqView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var proImage: UIButton!
    @IBOutlet weak var mainView: UIView!
    var delegate: HomeTableVeiwCellDelegate?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        progessbar.setProgress(0.0, animated: false)
        percentageLabel.text = ""
        titleImage.image = nil
        coachNameLabel.text = ""
        courseNameLabel.text = ""
        
    }
    
    func configureCell(course: CourseModel) {
        titleImage.imageURL(course.Imageurl ?? "")
        courseNameLabel.text = course.title ?? ""
        let id = FirebaseData.getCurrentUserId()
        let isMarked = course.isSaved[id] ?? false
        markImage.setImage(isMarked  ? UIImage(named: "Icon bookmark 1") : UIImage(named: "group (4)"), for: .normal)
        markImage.addTarget(self, action: #selector(didTapMarkImage(_:)), for: .touchUpInside)
        
        //courseDurationLabel.text = convertMillisecondsToHoursMinutes(milliseconds: course.duration ?? 0 )
        if course.contentType == "course"{
            self.profileImage.image = UIImage(resource: .book)
        }
        else{
            self.profileImage.image = UIImage(resource: .video)
        }
        if course.isPro{
            proImage.isHidden = false
        }
        else{
            proImage.isHidden = true
        }
        //guard let coachData = course.coachesData else { return }
        coachNameLabel.text =  course.dscription ?? ""
        
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
    @objc func didTapMarkImage(_ sender: UIButton) {
        
        delegate?.didTapBookMark(index: sender.tag)
    }
}
