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
    @IBOutlet weak var profileImage: UIImageView!
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
    }
}
