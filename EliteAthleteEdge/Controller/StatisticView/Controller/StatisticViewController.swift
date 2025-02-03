//
//  StatisticViewController.swift
//  athletes
//
//  Created by Mac on 06/08/2024.
//


struct dataStats{
    
    var name:String
    var details:String
    var colorbg:UIColor?
    var icon:UIImage
    
}

import UIKit

class StatisticViewController: UIViewController {

    @IBOutlet weak var ivtbalview: UITableView!
    
    
    var array = [
        
        dataStats(name: "TIME SPENT", details: "30.5 hours", colorbg: UIColor().colorsFromAsset(name: .blue33), icon: UIImage(named: "Icon book")!),
        dataStats(name: "AVAERAGE/DAY", details: "4.6 hours", colorbg: UIColor().colorsFromAsset(name: .orangeColor30), icon: UIImage(named: "Icon chart bar")!),
        dataStats(name: "FINISHED COURSES", details: "12 Courses", colorbg: UIColor().colorsFromAsset(name: .greenColor30), icon: UIImage(named: "Icon check double")!)
    
    
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

 

}
extension StatisticViewController:UITableViewDelegate,UITableViewDataSource{
    
    
    @objc func btngotoansers(_ sender:UIButton){
        
    
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = Bundle.main.loadNibNamed("HeaderView", owner: self)?.first as! HeaderView
        
        if section == 0{
            headerView.lblname.text = "This Week"

        }
        else{
            headerView.lblname.text = "My Performance"

        }
        
        return headerView
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 35.0

        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1{
            return self.array.count

        }
        else{
            return 1

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticLineTableViewCell", for: indexPath) as! StatisticLineTableViewCell
            
            let view = UIView()
            view.backgroundColor = .clear
            cell.selectedBackgroundView = view
            
            
            
            return cell
           

        }
        else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticCEllTableViewCell", for: indexPath) as! StatisticCEllTableViewCell
            
            let view = UIView()
            view.backgroundColor = .clear
            cell.selectedBackgroundView = view
            
            
            cell.ivivew.backgroundColor = self.array[indexPath.row].colorbg
            
            cell.ivicon.image = self.array[indexPath.row].icon
            cell.lblname.text = self.array[indexPath.row].name
            cell.lbldetais.text = self.array[indexPath.row].details

            
            return cell

        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
