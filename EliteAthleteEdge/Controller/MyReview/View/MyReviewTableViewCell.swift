//
//  MyReviewTableViewCell.swift
//  Athlete
//
//  Created by ali john on 05/11/2024.
//

import UIKit

class MyReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var btnDelete:UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
