//
//  PopupHelper.swift
//  TradeAir
//
//  Created by Adeel on 08/10/2019.
//  Copyright © 2019 Buzzware. All rights reserved.
//

import UIKit
//import STPopup

//import SwiftEntryKit

class PopupHelper
{
    /// Show a popup using the STPopup framework [STPopup on Cocoapods](https://cocoapods.org/pods/STPopup)
    /// - parameters:
    ///   - storyBoard: the name of the storyboard the popup viewcontroller will be loaded from
    ///   - popupName: the name of the viewcontroller in the storyboard to load
    ///   - viewController: the viewcontroller the popup will be popped up from
    ///   - blurBackground: boolean to indicate if the background should be blurred
    /// - returns: -
    
    static let sharedInstance = PopupHelper() //<- Singleton Instance
    
    private init() { /* Additional instances cannot be created */ }
    static func alertWithField(title: String,message: String,qty: String,unit: String,part: String){
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Quantity"
            textField.text = qty
            textField.placeHolderColor = UIColor().colorsFromAsset(name: .blueColor)
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Unit"
            textField.text = unit
            textField.placeHolderColor = UIColor().colorsFromAsset(name: .blueColor)
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Part"
            textField.text = part
            textField.placeHolderColor = UIColor().colorsFromAsset(name: .blueColor)
        }
        let saveAction = UIAlertAction.init(title: "Save", style: .default) { (alertAction) in
            
        }
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .default) { (alertAction) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        
    }
    static func alertWithOk(title: String,message: String,controler:UIViewController){
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        let saveAction = UIAlertAction.init(title: "Ok", style: .default) { (alertAction) in
            //controler.navigationController?.popViewController(animated: true)
            controler.dismiss(animated: true)
        }
        
        alertController.addAction(saveAction)
        controler.present(alertController, animated: true, completion: nil)
        
        
        
    }
    
    static func alertWithOk(title: String, message: String, controler: UIViewController, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (alertAction) in
            controler.dismiss(animated: true)
            // Call the completion handler if it exists
            completion?()
        }
        
        alertController.addAction(okAction)
        controler.present(alertController, animated: true, completion: nil)
    }
    
    static func alertWithNetwork(title: String,message: String,controler:UIViewController){
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        let saveAction = UIAlertAction.init(title: "Ok", style: .default) { (alertAction) in
            
        }
        let settinfAction = UIAlertAction.init(title: "Setting", style: .destructive) { (alertAction) in
            if let url = URL(string:"App-Prefs:root=WIFI") {
                if UIApplication.shared.canOpenURL(url) {
                   UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
                else{
                    if let url = URL(string:UIApplication.openSettingsURLString){
                        if UIApplication.shared.canOpenURL(url) {
                           UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                    
                }
            }
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(settinfAction)
        controler.present(alertController, animated: true, completion: nil)
        
        
        
    }
    
    class func encodeImage(Image:UIImage) -> String{
        
        return Image.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""


    }
    class func decodeImage(imageString:String) -> UIImage{
        
        let imageData = Data(base64Encoded: imageString)
           let image = UIImage(data: imageData!)
           return image!
    }
    
    
    
    class func showAnimating(_ controler:UIViewController){

        controler.startAnimating(CGSize(width: controler.view.frame.width/2, height: controler.view.frame.width/4), message: "Loading...", type: .lineScale , fadeInAnimation: nil)
        
    }
    
    
    class func GotoLogin(){
    
        
        //CommonHelper.removeCachedUserData()
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let rootVC = storyboard.instantiateViewController(identifier: "LoginViewController") as! UINavigationController
        UIApplication.shared.windows.first?.rootViewController = rootVC
        
    }
    
    static func alertWithYesNo(title: String, message: String, controller: UIViewController, completion: @escaping (Bool) -> ()) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (alertAction) in
            completion(true)
        }
        
        let noAction = UIAlertAction(title: "No", style: .cancel) { (alertAction) in
            completion(false)
        }
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        controller.present(alertController, animated: true, completion: nil)
    }
    
    class func showAlertControllerWithError(forErrorMessage:String?, forViewController:UIViewController) -> () {
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: (forErrorMessage?.isEmpty == true) ? "Error occurred":forErrorMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: nil))
        DispatchQueue.main.async {
            forViewController.present(alert, animated: true, completion: nil)
        }
    }
    class func showAlertControllerWithErrorBack(forErrorMessage:String?, forViewController:UIViewController) -> () {
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: (forErrorMessage?.isEmpty == true) ? "Error occurred":forErrorMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: { (action) in
            forViewController.navigationController?.popViewController(animated: true)
        }))
        DispatchQueue.main.async {
            forViewController.present(alert, animated: true, completion: nil)
        }
    }
    class func showAlertControllerWithSucces(forErrorMessage:String?, forViewController:UIViewController) -> () {
        let alert = UIAlertController(title: NSLocalizedString("Success", comment: ""), message: (forErrorMessage?.isEmpty == true) ? "Error occurred":forErrorMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: nil))
        DispatchQueue.main.async {
            forViewController.present(alert, animated: true, completion: nil)
        }
    }
    class func showAlertControllerWithPending(forErrorMessage:String?, forViewController:UIViewController) -> () {
        let alert = UIAlertController(title: NSLocalizedString("Aproval Pending", comment: ""), message: (forErrorMessage?.isEmpty == true) ? "Error occurred":forErrorMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: nil))
        DispatchQueue.main.async {
            forViewController.present(alert, animated: true, completion: nil)
        }
    }
    
    class func showAlertControllerWithReject(forErrorMessage:String?, forViewController:UIViewController) -> () {
        let alert = UIAlertController(title: NSLocalizedString("Rejected", comment: ""), message: (forErrorMessage?.isEmpty == true) ? "Error occurred":forErrorMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: nil))
        DispatchQueue.main.async {
            forViewController.present(alert, animated: true, completion: nil)
        }
    }


    class func showAlertControllerWithSuccessBack(forErrorMessage:String?, forViewController:UIViewController) -> () {
        let alert = UIAlertController(title: NSLocalizedString("Success", comment: ""), message: (forErrorMessage?.isEmpty == true) ? "Error occurred":forErrorMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: { (action) in
            forViewController.navigationController?.popViewController(animated: true)
        }))
        DispatchQueue.main.async {
            forViewController.present(alert, animated: true, completion: nil)
        }
    }
    class func showAlertControllerWithSuccessLogout(forErrorMessage:String?, forViewController:UIViewController) -> () {
        let alert = UIAlertController(title: NSLocalizedString("Alert", comment: ""), message: (forErrorMessage?.isEmpty == true) ? "Error occurred":forErrorMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: { (action) in
            FirebaseData.logout()
        }))
        DispatchQueue.main.async {
            forViewController.present(alert, animated: true, completion: nil)
        }
    }
    class func showAlertControllerWithSuccessBackHome(forErrorMessage:String?, forViewController:UIViewController) -> () {
        let alert = UIAlertController(title: NSLocalizedString("Success", comment: ""), message: (forErrorMessage?.isEmpty == true) ? "Error occurred":forErrorMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: { (action) in
            forViewController.gotoHomebtn(forViewController)
        }))
        DispatchQueue.main.async {
            forViewController.present(alert, animated: true, completion: nil)
        }
    }
    class func showAlertControllerWithSuccessBackRoot(forErrorMessage:String?, forViewController:UIViewController) -> () {
        let alert = UIAlertController(title: NSLocalizedString("Success", comment: ""), message: (forErrorMessage?.isEmpty == true) ? "Error occurred":forErrorMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: { (action) in
            forViewController.navigationController?.popToRootViewController(animated: true)
        }))
        DispatchQueue.main.async {
            forViewController.present(alert, animated: true, completion: nil)
        }
    }
    class func showAlertControllerWithSuccessDissmiss(forErrorMessage:String?, forViewController:UIViewController) -> () {
        let alert = UIAlertController(title: NSLocalizedString("Success", comment: ""), message: (forErrorMessage?.isEmpty == true) ? "Error occurred":forErrorMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: { (action) in
            forViewController.dismiss(animated: true)
        }))
        DispatchQueue.main.async {
            forViewController.present(alert, animated: true, completion: nil)
        }
    }
    static func alertWithAppSetting(title: String,message: String,controler:UIViewController){
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction.init(title: "Ok", style: .default) { (alertAction) in
            
        }
        let settingAction = UIAlertAction.init(title: "Settings", style: .destructive) { (alertAction) in
            if let appSettings = URL(string: UIApplication.openSettingsURLString + Bundle.main.bundleIdentifier!) {
              if UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings)
              }
            }
        }
        alertController.addAction(okAction)
        alertController.addAction(settingAction)
        controler.present(alertController, animated: true, completion: nil)
        
        
        
    }
