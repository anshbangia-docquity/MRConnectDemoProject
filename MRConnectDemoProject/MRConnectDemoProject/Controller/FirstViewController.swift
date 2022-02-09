//
//  FirstViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 02/02/22.
//

import UIKit

class FirstViewController: UIViewController {
    
    let userDefault = UserDefaultManager.shared.defaults
    let user = CurrentUser()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let authenticate = userDefault.value(forKey: "authenticate") as? Bool {
            if authenticate {
                performSegue(withIdentifier: "goToLoginSignup", sender: self)
            } else {
                if user.type == .MRUser {
                    performSegue(withIdentifier: "logInMR", sender: self)
                } else {
                    performSegue(withIdentifier: "logInDoctor", sender: self)
                }
            }
        } else {
            performSegue(withIdentifier: "goToLoginSignup", sender: self)
        }
    }

}
