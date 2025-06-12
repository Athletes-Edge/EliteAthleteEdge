//
//  BadgeViewController.swift
//  EliteAthleteEdge
//
//  Created by ali john on 27/05/2025.
//

import UIKit

class BadgeViewController: UIViewController {

    @IBOutlet weak var collectionview:UICollectionView!
    var badgeArray = [BadgeModel]()
    
    private let spacingIphone:CGFloat = 16
    private let spacingIpad:CGFloat = 16
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionview.createDirectionCollection(8,.vertical)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension BadgeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.badgeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BadgeCollectionViewCell", for: indexPath) as! BadgeCollectionViewCell
    
        cell.ivImage.imageURL(self.badgeArray[indexPath.row].icon ?? "")
        cell.lblName.text = self.badgeArray[indexPath.row].title ?? ""
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRows:CGFloat = 2
        let spacingBetweenCellsIphone:CGFloat = 8
        
        let totalSpacing = (2 * spacingBetweenCellsIphone) + ((numberOfItemsPerRows - 1) * spacingBetweenCellsIphone)
        let width = (collectionView.bounds.width - totalSpacing)/numberOfItemsPerRows
        return CGSize(width: width , height: width + 10)
        
    }
    
}
