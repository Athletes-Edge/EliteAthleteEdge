//
//  UIViewController+Additions.swift
//  TradeAir
//
//  Created by Adeel on 08/10/2019.
//  Copyright © 2019 Buzzware. All rights reserved.
//

import UIKit
import PhotosUI
import LGSideMenuController

class UIViewController_Additions: NSObject {

}
enum UserType:String{
    case normal = "normal"
    case serviceProvider = "serviceProvider"
}

extension UIViewController {
    
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func backToRootAction() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func dismissVCAction() {
        self.dismiss(animated: true) {
            
        }
    }
    @IBAction func gotoSearchBtn(_ sender:Any){
        let vc = UIStoryboard.storyBoard(withName: .Search).loadViewController(withIdentifier: .SearchResultsViewController)
        self.sideMenuController?.rootViewController = vc
    }
    
    
    
    @IBAction func gotoHomebtn(_ sender:Any){
        let vc = UIStoryboard.storyBoard(withName: .Home).loadViewController(withIdentifier: .HomeViewController)
        self.sideMenuController?.rootViewController = vc
    }
    @IBAction func gotoVideoBtn(_ sender:Any){
        let vc = UIStoryboard.storyBoard(withName: .Courses).loadViewController(withIdentifier: .CoursesViewController)
        self.sideMenuController?.rootViewController = vc
    }
    @IBAction func gotoSettingBtn(_ sender:Any){
        let vc = UIStoryboard.storyBoard(withName: .Saved).loadViewController(withIdentifier: .SavedViewController)
        self.sideMenuController?.rootViewController = vc
    }
    @IBAction func gotoProfileBtn(_ sender:Any){
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileViewController")
        self.sideMenuController?.rootViewController = vc
    }
    
    func takePhoto(btn:UIView,mediaType:MediaType,message:String){
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    print("OKAY")
                } else {
                    print("NOTOKAY")
                }
            })
        }
        checkLibrary(btn: btn,mediaType:mediaType, message: message)
        checkPermission(btn: btn,mediaType:mediaType, message: message)
    }
}
extension UIViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate, UNUserNotificationCenterDelegate{
    func displayUploadImageDialog(btnSelected: UIView,mediaType:MediaType,Message:String) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.accessibilityHint = btnSelected.accessibilityHint
        picker.mediaTypes = [mediaType.rawValue]
        let alertController = UIAlertController(title: "", message: Message, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            alertController.dismiss(animated: true) {() -> Void in }
        })
        alertController.addAction(cancelAction)
        let cameraRollAction = UIAlertAction(title: "Open library", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            if UIDevice.current.userInterfaceIdiom == .pad {
                OperationQueue.main.addOperation({() -> Void in
                    picker.sourceType = .photoLibrary
                    self.present(picker, animated: true) {() -> Void in }
                })
            }
            else {
                picker.sourceType = .photoLibrary
                self.present(picker, animated: true) {() -> Void in }
            }
        })
        alertController.addAction(cameraRollAction)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (alertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                if UIDevice.current.userInterfaceIdiom == .pad {
                    OperationQueue.main.addOperation({() -> Void in
                        picker.sourceType = .camera
                        self.present(picker, animated: true) {() -> Void in }
                    })
                }
                else {
                     
                    picker.sourceType = .camera
                    self.present(picker, animated: true) {() -> Void in }
                }
            }
            else{
                
            }

        }
        alertController.addAction(cameraAction)
        alertController.view.tintColor = .label
        if UIDevice.current.userInterfaceIdiom == .pad{
            alertController.modalPresentationStyle = .popover
            if let popoverPresentationController = alertController.popoverPresentationController {
             
                popoverPresentationController.permittedArrowDirections = .left
                popoverPresentationController.sourceView = btnSelected
                alertController.preferredContentSize = CGSize(width: UIScreen.main.bounds.width/5, height: UIScreen.main.bounds.height/9)
                popoverPresentationController.sourceRect = btnSelected.frame
            }
        }
        present(alertController, animated: true) {() -> Void in }
    }

    

//    func checkLocationPermission() -> Bool{
//        let authStatus = CLLocationManager.authorizationStatus()
//        switch authStatus {
//
//        case .authorizedWhenInUse, .authorizedAlways:
//            return true
//        case .denied:
//            print("Error")
//            let manag = CLLocationManager()
//            manag.requestLocation()
//
//            return false
//        default:
//            return false
//        }
//    }
    func checkPermission(btn: UIView,mediaType:MediaType,message:String) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .authorized:
            self.displayUploadImageDialog(btnSelected: btn,mediaType:mediaType, Message: message)
        case .denied:
            print("Error")
        default:
            break
        }
    }
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }


    func checkLibrary(btn:UIView,mediaType:MediaType,message:String) {
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .authorized {
            switch photos {
            case .authorized:
                self.displayUploadImageDialog(btnSelected: btn,mediaType:mediaType, Message: message)
            case .denied:
                print("Error")
            default:
                break
            }
        }
    }
}









extension UIViewController{

    func imagetoString(image:UIImage) -> String{
        let data = image.pngData()
        let str = data!.base64EncodedString()
        return str
    }
    func rationalApproximationOf(x0 : Double, withPrecision eps : Double = 1.0E-6) -> Rational {
        var x = x0
        var a = floor(x)
        var (h1, k1, h, k) = (1, 0, Int(a), 1)
        
        while x - a > eps * Double(k) * Double(k) {
            x = 1.0/(x - a)
            a = floor(x)
            (h1, k1, h, k) = (h, k, h1 + Int(a) * h, k1 + Int(a) * k)
        }
        return (h, k)
    }
    func fractionMutableAttributedString(for string: String,  color:UIColor, size: CGFloat, weight: UIFont.Weight) -> NSAttributedString {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: color, .font: UIFont.systemFont(ofSize: size, weight: weight)]
        //let str = string.replacingOccurrences(of: " ", with: " ", options: .literal, range: string.range(of: " kg"))
        let attributedText = NSMutableAttributedString(string: string, attributes: attributes)
        
        let substring = string.split(separator: " ") // Do we have a fractional value?
        if substring[0].contains("/") {
            let range = (string as NSString).range(of: String(substring[0]))
            //let simpletext = attributedText.string.replacingOccurrences(of: " ", with: "")
            //attributedText = NSMutableAttributedString(string: simpletext, attributes: attributes )
            attributedText.addAttribute(NSAttributedString.Key.font, value: UIFont.fractionFont(ofSize: size,weight: weight), range: range)
        }
        else if substring[1].contains("/"){
            let range = (string as NSString).range(of: String(substring[1]))
            //let simpletext = attributedText.string.replacingOccurrences(of: " ", with: "")
            //attributedText = NSMutableAttributedString(string: simpletext, attributes: attributes )
            attributedText.addAttribute(NSAttributedString.Key.font, value: UIFont.fractionFont(ofSize: size,weight: weight), range: range)
        }
        
        
        return attributedText
        
    }
    func getDirectoryPath(isImage:Bool = false) -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        var documentsDirectory = paths[0] as String
        if isImage{
            
            documentsDirectory = (paths[0] as NSString).appendingPathComponent("Images") as String
            
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: documentsDirectory){
                return documentsDirectory
            }
            else{
                do{
                    try fileManager.createDirectory(atPath: documentsDirectory, withIntermediateDirectories: true, attributes: nil)
                    return documentsDirectory
                }
                catch{
                    print(error)
                    return ""
                }
            }
        }
        else{
            
            return documentsDirectory
        }
        
    }
    
}
