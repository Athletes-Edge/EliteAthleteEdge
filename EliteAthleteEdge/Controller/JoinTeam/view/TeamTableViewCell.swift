//
//  TeamTableViewCell.swift
//  athletes
//
//  Created by asim on 30/09/2024.
//

import UIKit

class TeamTableViewCell: UITableViewCell {

    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var iconImage: UIImageView!
}
