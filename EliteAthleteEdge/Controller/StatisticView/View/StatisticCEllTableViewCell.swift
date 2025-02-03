//
//  StatisticCEllTableViewCell.swift
//  athletes
//
//  Created by Mac on 06/08/2024.
//

import UIKit

class StatisticCEllTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var ivivew: UIView!
    
    @IBOutlet weak var ivicon: UIImageView!
    @IBOutlet weak var lbldetais: UILabel!
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
