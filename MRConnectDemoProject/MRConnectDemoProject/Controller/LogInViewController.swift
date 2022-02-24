//
//  LogInViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 24/01/22.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    //let userDefault = UserDefaultManager.shared.defaults
    var logic = Logic()
    let auth = FirebaseAuth.Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        passwordField.delegate = self
        
        emailField.placeholder = MyStrings.email
        passwordField.placeholder = MyStrings.password
        loginButton.setTitle(MyStrings.loginUpperCase, for: .normal)
        signupButton.setTitle(MyStrings.newUserSignUp, for: .normal)
        
        let gradientLayer = setGradientBackground()
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }

    @IBAction func logInTapped(_ sender: Any) {
        if emailField.text!.isEmpty {
            emailField.backgroundColor = UIColor.red.withAlphaComponent(0.3)
            Alert.showAlert(on: self, emptyField: MyStrings.email)
            return
        }
        if passwordField.text!.isEmpty {
            passwordField.backgroundColor = UIColor.red.withAlphaComponent(0.3)
            Alert.showAlert(on: self, emptyField: MyStrings.password)
            return
        }
        
        auth.signIn(withEmail: emailField.text!, password: passwordField.text!) { result, error in
            guard error == nil else {
                Alert.showAlert(on: self, title: MyStrings.invalidEmailOrPass, subtitle: MyStrings.checkCredentials)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

//MARK: - UITextFieldDelegate
extension LogInViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = .clear
    }
    
}


