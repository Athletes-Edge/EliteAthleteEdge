//
//  LoginViewController.swift
//  athletes
//
//  Created by ali john on 05/08/2024.
//

import UIKit
import LGSideMenuController

class LoginViewController: UIViewController {
    @IBOutlet weak var teamTitle: UILabel!
    @IBOutlet weak var passwordTextField: UITexfield_Additions!
    @IBOutlet weak var emailTextField: UITexfield_Additions!
    var email = ""
    var teamid = ""
    var teamname = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }
    
    private func setupController() {
        self.emailTextField.text = email
        if teamname.isEmpty{
            self.teamTitle.text = "Enter your email and password below"
        }
        else{
            self.teamTitle.text = "Join \(teamname) now!"
        }
        
    }
    
    private func validateFields() -> Bool {
        if emailTextField.text?.isEmpty ?? true {
            showAlert(title: "Error", message: "Please enter your email.")
            return false
        }
        if passwordTextField.text?.isEmpty ?? true {
            showAlert(title: "Error", message: "Please enter the password.")
            return false
        }
        return true
    }
    
    private func showAlert(title: String, message: String) {
        PopupHelper.alertWithOk(title: title, message: message, controler: self)
    }
    
    private func gotToHome() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let homeControlle = storyboard.instantiateViewController(withIdentifier: "LGSideMenuController") as! LGSideMenuController
        UIApplication.shared.setRootViewController(homeControlle)
    }
    
        
    
    @IBAction func didTapLoginButton(_ sender: UIButton) {
        if validateFields() {
            PopupHelper.showAnimating(self)
            FirebaseData.loginUserData(email: emailTextField.text ?? "", password: passwordTextField.text ?? "") { result, error in
                if (result?.user) != nil {
                    FirebaseData.getUserData(uid: FirebaseData.getCurrentUserId()) { error, userData in
                        let userModel = UserModel()
                        userModel.email = result?.user.email ?? ""
                        FirebaseData.updateUserData(result?.user.uid ?? "", dic: userModel) { error in
                            self.stopAnimating()
                            if let role = userData?.userRole,role == UserRole.user.rawValue{
                                if let isveri = userData?.isVerified,isveri{
                                    self.gotToHome()
                                }
                                else{
                                    PopupHelper.showAlertControllerWithSuccessLogout(forErrorMessage: "Your email is not verified", forViewController: self)
                                }
                            }
                            else{
                                PopupHelper.showAlertControllerWithSuccessLogout(forErrorMessage: "This email is not use for user", forViewController: self)
                            }
                            
                        }
                    }
                    
                } else {
                    self.stopAnimating()
                    PopupHelper.alertWithOk(title: "Error", message: error?.localizedDescription ?? "", controler: self)
                }
            }
        }
    }

    
    @IBAction func didTapSignUpButton(_ sender: UIButton) {
        self.signup()
    }
    func signup(email:String? = nil){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        vc.email = email
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnforget(_ sender: Any) {
        
        
        let alertController = UIAlertController(title: "Forgot Password?", message: "Please enter a valid email", preferredStyle: .alert)
        let sendAction = UIAlertAction(title: "Send", style: .default) { action in
            if let textfield = alertController.textFields?.first{
                if textfield.text!.isValidEmail(){
                    self.forgot(email: textfield.text!)
                }
                else{
                    PopupHelper.showAlertControllerWithError(forErrorMessage: "Invalid Email", forViewController: self)
                }
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default) { action in
            
        }
        alertController.addTextField(configurationHandler: { textfield in
            textfield.placeholder = "Enter Email"
        })
        alertController.addAction(sendAction)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
        
    }
    func forgot(email:String){
        PopupHelper.showAnimating(self)
        
        FirebaseData.forgotUserPassword(email: email) { error in
            self.stopAnimating()
            if let error = error {
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            PopupHelper.showAlertControllerWithSucces(forErrorMessage: "Please check your email to chnage yout password link.", forViewController: self)
        }
    }
}
extension LoginViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        switch textField{
        case self.emailTextField:
            self.passwordTextField.becomeFirstResponder()
        case self.passwordTextField:
            textField.resignFirstResponder()
        default:
            break
        }
        return true
    }
}
