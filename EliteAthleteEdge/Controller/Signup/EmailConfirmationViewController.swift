//
//  EmailConfirmationViewController.swift
//  EliteAthleteEdge
//
//  Created by Assistant on 2024.
//

import UIKit

class EmailConfirmationViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var backToLoginButton: UIButton!
    @IBOutlet weak var checkEmailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    var userEmail: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        // Set the email in the label
        emailLabel.text = userEmail
        
        // Configure the title and message
        titleLabel.text = "Check Your Email"
        messageLabel.text = "We've sent a confirmation link to your email address. Please check your inbox and click the link to verify your account."
        
        // Configure the back to login button
        backToLoginButton.setTitle("Back to Login", for: .normal)
        backToLoginButton.backgroundColor = UIColor(named: "blueColor")
        backToLoginButton.setTitleColor(.white, for: .normal)
        backToLoginButton.layer.cornerRadius = 16
        backToLoginButton.titleLabel?.font = UIFont(name: "Rubik-Regular", size: 15)
        
        // Configure the check email image
        checkEmailImageView.image = UIImage(named: "Icon check double") // Using check double icon for confirmation
        checkEmailImageView.contentMode = .scaleAspectFit
        checkEmailImageView.tintColor = UIColor(named: "blueColor")
        
        // Configure labels
        titleLabel.font = UIFont(name: "Rubik-Bold", size: 24)
        titleLabel.textColor = .black
        
        messageLabel.font = UIFont(name: "Rubik-Regular", size: 16)
        messageLabel.textColor = UIColor(named: "black50")
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        emailLabel.font = UIFont(name: "Rubik-Bold", size: 18)
        emailLabel.textColor = UIColor(named: "blueColor")
        emailLabel.textAlignment = .center
    }
    
    @IBAction func backToLoginButtonTapped(_ sender: UIButton) {
        // Logout the user and navigate back to login
        FirebaseData.logout()
        
        // Pop to root view controller to go back to login
        self.navigationController?.popToRootViewController(animated: true)
    }
} 