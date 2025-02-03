//
//  SearchsTableViewCell.swift
//  athletes
//
//  Created by ali john on 06/08/2024.
//

import UIKit

class SearchsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var isProButton: UIButton!
    @IBOutlet weak var courseTitleLabel: UILabel!
    @IBOutlet weak var coachNameLabel: UILabel!
    @IBOutlet weak var markButton: UIButton!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(course: CourseModel) {
        titleImage.imageURL(course.Imageurl ?? "")
        courseTitleLabel.text = course.title ?? ""
        isProButton.isHidden = !course.isPro ?? false
        //courseRatingLabel.text = "\(course.averageRating ?? 0.0)/5"
        let id = FirebaseData.getCurrentUserId()
        let isMarked = course.isSaved[id] ?? false
        markButton.setImage( ((isMarked ) ? UIImage(named: "Icon bookmark 1") : UIImage(named: "group (4)")), for: .normal)
        //courseDurationLabel.text = convertMillisecondsToHoursMinutes(milliseconds: course.duration ?? 0 )
        
        //guard let coachData = course.coachesData else { return }
        coachNameLabel.text =  course.dscription ?? ""
       // profileImage.imageURL(coachData.first?.profileImage ?? "")
    }
}
