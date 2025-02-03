//
//  topSerachDetailTableViewCell.swift
//  athletes
//
//  Created by Mac on 06/08/2024.
//

import UIKit

class topSerachDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    //@IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var nofoundLabel: UILabel!
    @IBOutlet weak var courseDurationLabel: UILabel!
    @IBOutlet weak var courseTitle: UILabel!
    @IBOutlet weak var coachNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var vedioImage: UIImageView!
    @IBOutlet weak var ivCollection: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(course: CourseModel, selectedIndex: Int) {
        
        //ratingLabel.text = "\(course.rating ?? 0.0)/5"
        
        if course.courseOverviewData.count > 0{
            let courseOverView = course.courseOverviewData[selectedIndex]
            vedioImage.imageURL(courseOverView.thumbnailUrl ?? "")
            descriptionLabel.text = courseOverView.descriptions ?? ""
            courseTitle.text = courseOverView.title ?? ""
            courseDurationLabel.text = Int64(courseOverView.duration ?? 0).secondsToTime()
            if courseOverView.videoUrl != nil{
                playButton.isHidden = false
                nofoundLabel.isHidden = true
            }
            else{
                playButton.isHidden = true
                nofoundLabel.isHidden = false
            }
            
        }
        
        //guard let coachData = course.coachesData else { return }
        //coachNameLabel.text =  coachData.name ?? ""
        //profileImage.imageURL(coachData.profileImage ?? "")
    }
    
//    func convertMillisecondsToHoursMinutes(milliseconds: Int64) -> String {
//        let totalSeconds = milliseconds / 1000
//        let hours = totalSeconds / 3600
//        let minutes = (totalSeconds % 3600) / 60
//        
//        return "\(hours)h \(minutes)m"
//    }

}
class topSerachDetail1TableViewCell: UITableViewCell {

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var feedbackTextfield: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
