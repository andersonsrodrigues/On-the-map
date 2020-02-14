//
//  LoginViewController.swift
//  On the map
//
//  Created by Anderson Rodrigues on 12/02/2020.
//  Copyright © 2020 Anderson Rodrigues. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var loginButton: CustomButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }

    @IBAction func loginTapped(_ sender: Any) {
        guard let username = emailTextField.text, !username.isEmpty else {
            self.showAlertFailure(title: "Failed to login", message: "Email is required")
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            self.showAlertFailure(title: "Failed to login", message: "Password is required")
            return
        }
        
        setLogginIn(true)
        OTMClient.login(username: username, password: password, completion: handleLoginResponse(success:error:))
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        UIApplication.shared.open(OTMClient.Endpoints.signUp.url, options: [:], completionHandler: nil)
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        if success {
            OTMClient.getStudentProfile(completion: handleStudentProfileResponse(success:error:))
        } else {
            self.showAlertFailure(title: "Failed to login", message: error?.localizedDescription ?? "")
            setLogginIn(false)
        }
    }
    
    func handleStudentProfileResponse(success: Bool, error: Error?) {
        setLogginIn(false)
        if success {
            self.performSegue(withIdentifier: "tabController", sender: nil)
        } else {
            self.showAlertFailure(title: "Failed to login", message: error?.localizedDescription ?? "")
        }
    }
    
    func setLogginIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
        signUpButton.isEnabled = !loggingIn
    }
}
