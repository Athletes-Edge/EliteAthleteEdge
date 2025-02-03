//
//  SearchViewController.swift
//  athletes
//
//  Created by Mac on 05/08/2024.
//
struct searchData{
    
    var name:String
    var array:[data1]
    
}
struct data1{
    var name:String
    var isSelect:Bool
}

import UIKit
import AlignedCollectionViewFlowLayout
import LGSideMenuController

protocol SearchViewControllerDelegate: NSObject {
    func filterData(categories:[CategoryModel],topSearch: [CourseModel])
}

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var ivtableView: UITableView!
    
    var topFiveSearch = [CourseModel]()
    var categoryArray = [CategoryModel]()
    var delegate: SearchViewControllerDelegate?
    private let spacingIphone:CGFloat = 16
    private let spacingIpad:CGFloat = 16
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self // Set the delegate

    }
    
    
    
    
    private func getSelectedData() -> (topSearches: [CourseModel], categories: [CategoryModel]) {
          var selectedTopSearches: [CourseModel] = []
          var selectedCategories: [CategoryModel] = []
          
          // Loop through the array and get selected data
        selectedCategories = categoryArray.filter({$0.isselect})
        selectedTopSearches = topFiveSearch.filter( { $0.isselect })
          
          return (selectedTopSearches, selectedCategories)
      }
    
    private func filterData(with searchText: String) {
//        var filteredArray = [searchData]()
//        // Filter top searches
//        let filteredTopSearches = topFiveSearch.filter { $0.title.lowercased().contains(searchText.lowercased()) }
//        if !filteredTopSearches.isEmpty {
//            filteredArray.append(searchData(name: "TOP SEARCHES", array: filteredTopSearches.map { data1(name: $0, isSelect: false) }))
//        }
//
//        // Filter categories
//        let filteredCategories = categoryName.filter { $0.lowercased().contains(searchText.lowercased()) }
//        if !filteredCategories.isEmpty {
//            filteredArray.append(searchData(name: "CATEGORIES", array: filteredCategories.map { data1(name: $0, isSelect: false) }))
//        }
//
//        // Handle no results
//        if filteredArray.isEmpty {
//            filteredArray.append(searchData(name: "No Results", array: []))
//        }
//
//        self.array = filteredArray
//        ivtableView.reloadData()
    }

  }

extension SearchViewController:UITableViewDelegate,UITableViewDataSource{
    
    
    @objc func showrestuls(_ sender:UIButton){
        let result = getSelectedData()
//        let vc = UIStoryboard.storyBoard(withName: .Search).loadViewControllersss(withIdentifier: "SearchResultsViewController")
//        self.sideMenuController?.rootViewController = vc
        self.delegate?.filterData(categories: result.categories, topSearch: result.topSearches)
        self.navigationController?.popToRootViewController(animated: true)

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = Bundle.main.loadNibNamed("HeaderView", owner: self)?.first as! HeaderView
        switch section {
        case 0:
            headerView.lblname.text = "TOP SEARCHES"
        case 1:
            headerView.lblname.text = "CATEGORIES"
        default:
            break
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2{
            return 0.0
        }
        else{
            return 25.0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1{
            return self.categoryArray.count
        }
        else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TopCollectionTableViewCell", for: indexPath) as! TopCollectionTableViewCell
            
            let view = UIView()
            view.backgroundColor = .clear
            cell.selectedBackgroundView = view
            
            cell.ivCollection.dataSource = self
            cell.ivCollection.delegate = self
            
            
            let alignedFlowLayout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
            
            alignedFlowLayout.minimumLineSpacing = 10
            alignedFlowLayout.minimumLineSpacing = 10
            
            cell.ivCollection.collectionViewLayout = alignedFlowLayout
            cell.ivCollection.showsVerticalScrollIndicator = false
            
            cell.ivCollection.reloadData()
            
            cell.ivCollection.tag = indexPath.section
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                
                cell.updateCollectionViewHeight()
            }
            
            return cell
        }
        else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "buttonTableViewCell", for: indexPath) as! buttonTableViewCell
            
            let view = UIView()
            view.backgroundColor = .clear
            cell.selectedBackgroundView = view
            
            cell.btnseerestults.addTarget(self, action: #selector(self.showrestuls), for: .touchUpInside)
            
            
            return cell
        }

        else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckMarkTableTableViewCell", for: indexPath) as! CheckMarkTableTableViewCell
            
            let view = UIView()
            view.backgroundColor = .clear
            cell.selectedBackgroundView = view
            
            let data = self.categoryArray[indexPath.row]
            
            if data.isselect{
                cell.btncheckmark.setImage(UIImage(named: "checked")!, for: .normal)
            }
            else{
                cell.btncheckmark.setImage(UIImage(named: "uncheck")!, for: .normal)
                
            }
            
            cell.lblname.text = data.title
            
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.categoryArray[indexPath.row].isselect{
            
            self.categoryArray[indexPath.row].isselect = false
        }
        else{
            
            self.categoryArray[indexPath.row].isselect = true
            
        }
        tableView.reloadData()
    }
    
}
extension SearchViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.topFiveSearch.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as! SearchCollectionViewCell
        
        let data = self.topFiveSearch[indexPath.row]
        
        cell.lblnae.text = data.title
        
        if data.isselect{
            cell.lblnae.textColor = UIColor().colorsFromAsset(name: .blueColor)
            cell.ivView.backgroundColor = UIColor().colorsFromAsset(name: .blue33)
            cell.ivView.borderColor = UIColor().colorsFromAsset(name: .blueColor)
        }
        else{
            cell.lblnae.textColor = .black
            cell.ivView.backgroundColor = .clear
            cell.ivView.borderColor = .lightGray
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfItemsPerRow:CGFloat = 2
        let spacingBetweenCellsIphone:CGFloat = 8
        let spacingBetweenCellsIpad:CGFloat = 16
        
        if UIDevice.current.userInterfaceIdiom == .phone{
            let data = self.topFiveSearch[indexPath.row]
            let label = UILabel(frame: CGRect.zero)
            label.text =  data.title
            label.sizeToFit()
            
            return CGSize(width: label.frame.width + 32, height: 40)
            
        }
        else{
            
            let totalSpacing = (2 * self.spacingIpad) + ((numberOfItemsPerRow - 1) * spacingBetweenCellsIpad) //Amount of total spacing in a row
            
            let width = (collectionView.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width , height: width - spacingBetweenCellsIpad * 2)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        for (i,e) in  self.topFiveSearch.enumerated(){
            
            self.topFiveSearch[indexPath.row].isselect = false
            
        }
        
        self.topFiveSearch[indexPath.row].isselect = true
        
        collectionView.reloadData()
        
    }
    
}

extension SearchViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Update the text field's text
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        // Call the filter function with the updated text
        //filterCourses()
        
        return true
    }
    
    func filterCourses() {
        guard let searchText = searchTextField.text?.lowercased(), !searchText.isEmpty else {
           //setupFilterData()
            return
        }
        self.filterData(with: searchText)
    }

}
