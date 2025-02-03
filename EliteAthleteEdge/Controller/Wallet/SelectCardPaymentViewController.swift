//
//  SelectCardPaymentViewController.swift
//  irideapp
//
//  Created by ali john on 16/05/2024.
//

import UIKit

import Stripe
class SelectCardPaymentViewController: UIViewController {

    @IBOutlet weak var cardTableView:UITableView!
    @IBOutlet weak var lblAmount:UILabel!
    @IBOutlet weak var btnAdd:UIButton!
    var cardArray = [CardModel]()
    var user:UserModel!
    var delegate = UIViewController()
    var ammount: Double!
    var charge: Double! = 0
    var type:String!
    var paymentIntentClientSecret = ""
    var isSubcribe = false
    //var isTip = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblAmount.text = "$\(self.ammount.roundToPlaces(places: 2))0"
        self.loadData()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    @IBAction func addCardBtnPressed(_ sender:Any){
        self.dismiss(animated: true){
            switch self.delegate{
            case let controller as SubscriptionViewController:
                controller.addCard(list:self.cardArray)
                
            
            default:
                break
            }
        }
    }
    func loadData(){
        self.callFirebase()
    }
    
    func callFirebase(){
        PopupHelper.showAnimating(self)
        FirebaseData.getUserData(uid: FirebaseData.getCurrentUserId()) { error, userData in
            
            if let err = error{
                self.stopAnimating()
                PopupHelper.showAlertControllerWithError(forErrorMessage: err.localizedDescription, forViewController: self)
                return
            }
            guard let userData = userData else{return}
            self.user = userData
            if userData.stripeCustid == nil{
                PopupHelper.showAnimating(self)
                var data = [String:Any]()
                data[UserKeys.email.rawValue] = userData.email
                data[BookingKeys.userId.rawValue] = FirebaseData.getCurrentUserId()
                self.callWebService(data: data, action: .checkcustidexistornot, .post)
            }
            else{
                self.loadCardData()
            }
            
        }
    }
    func loadCardData(){
        PopupHelper.showAnimating(self)
        var data = [String:Any]()
        data[Constant.cus_id] = self.user.stripeCustid
        self.callWebService(data: data, action: .paymentMethods, .post)
    }
    func SimplePaymentSubcription() {
        
        PopupHelper.showAnimating(self)
        var dataDic = [String:Any]()
        dataDic[Constant.email] = self.user.email
        dataDic[Constant.cus_id] = self.user.stripeCustid
        dataDic[Constant.price] = Int((self.ammount ?? 1) * 100)
        dataDic[Constant.recurring] = self.type
        dataDic[Constant.interval_count] = 1
        
        
        self.callWebService(data:dataDic,action:.createsubscription,.post)
        
    }
    func callWebService(_ id:String? = nil,data: [String:Any]? = nil, action:webserviceUrl,_ httpMethod:httpMethod,_ index:Int? = nil){
        
        WebServicesHelper.callWebService(Parameters: data,suburl: id, action: action, httpMethodName: httpMethod,index) { (indx,action,isNetwork, error, dataDict) in
            self.stopAnimating()
            if isNetwork{
                if let err = error{
                    PopupHelper.showAlertControllerWithError(forErrorMessage: err, forViewController: self)
                }
                else{
                    if let dic = dataDict as? Dictionary<String,Any>{
                        switch action {
                        case .paymentMethods:
                            if let cards = dic["paymentMethods"] as? [[String:Any]]{
                                self.cardArray.removeAll()
                                for card in cards{
                                    self.cardArray.append(CardModel(dictionary: card)!)
                                }
                                self.cardTableView.reloadData()
                                
                            }
                            else if let msg = dic[Constant.message] as? String{
                                PopupHelper.showAlertControllerWithError(forErrorMessage: msg, forViewController: self)
                            }
                        case .accoutpaymentnew:
                            if let data = dic["transferinfo"] as? String{
                                self.stripeSimplePayment1(data)
                            }
                            else if let msg = dic[Constant.message] as? String{
                                PopupHelper.showAlertControllerWithError(forErrorMessage: msg, forViewController: self)
                            }
                        case .checkcustidexistornot:
                            if let data = dic["cust_id"] as? String{
                                self.user.stripeCustid = data
                                let use = UserModel()
                                use.stripeCustid = data
                                FirebaseData.updateUserData(FirebaseData.getCurrentUserId(), dic: use) { error in
                                    
                                }
                                self.loadCardData()
                                
                            }
                        case .detatch:
                            self.cardArray.remove(at: indx ?? 0)
                            self.cardTableView.reloadData()
                        case .createsubscription:
                            
                            if let SubsData = dic["data"] as? Dictionary<String,Any>{
                                
                                if let dataa = SubsData["subscription_id"] as? String{
                                    
                                    switch self.delegate{
                                    case let controller as SubscriptionViewController:
                                        controller.createSubscription(pm_id: dataa)
                                        
                                    default:
                                        break
                                    }

                                }
                            }
                        default:
                            break
                        }
                        
                    }
                    else{
                        PopupHelper.showAlertControllerWithError(forErrorMessage: "something went wrong", forViewController: self)
                    }
                }
            }
            else{
                PopupHelper.alertWithNetwork(title: "Network Connection", message: "Please connect your internet connection", controler: self)
                
            }
        }
    }
    func SimplePayment1(pm_id:String) {
        PopupHelper.showAnimating(self)
        var dataDic = [String:Any]()
        dataDic[Constant.cus_id] = self.user.stripeCustid
        dataDic[Constant.pm_id] = pm_id
        dataDic[Constant.amount] = Int(((self.ammount ?? 1) + self.charge) * 100)
        self.callWebService(data:dataDic,action:.accoutpaymentnew,.post)
    }
    func stripeSimplePayment1(_ paymentIntentClientSecret:String) {
        PopupHelper.showAnimating(self)
        
        
        
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: paymentIntentClientSecret)
        //paymentIntentParams.paymentMethodParams = paymentMethodParams
        //paymentIntentParams.setupFutureUsage = .offSession
        
