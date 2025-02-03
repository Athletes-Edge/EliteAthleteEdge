//
//  TopCollectionTableViewCell.swift
//  athletes
//
//  Created by Mac on 05/08/2024.
//

import UIKit

class TopCollectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ivCollection: UICollectionView!
    @IBOutlet weak var ivheightCollection: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCollectionViewHeight() {
        ivCollection.layoutIfNeeded()
        let height = ivCollection.collectionViewLayout.collectionViewContentSize.height
        ivheightCollection.constant = height
        if let tableView = self.superview as? UITableView {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
