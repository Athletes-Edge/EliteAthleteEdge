//
//  CheckMarkTableTableViewCell.swift
//  athletes
//
//  Created by Mac on 05/08/2024.
//

import UIKit

class CheckMarkTableTableViewCell: UITableViewCell {
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var btncheckmark: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