//    static func alertCardPaymentViewController(_ userServiceData:Bool? = nil,controler:UIViewController){
//
//        //let navcontroler = controler.storyboard?.instantiateViewController(identifier: "NavBookingViewController") as! UINavigationController
//        let control = controler.storyboard?.instantiateViewController(identifier: "CardViewController") as! CardViewController
//        control.delegate = controler
//        let popupController = STPopupController(rootViewController: control)
//
//        var size = CGSize(width: controler.view.frame.width/1.1, height: controler.view.frame.height/1.1)
//        if UIDevice.current.userInterfaceIdiom == .phone{
//            size.height = controler.view.frame.height/1.1
//
//        }
//        else{
//            size.height = controler.view.frame.height/0.5
//        }
//        control.contentSizeInPopup = size
//        //popupController.topViewController?.contentSizeInPopup = CGSize(width: controler.view.frame.width/1.1, height: controler.view.frame.height/1.1)
//        popupController.navigationBarHidden = true
//        popupController.topViewController?.view.backgroundColor = .clear
//        let blurEffect = UIBlurEffect(style: .dark)
//        popupController.backgroundView = UIVisualEffectView(effect: blurEffect)
//        popupController.containerView.backgroundColor = .clear
//        control.popup = popupController
//        popupController.present(in: controler)
//
//    }

