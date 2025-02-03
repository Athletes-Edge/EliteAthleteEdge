//
//  SearchResultsTableViewCell.swift
//  athletes
//
//  Created by Mac on 06/08/2024.
//

import UIKit

class SearchResultsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak  var courseNameLabel: UILabel!
    @IBOutlet weak var markButton: UIButton!
    @IBOutlet weak var proButton: UIButton!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        descriptionLabel.text = ""
       // titleImage.image = nil
        courseNameLabel.text = ""
        //markButton = nil
    }
    
    func configureCell(course: CourseModel) {
        if course.isPro{
            proButton.isHidden = false
        }
        else{
            proButton.isHidden = true
        }
        titleImage.imageURL(course.Imageurl ?? "")
        let id = FirebaseData.getCurrentUserId()
        let isMarked = course.isSaved[id] ?? false
        markButton.setImage( ((isMarked ) ? UIImage(named: "Icon bookmark 1") : UIImage(named: "group (4)")), for: .normal)
        courseNameLabel.text = course.title ?? ""
        descriptionLabel.text = course.dscription ?? ""
    }
}
