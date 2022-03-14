//
//  LogInViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 24/01/22.
//

import UIKit

class LogInViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    var allUI: [UIControl] = []
    
    let loginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allUI = [emailField, passwordField, loginButton, signupButton]
        
        emailField.placeholder = MyStrings.email
        passwordField.placeholder = MyStrings.password
        loginButton.setTitle(MyStrings.loginUpperCase, for: .normal)
        signupButton.setTitle(MyStrings.newUserSignUp, for: .normal)
        
        let gradientLayer = setGradientBackground()
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    @IBAction func logInTapped(_ sender: Any) {
        ActivityIndicator.shared.start(on: view, label: MyStrings.loggingIn)
        
        let request = LoginRequest(email: emailField.text, password: passwordField.text)
        
        loginViewModel.loginUser(loginRequest: request) { [weak self] result in
            DispatchQueue.main.async {
                ActivityIndicator.shared.stop()
            }
            
            if !result.success {
                if result.error == .emptyEmailField {
                    Alert.showAlert(on: self!, emptyField: MyStrings.email)
                } else if result.error == .emptyPasswordField {
                    Alert.showAlert(on: self!, emptyField: MyStrings.password)
                } else if result.error == .networkError {
                    DispatchQueue.main.async {
                        Alert.showAlert(on: self!, title: MyStrings.networkError, subtitle: MyStrings.tryAgain)
                    }
                } else if result.error == .userNotFound {
                    DispatchQueue.main.async {
                        Alert.showAlert(on: self!, title: MyStrings.invalidEmail, subtitle: MyStrings.tryAgain)
                    }
                } else if result.error == .invalidEmail {
                    DispatchQueue.main.async {
                        Alert.showAlert(on: self!, title: MyStrings.invalidEmail, subtitle: MyStrings.tryAgain)
                    }
                } else if result.error == .invalidPassword {
                    DispatchQueue.main.async {
                        Alert.showAlert(on: self!, title: MyStrings.invalidPassword, subtitle: MyStrings.tryAgain)
                    }
                } else {
                    DispatchQueue.main.async {
                        Alert.showAlert(on: self!, title: MyStrings.errorOccured, subtitle: MyStrings.checkCredentials)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
}




