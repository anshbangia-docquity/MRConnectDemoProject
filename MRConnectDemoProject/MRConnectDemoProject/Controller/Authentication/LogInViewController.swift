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
    
    var activityIndicator: UIActivityIndicatorView?
    var activityLabel: UILabel?
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    
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
        allUI.forEach { ui in
            ui.isEnabled = false
        }
        activityIndicator(MyStrings.loggingIn)
        
        let request = LoginRequest(email: emailField.text, password: passwordField.text)
        
        loginViewModel.loginUser(loginRequest: request) { [weak self] result in
            DispatchQueue.main.async {
                self?.effectView.removeFromSuperview()
                self?.allUI.forEach({ ui in
                    ui.isEnabled = true
                })
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

//MARK: - Activity Indicator
extension LogInViewController {
    
    func activityIndicator(_ title: String) {
        activityLabel?.removeFromSuperview()
        activityIndicator?.removeFromSuperview()
        
        activityLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        activityLabel!.text = title
        activityLabel!.font = .systemFont(ofSize: 17, weight: .medium)
        activityLabel!.textColor = UIColor(white: 0.1, alpha: 0.7)
        
        effectView.frame = CGRect(x: view.frame.midX - activityLabel!.frame.width/2, y: view.frame.midY - activityLabel!.frame.height/2 , width: 160, height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator?.color = .black
        activityIndicator!.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator!.startAnimating()
        
        effectView.contentView.addSubview(activityIndicator!)
        effectView.contentView.addSubview(activityLabel!)
        view.addSubview(effectView)
    }
    
}



