//
//  ProfiletopTableViewCell.swift
//  athletes
//
//  Created by Mac on 06/08/2024.
//

import UIKit

class ProfiletopTableViewCell: UITableViewCell {

    //@IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var btnedit: UIButton!
    @IBOutlet weak var completeLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var upgradeLabel: UILabel!
    @IBOutlet weak var cancelLabel: UILabel!
    @IBOutlet weak var upgradeBtn: UILabel!
    @IBOutlet weak var upgradeView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
