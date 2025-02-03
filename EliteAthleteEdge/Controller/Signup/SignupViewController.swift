//
//  SignupViewController.swift
//  athletes
//
//  Created by ali john on 05/08/2024.
//

import UIKit
import  IQKeyboardManagerSwift
class SignupViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITexfield_Additions!
    @IBOutlet weak var emailTextField: UITexfield_Additions!
    @IBOutlet weak var dataOfBirthTextField: UITexfield_Additions!
    @IBOutlet weak var nameTextField: UITexfield_Additions!
    
    private var selectedDate = Int64()
    private var userData: UserModel?
    var inviteArray:[InvitationModel]!
    var teamArray:[TeamModel]!
    var teamData: TeamModel?
    var email:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        self.emailTextField.text = email
        
    }
    
    private func setupController() {
        setupDatePicker()
    }
    
    private func setupDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(didChange(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.frame.size = CGSize(width: 0.0, height: 250.0)
        dataOfBirthTextField.inputView = datePicker
        dataOfBirthTextField.placeholder = "\(Date().formatAsMonthddyyyy())"
    }
    
    private func validateFields() -> Bool {
        if dataOfBirthTextField.text?.isEmpty ?? true {
            showAlert(title: "Error", message: "Please enter the date of birth.")
            return false
        }
        
        if emailTextField.text?.isEmpty ?? true {
            showAlert(title: "Error", message: "Please enter your email.")
            return false
        }
        
        if nameTextField.text?.isEmpty ?? true {
            showAlert(title: "Error", message: "Please enter your name.")
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
    
    private func updateUserData() {
        let password = passwordTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let name = nameTextField.text ?? ""
        userData = UserModel()
        userData?.email = email
        userData?.userRole = UserRole.user.rawValue
        userData?.password = password
        userData?.dob = self.selectedDate
        userData?.userName = name
        userData?.isVerified = false
        createUser()
    }
    
    private func createUser() {
        guard let userData = userData else { return }
        
        
        FirebaseData.createUserData(email: userData.email, password: userData.password) { result, error in
            if let error = error{
                self.stopAnimating()
                PopupHelper.alertWithOk(title: "Error", message: error.localizedDescription, controler: self)
                return
            }
            self.userData?.userId = result?.user.uid
            guard let userData = self.userData else { return }
            self.saveUserData(userData: userData)
            
        }
    }
    
    private func saveUserData(userData: UserModel) {
        FirebaseData.saveUserData(uid: userData.userId, userData: userData) { error in
            
            if let error = error {
                self.stopAnimating()
                PopupHelper.alertWithOk(title: "Error", message: error.localizedDescription, controler: self)
            } else {
                self.checkteaminvite()
            }
        }
    }
    func checkteaminvite(){
        
        FirebaseData.getAllInvitations(email: userData?.email ?? "0") { error, courses in
            
            if let error = error{
                self.fetchTeamData()
                return
            }
            if courses?.count == 0{
                self.fetchTeamData()
                return
            }
            self.stopAnimating()
            let vc = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .JoinTeamViewController)
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    func getallteams(){
        PopupHelper.showAnimating(self)
        let dispatch = DispatchGroup()
        if let invite = self.inviteArray{
            FirebaseData.getAllTeamData(teams: invite.map({$0.teamId})) { error, teamsData in
                self.teamArray = teamsData
                for team in self.teamArray{
                    dispatch.enter()
                    var memarry = [String]()
                    if let members = team.members{
                        memarry = members
                    }
                    memarry.append(FirebaseData.getCurrentUserId())
                    
                    let temdaa = TeamModel()
                    temdaa.members = memarry
                    FirebaseData.updateTeamData(team.docId, dic: temdaa) { error in
                        dispatch.leave()
                    }
                }
                dispatch.notify(queue: .main) {
                    self.stopAnimating()
                    let vc = UIStoryboard.storyBoard(withName: .Home).loadViewController(withIdentifier: .LGSideMenuController)
                    UIApplication.shared.setRootViewController(vc)
                }
            }
        }
    }
    func fetchTeamData(){
        
        FirebaseData.getTeamByNameData(name: Constant.Athletes_Edge) { error, teamsData in
            
            if let error = error{
                self.stopAnimating()
                PopupHelper.alertWithOk(title: "Error", message: error.localizedDescription, controler: self)
                return
            }
            self.teamData = teamsData
            self.joinnow()
            //self.teamLabel.text = "The \(teamsData?.name ?? "") team has asked you to join this app."
        }
    }
    func joinnow(){
        guard let data = self.teamData else {
            //let vc = UIStoryboard.storyBoard(withName: .Home).loadViewController(withIdentifier: .LGSideMenuController)
            //UIApplication.shared.setRootViewController(vc)
            return  }
        let team = TeamModel()
        var mem = [String]()
        if let member = data.members{
            mem = member
        }
        mem.append(FirebaseData.getCurrentUserId())
        team.members = mem
        
        FirebaseData.updateTeamData(data.docId, dic: team) { error in
            self.stopAnimating()
            PopupHelper.showAlertControllerWithSuccessLogout(forErrorMessage: "Please confirm your email '\(self.emailTextField.text!)' to active your account", forViewController: self)
            //let vc = UIStoryboard.storyBoard(withName: .Home).loadViewController(withIdentifier: .LGSideMenuController)
            //UIApplication.shared.setRootViewController(vc)
        }
    }
    @objc func didChange(datePicker: UIDatePicker) {
        let date = datePicker.date
        self.selectedDate = date.milisecondInt64
        dataOfBirthTextField.text = "\(date.formatAsMonthddyyyy())"
    }
    
    @IBAction func didTapContinueButton(_ sender: Any) {
        if validateFields() {
            PopupHelper.showAnimating(self)
            FirebaseData.loginAnonymusUserData { result, error in
                if let error = error{
                    self.stopAnimating()
                    PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                    return
                }
                FirebaseData.getAllInvitations(email: self.emailTextField.text!) { error, courses in
                    
                    FirebaseData.deleteAnonymusUserData { error in
                        
                    }
                    if let course = courses,course.count > 0{
                        if course.contains(where: {$0.type == UserRole.coach.rawValue}) {
                            self.stopAnimating()
                            PopupHelper.showAlertControllerWithError(forErrorMessage: "You will not sign up on this email as user", forViewController: self)
                            return
                        }
                    }
                    self.updateUserData()
                }
            }
            
        }
//        DispatchQueue.main.async {
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "JoinTeamViewController") as! JoinTeamViewController
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
    @IBAction func didTapSignInHereButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension SignupViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        switch textField{
        case self.nameTextField:
            self.emailTextField.becomeFirstResponder()
        case self.emailTextField:
            self.passwordTextField.becomeFirstResponder()
        case self.passwordTextField:
            textField.resignFirstResponder()
        case self.dataOfBirthTextField:
            textField.resignFirstResponder()
        default:
            break
        }
        return true
    }
}
