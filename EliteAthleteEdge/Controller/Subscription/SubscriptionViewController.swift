//
//  SubscriptionViewController.swift
//  Athlete
//
//  Created by ali john on 31/10/2024.
//

import UIKit

class SubscriptionViewController: UIViewController {

    @IBOutlet weak var monthView:UIView!
    @IBOutlet weak var yearView:UIView!
    
    var isMonth = false
    var delegate:UIViewController!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func monthTapped(_ sender:Any){
        self.isMonth = true
        self.monthView.backgroundColor = .pinnk
        self.yearView.backgroundColor = .white
    }
    @IBAction func yearTapped(_ sender:Any){
        self.isMonth = false
        self.monthView.backgroundColor = .white
        self.yearView.backgroundColor = .pinnk
    }
    @IBAction func upgradeBtnPressed(_ sender:Any){
        let vc = UIStoryboard.storyBoard(withName: .Courses).loadViewController(withIdentifier: .SelectCardPaymentViewController) as! SelectCardPaymentViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        if self.isMonth{
            vc.ammount = 6.99
        }
        else{
            vc.ammount = 65.00
        }
        vc.delegate = self
        self.present(vc, animated: true)
       
    }
    func addCard(list: [CardModel]){
        let vc = UIStoryboard.storyBoard(withName: .Courses).loadViewController(withIdentifier: .AddCardViewController) as! AddCardViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.cardArray = list
        if self.isMonth{
            vc.ammount = 6.99
        }
        else{
            vc.ammount = 65.00
        }
        vc.delegate = self
        self.present(vc, animated: true)
    }
    @IBAction func termTapped(_ sender:Any){
        UIApplication.shared.open(URL(string: Constant.term_key)!)
    }
    @IBAction func privacyTapped(_ sender:Any){
        UIApplication.shared.open(URL(string: Constant.privacy_key)!)
    }
    func createSubscription(pm_id:String){
        PopupHelper.showAnimating(self)
        let uss = UserModel()
        uss.isSubsCribed = true
        uss.pm_id = pm_id
        FirebaseData.updateUserData(FirebaseData.getCurrentUserId(), dic: uss) { error in
            
            if let error = error{
                self.stopAnimating()
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            
            let submo = SubcribModel()
            if self.isMonth{
                submo.endDate = Date().add(days: 30).milisecondInt64
                submo.plan = "month"
                submo.fee = 6.99
            }
            else{
                submo.endDate = Date().add(days: 365).milisecondInt64
                submo.plan = "year"
                submo.fee = 65.00
            }
            submo.startDate = Date().milisecondInt64
            submo.createdDate = Date().milisecondInt64
            submo.userId = FirebaseData.getCurrentUserId()
            submo.status = "active"
            
            FirebaseData.saveSubscriptionData(uid: UUID().uuidString, userData: submo) { error in
                
                self.stopAnimating()
                if let err = error{
                    PopupHelper.showAlertControllerWithError(forErrorMessage: err.localizedDescription, forViewController: self)
                    return
                }
                self.dismiss(animated: true) {
                    switch self.delegate{
                    case let controller as HomeViewController:
                        PopupHelper.showAlertControllerWithSuccessBackHome(forErrorMessage: "Your subscription is created successfully", forViewController: self.delegate)
                    default:
                        PopupHelper.showAlertControllerWithSuccessBackRoot(forErrorMessage: "Your subscription is created successfully", forViewController: self.delegate)
                    }
                    
                }
            }
            
            //PopupHelper.showAlertControllerWithSuccessDissmiss(forErrorMessage: "Your subscription is created successfully", forViewController: self)
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
