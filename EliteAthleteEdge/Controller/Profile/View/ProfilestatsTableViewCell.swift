//
//  ProfilestatsTableViewCell.swift
//  athletes
//
//  Created by Mac on 06/08/2024.
//

import UIKit

class ProfilestatsTableViewCell: UITableViewCell {

    @IBOutlet weak var ivIcons: UIImageView!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var btncolor: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
class ProfileTeamTableViewCell: UITableViewCell {

    @IBOutlet weak var ivIcons: UIImageView!
    @IBOutlet weak var lblname: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