//    static func alertTop(title:String,msg:String,uppercolor:UIColor.assetColors,lowercolor:UIColor.assetColors,controler:UIViewController){
//
//        var attributes = EKAttributes()
//        attributes.name = "Top Note"
//        EKAttributes.Precedence.QueueingHeuristic.value = .priority
//        attributes.precedence = .enqueue(priority: .normal)
//        attributes.precedence.priority = .normal
//        attributes.displayDuration = 2
//        attributes.entryBackground = .color(color: .init(light: UIColor().colorsFromAsset(name: uppercolor), dark: UIColor().colorsFromAsset(name: lowercolor)))
//
//        let title = EKProperty.LabelContent(text: title, style: .init(font: UIFont(name: "Montserrat-Regular", size: 15)!, color: .white))
//        let description = EKProperty.LabelContent(text: msg, style: .init(font: UIFont(name: "Montserrat-Regular", size: 13)!, color: .white))
//        let simpleMessage = EKSimpleMessage(title: title, description: description)
//        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
//
//        let contentView = EKNotificationMessageView(with: notificationMessage)
//        SwiftEntryKit.display(entry: contentView, using: attributes)
//        if SwiftEntryKit.isCurrentlyDisplaying(entryNamed: "Top Note") {
//            /* Do your things */
//            SwiftEntryKit.dismiss(.enqueued)
//        }
//    }
//    static func alertMid(title:String,msg:String,uppercolor:UIColor.assetColors,lowercolor:UIColor.assetColors,controler:UIViewController){
//
//        var attributes = EKAttributes.centerFloat
//        attributes.name = "Top Note"
//        EKAttributes.Precedence.QueueingHeuristic.value = .priority
//        attributes.windowLevel = .alerts
//        attributes.position = .center
//        attributes.precedence = .enqueue(priority: .normal)
//        attributes.precedence.priority = .normal
//        attributes.displayDuration = 2
//        attributes.entryBackground = .color(color: .init(light: UIColor().colorsFromAsset(name: uppercolor), dark: UIColor().colorsFromAsset(name: lowercolor)))
//
//        let title = EKProperty.LabelContent(text: title, style: .init(font: UIFont(name: "Montserrat-Regular", size: 15)!, color: .white))
//        let description = EKProperty.LabelContent(text: msg, style: .init(font: UIFont(name: "Montserrat-Regular", size: 13)!, color: .white))
//        let simpleMessage = EKSimpleMessage(title: title, description: description)
//        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
//
//        let contentView = EKNotificationMessageView(with: notificationMessage)
//        SwiftEntryKit.display(entry: contentView, using: attributes)
//        if SwiftEntryKit.isCurrentlyDisplaying(entryNamed: "Top Note") {
//            /* Do your things */
//            SwiftEntryKit.dismiss(.enqueued)
//        }
//    }
}

