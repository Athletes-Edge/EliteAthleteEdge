//
//  HomeTableViewCell.swift
//  athletes
//
//  Created by asim on 06/08/2024.
//

import UIKit

protocol HomeTableVeiwCellDelegate: AnyObject {
    func didTapBookMark(index: Int)
    func didTapCourse(indexPath: IndexPath)
}

class HomeTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var viewAllCoursesButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var coursesData = [CourseModel]()
    var delegate: HomeTableVeiwCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coursesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        cell.markButton.tag = indexPath.row
        cell.markButton.addTarget(self, action: #selector(didTapMarkImage(_:)), for: .touchUpInside)
        cell.configureCell(course: coursesData[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didtapcourse(indexPath)
    }
    
    func didtapcourse(_ indexpath:IndexPath){
        delegate?.didTapCourse(indexPath: indexpath)
    }
    @objc func didTapMarkImage(_ sender: UIButton) {
        
        delegate?.didTapBookMark(index: sender.tag)
    }
}
