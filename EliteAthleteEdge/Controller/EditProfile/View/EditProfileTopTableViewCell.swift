//
//  EditProfileTopTableViewCell.swift
//  athletes
//
//  Created by Mac on 06/08/2024.
//

import UIKit

protocol EditProfileTopTableViewCellDelegate: AnyObject {
    func textFieldEndEditing(textField: UITextField, indexPath: Int?)
}

class EditProfileTopTableViewCell: UITableViewCell {

    @IBOutlet weak var passwordTextField: UITexfield_Additions!
    @IBOutlet weak var currentNameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITexfield_Additions!
    @IBOutlet weak var emailTextField: UITexfield_Additions!
    @IBOutlet weak var currentEmailLabel: UILabel!
    
    var delegate: EditProfileTopTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        passwordTextField.delegate = self
        nameTextField.delegate = self
        emailTextField.delegate = self
    }

    func configureCell(user: UserModel) {
        self.currentNameLabel.text = "Current name: \(user.userName ?? "")"
        self.currentEmailLabel.text = "Current email: \(user.email ?? "")"
        self.passwordTextField.text = user.password ?? ""
        self.passwordTextField.isSecureTextEntry = true
    }
    
}

extension EditProfileTopTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.passwordTextField {
            delegate?.textFieldEndEditing(textField: textField, indexPath: 2)
        } else if textField == self.emailTextField {
            delegate?.textFieldEndEditing(textField: textField, indexPath: 1)
        } else if textField == self.nameTextField {
            delegate?.textFieldEndEditing(textField: textField, indexPath: 0)
        }
    }
}

class EditProfileTeamTableViewCell: UITableViewCell {
    
    @IBOutlet weak var btnremove: UIButton!
    @IBOutlet weak var ivIcons: UIImageView!
    @IBOutlet weak var lblname: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
