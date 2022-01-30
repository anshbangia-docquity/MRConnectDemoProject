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

    let userDefault = UserDefaultManager.shared.defaults
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let gradientLayer = setGradientBackground()
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at:0)
        
        if let email = userDefault.value(forKey: "email") as? String, let password = userDefault.value(forKey: "password") as? String {
            let _ = Logic.logIn(email: email, password: password)
            
            if Logic.user?.type == .MRUser {
                performSegue(withIdentifier: "logInMR", sender: self)
            } else {
                performSegue(withIdentifier: "logInDoctor", sender: self)            }
        }
    }

    @IBAction func logInTapped(_ sender: Any) {
        if emailField.text == "" {
            showAlert(emptyField: "Email")
            return
        }
        if passwordField.text == "" {
            showAlert(emptyField: "Password")
            return
        }
        
        let result = Logic.logIn(email: emailField.text!, password: passwordField.text!)
        if result == false {
            showAlert(title: "Invalid Email or Password.", subtitle: "Please check your credentials.")
            return
        }
        
        userDefault.setValue(emailField.text, forKey: "email")
        userDefault.setValue(passwordField.text, forKey: "password")
        
        if Logic.user?.type == .MRUser {
            performSegue(withIdentifier: "logInMR", sender: self)
        } else {
            performSegue(withIdentifier: "logInDoctor", sender: self)        }
    }
    
    func showAlert(title: String, subtitle: String) {
        self.present(Alert.showAlert(title: title, subtitle: subtitle), animated: true, completion: nil)
    }
    
    func showAlert(emptyField: String) {
        self.present(Alert.showAlert(title: "The \(emptyField) field cannot be empty.", subtitle: "Please fill your \(emptyField)."), animated: true, completion: nil)
    }
    
}


