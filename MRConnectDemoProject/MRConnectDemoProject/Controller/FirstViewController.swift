//
//  FirstViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 02/02/22.
//

import UIKit

class FirstViewController: UIViewController {
    
    let authHandler = AuthHandler.shared
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if authHandler.auth.currentUser == nil {
            performSegue(withIdentifier: Segues.goToLoginSignup, sender: self)
        } else {
            let user = CurrentUser()
            if user.type == .MRUser {
                performSegue(withIdentifier: Segues.loginMR, sender: self)
            } else {
                performSegue(withIdentifier: Segues.loginDoctor, sender: self)
            }
        }
    }
    
}