        // Submit the payment
        let paymentHandler = STPPaymentHandler.shared()
        paymentHandler.confirmPayment(paymentIntentParams, with: self) { (status, paymentIntent, error) in
            self.stopAnimating()
            switch (status) {
            case .failed:
                PopupHelper.showAlertControllerWithError(forErrorMessage: error?.localizedDescription, forViewController: self)
                
            case .canceled:
                PopupHelper.showAlertControllerWithError(forErrorMessage: error?.localizedDescription, forViewController: self)
                
                
            case .succeeded:
                print(paymentIntent?.paymentMethodId)
                switch self.delegate{
                case let controller as SubscriptionViewController:
                    self.dismiss(animated: true) {
                        controller.createSubscription(pm_id: paymentIntentClientSecret)
                    }
                
                default:
                    break
                }
                
            @unknown default:
                fatalError()
                break
            }
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender:Any){
        
        self.dismissVCAction()
    }
    @objc func deleteCard(_ sender:UIButton){
        PopupHelper.showAnimating(self)
        var data = [String:Any]()
        data["pm_id"] = self.cardArray[sender.tag].id
        self.callWebService(data: data, action: .detatch, .post,sender.tag)
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

extension SelectCardPaymentViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cardArray.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CardListTableViewCell
        if let card = self.cardArray[indexPath.row].last4{
            cell.lblCardNumber.text = "**** **** **** \(card)"

        }
        if let exp_year = self.cardArray[indexPath.row].exp_year,let exp_month = self.cardArray[indexPath.row].exp_month{
            cell.lblCardExpiry.text = "\(exp_month)/\(exp_year)"
        }
        if let card = self.cardArray[indexPath.row].brand{
            cell.ivCardType.image = UIImage(named: "stp_card_\(card)")

        }
        cell.btnDelete.addTarget(self, action: #selector(self.deleteCard(_:)), for: .touchUpInside)
        cell.btnDelete.tag = indexPath.row
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Alert", message: "Are you sure want to pay from this card", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { action in
            if self.isSubcribe{
                self.SimplePaymentSubcription()
            }
            else{
                self.SimplePayment1(pm_id: self.cardArray[indexPath.row].id)
            }
            
        }
        let noAction = UIAlertAction(title: "No", style: .default) { action in
            
        }
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        
        return true
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, sourceView, completionHandler) in
                print("index path of delete: \(indexPath)")
            let btn = UIButton()
            btn.tag = indexPath.row
            self.deleteCard(btn)
            
                completionHandler(true)
            }
        delete.backgroundColor = UIColor.red

            let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
            swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
        
    }
    
}
extension SelectCardPaymentViewController: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}
