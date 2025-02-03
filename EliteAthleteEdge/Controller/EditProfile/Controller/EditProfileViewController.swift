//
//  EditProfileViewController.swift
//  athletes
//
//  Created by Mac on 06/08/2024.
//

import UIKit
import FirebaseAuth

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var userData = UserModel()
    var newEmail = ""
    var newModel = UserModel()
    var teamArray = [TeamModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }
 
    private func setupController() {
        
    }
    
    private func updateUserData(userModel: UserModel) {
        !self.isAnimating ? PopupHelper.showAnimating(self) : ()
        FirebaseData.updateUserData(FirebaseData.getCurrentUserId(), dic: userModel, completion: { error in
            self.stopAnimating()
            if let error = error {
                PopupHelper.alertWithOk(title: "Error", message: error.localizedDescription, controler: self)
            } else {
                self.tableView.reloadData()
            }
        })
    }

    func updatePassword(userModel: UserModel) {
        guard let user = Auth.auth().currentUser else {
            print("No logged-in user found.")
            return
        }
        user.updatePassword(to: userModel.password ?? "") { error in
            if let error = error {
                self.stopAnimating()
                PopupHelper.alertWithOk(title: "Error", message: "Failed to update password: \(error.localizedDescription)", controler: self)
            } else {
                self.updateUserData(userModel: userModel)
            }
        }
    }
    
    func updateEmail(userModel: UserModel) {
        guard let user = Auth.auth().currentUser else {
            print("No logged-in user found.")
            return
        }
//        if user.isEmailVerified {
//            user.updateEmail(to: userModel.email ?? "") { error  in
//                
//                if let error = error {
//                    self.stopAnimating()
//                    PopupHelper.alertWithOk(title: "Error", message: "Failed to send verification email: \(error.localizedDescription)", controler: self)
//                } else {
//                    self.updateUserData(userModel: userModel)
//                }
//            }
//        } else {
//            user.sendEmailVerification { error in
//                self.stopAnimating()
//                if let error = error {
//                    PopupHelper.alertWithOk(title: "Error", message: "Failed to send verification email: \(error.localizedDescription)", controler: self)
//                } else {
//                    PopupHelper.alertWithOk(title: "Verification Sent", message: "A verification email has been sent to \(user.email). Please check your inbox.", controler: self)
//                }
//            }
//        }
        user.sendEmailVerification(beforeUpdatingEmail: newEmail) { error in
            self.stopAnimating()
            if let error = error {
                PopupHelper.alertWithOk(title: "Error", message: "Failed to send verification email: \(error.localizedDescription)", controler: self)
            } else {
                           PopupHelper.alertWithOk(
                               title: "Verification Sent",
                               message: "A verification email has been sent to \(self.newEmail). You will be logged out automatically after pressing OK. Please check your inbox.",
                               controler: self
                           ) {
                               self.logoutUser()
                           }
            }
        }
    }
    
    
    
    
    func changePasswordButtonTapped(updateData: UserModel, isForEmail: Bool = false) {
         let user = self.userData
        PopupHelper.showAnimating(self)
        let currentPassword = user.password ?? ""
        let newPassword = updateData.password ?? ""

        // Re-authenticate the user before updating the password
        FirebaseData.reauthenticateUser(currentPassword: currentPassword) { success, error in
            if success {
                // If re-authentication is successful, update the password
                self.newEmail = updateData.email ?? ""
                self.newModel = updateData
                isForEmail ? self.updateEmail(userModel: updateData) : self.updatePassword(userModel: updateData)
            } else {
                self.stopAnimating()
                PopupHelper.alertWithOk(title: "Error", message: "Re-authentication failed: \(error?.localizedDescription ?? "")", controler: self)
            }
        }
    }
    
    private func logoutUser() {
        PopupHelper.showAnimating(self)
        FirebaseData.logoutUserData { error in
            self.stopAnimating()
            if let error = error {
                PopupHelper.alertWithOk(title: "Error", message: error.localizedDescription , controler: self)
            } else {
                self.goToLogin()
            }
        }
    }
    
    private func goToLogin() {
        DispatchQueue.main.async {
            let vc = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .NavLoginViewController)
            UIApplication.shared.setRootViewController(vc)

        }
    }
    
    @IBAction func logout(_ sender:Any){
                PopupHelper.alertWithYesNo(title: "Logout Confirmation", message: "Are you sure you want to log out?", controller: self) {  isOkay in
                    if isOkay {
                        self.logoutUser()
                    }
                }
    }

}

extension EditProfileViewController:UITableViewDelegate,UITableViewDataSource{
    
    @objc func btngotoansers(_ sender:UIButton){
        let vc = UIStoryboard.storyBoard(withName: .Profile).loadViewControllersss(withIdentifier: "StatisticViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("profieHeader", owner: self)?.first as! profieHeader
        headerView.lblname.text = (section == 1) ? "Teams Associated".capitalized : ""
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return (section == 1 ? 35.0 : 0.0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 1 ? self.teamArray.count : 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileTeamTableViewCell", for: indexPath) as! EditProfileTeamTableViewCell
            let data = self.teamArray[indexPath.row]
            cell.ivIcons.imageURL(data.image ?? "")
            cell.lblname.text = data.name ?? ""
            cell.btnremove.addTarget(self, action: #selector(self.btngotoansers), for: .touchUpInside)
            return cell
        }
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileTopTableViewCell", for: indexPath) as! EditProfileTopTableViewCell
        cell.delegate = self
        cell.configureCell(user: self.userData)
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension EditProfileViewController: EditProfileTopTableViewCellDelegate {
    func textFieldEndEditing(textField: UITextField, indexPath: Int?) {
        guard let index = indexPath else { return }
        switch ProfileData(rawValue: index) {
        case .name:
            let useModel = UserModel()
            useModel.userName = textField.text ?? ""
            (textField.text != "" && self.userData.userName != textField.text) ? self.updateUserData(userModel: useModel): ()
        case .email:
            let useModel = UserModel()
            useModel.email = textField.text ?? ""
            (textField.text != "" && self.userData.email != textField.text) ? self.changePasswordButtonTapped(updateData: useModel, isForEmail: true): ()
        case .password:
            let useModel = UserModel()
            useModel.password = textField.text ?? ""
            (textField.text != "" && self.userData.password != textField.text) ? self.changePasswordButtonTapped(updateData: useModel): ()
        default: break
        }
    }
}

enum ProfileData: Int {
    case name = 0
    case email = 1
    case password = 2
}
