//
//  ViewController.swift
//  MRdemo
//
//  Created by Ansh Bangia on 20/01/22.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var logic = Logic()
    let userDefault = UserDefaultManager.shared.defaults
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let gradientLayer = setGradientBackground()
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at:0)
        
        if let email = userDefault.value(forKey: "email") as? String, let password = userDefault.value(forKey: "password") as? String {
            
            let result = logic.logIn(email: email, password: password)
            var vc: Any
            if logic.user.type == .MRUser {
                vc = storyboard?.instantiateViewController(identifier: "mrHomeScreen") as! MRHomeViewController
            } else if logic.user.type == .Doctor {
                let vc = storyboard?.instantiateViewController(identifier: "doctorHomeScreen") as! DoctorHomeViewController
            }
            vc.user = logic.user
            present(vc, animated: true)
        }
    }


    @IBAction func logInTapped(_ sender: Any) {
        if emailField.text == "" {
            showAlert(title: "Email field cannot be empty.", subtitle: "Please enter email address.")
            return
        }
        if passwordField.text == "" {
            showAlert(title: "Password field cannot be empty.", subtitle: "Please enter password.")
            return
        }
        
        let result = logic.logIn(email: emailField.text!, password: passwordField.text!)
        if result == false {
            showAlert(title: "Invalid Email or Password.", subtitle: "Please check your credentials.")
            return
        }
        
        userDefault.setValue(emailField.text, forKey: "email")
        userDefault.setValue(passwordField.text, forKey: "password")
        
        var vc: Any
        if logic.user.type == .MRUser {
            vc = storyboard?.instantiateViewController(identifier: "mrHomeScreen") as! MRHomeViewController
        } else if logic.user.type == .Doctor {
            let vc = storyboard?.instantiateViewController(identifier: "doctorHomeScreen") as! DoctorHomeViewController
        }
        vc.user = logic.user
        present(vc, animated: true)
    }
    
    func showAlert(title: String, subtitle: String) {
        self.present(Alert.showAlert(title: title, subtitle: subtitle), animated: true, completion: nil)
    }
    
}

