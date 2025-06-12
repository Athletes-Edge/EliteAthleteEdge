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
    @IBOutlet weak var badge1: UIImageView!
    @IBOutlet weak var badge2: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func prepareForReuse() {
        self.badge1.isHidden = true
        self.badge2.isHidden = true
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
