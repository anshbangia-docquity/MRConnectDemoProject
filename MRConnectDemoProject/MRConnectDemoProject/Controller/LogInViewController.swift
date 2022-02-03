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
    
    let userDefault = UserDefaultManager.shared.defaults
    var logic = Logic()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailField.placeholder = MyStrings.email
        passwordField.placeholder = MyStrings.password
        loginButton.setTitle(MyStrings.loginUpperCase, for: .normal)
        signupButton.setTitle(MyStrings.newUserSignUp, for: .normal)
        
        let gradientLayer = setGradientBackground()
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at:0)
        
        if let email = userDefault.value(forKey: "email") as? String, let pass = userDefault.value(forKey: "password") as? String {
            let result = logic.logIn(email: email, password: pass)
            if result == false {
                showAlert(title: MyStrings.invalidEmailOrPass, subtitle: MyStrings.checkCredentials)
                return
            }
            
            userDefault.setValue(false, forKey: "authenticate")
            
            let userType = userDefault.value(forKey: "userType") as? Int16
            if UserType(rawValue: userType!) == .MRUser {
                performSegue(withIdentifier: "logInMR", sender: self)
            } else {
                performSegue(withIdentifier: "logInDoctor", sender: self)
            }
        }
    }

    @IBAction func logInTapped(_ sender: Any) {
        if emailField.text!.isEmpty {
            showAlert(emptyField: MyStrings.email)
            return
        }
        if passwordField.text!.isEmpty {
            showAlert(emptyField: MyStrings.password)
            return
        }
        
        let result = logic.logIn(email: emailField.text!, password: passwordField.text!)
        if result == false {
            showAlert(title: MyStrings.invalidEmailOrPass, subtitle: MyStrings.checkCredentials)
            return
        }
        
        userDefault.setValue(false, forKey: "authenticate")
        
        let userType = userDefault.value(forKey: "userType") as? Int16
        if UserType(rawValue: userType!) == .MRUser {
            performSegue(withIdentifier: "logInMR", sender: self)
        } else {
            performSegue(withIdentifier: "logInDoctor", sender: self)
        }
    }
    
    func showAlert(title: String, subtitle: String) {
        self.present(Alert.showAlert(title: title, subtitle: subtitle), animated: true, completion: nil)
    }
    
    func showAlert(emptyField: String) {
        self.present(Alert.showAlert(title: MyStrings.emptyFieldAlertTitle.replacingOccurrences(of: "|#X#|", with: emptyField), subtitle: MyStrings.emptyFieldAlertSubtitle.replacingOccurrences(of: "|#X#|", with: emptyField)), animated: true, completion: nil)
    }
    
}


