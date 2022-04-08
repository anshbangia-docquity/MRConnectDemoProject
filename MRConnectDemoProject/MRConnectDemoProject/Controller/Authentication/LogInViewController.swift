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
    let alertManager = AlertManager()
    
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
                if !result.success {
                    self?.alertManager.showAlert(on: self!, text: result.error!.getAlertMessage())
                } else {
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
}




