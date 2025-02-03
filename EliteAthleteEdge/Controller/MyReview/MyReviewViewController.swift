//
//  MyReviewViewController.swift
//  Athlete
//
//  Created by ali john on 05/11/2024.
//

import UIKit

class MyReviewViewController: UIViewController {

    @IBOutlet weak var tableView:UITableView!
    var reviewArray = [ReviewModel]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @objc func deleteBtn(_ sender:UIButton){
        PopupHelper.showAnimating(self)
        FirebaseData.deleteReview(uid: self.reviewArray[sender.tag].docId) { error in
            self.stopAnimating()
            if let error = error{
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            self.reviewArray.remove(at: sender.tag)
            self.tableView.reloadData()
        }
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
extension MyReviewViewController:UITableViewDelegate,UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.reviewArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyReviewTableViewCell", for: indexPath) as! MyReviewTableViewCell
        let data = self.reviewArray[indexPath.row]
        cell.lblName.text = data.details
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(self.deleteBtn(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
