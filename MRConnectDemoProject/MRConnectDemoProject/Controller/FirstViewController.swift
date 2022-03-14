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
        
        if authHandler.currentUser == nil {
            performSegue(withIdentifier: SegueIdentifiers.goToLoginSignup, sender: self)
        } else {
//            let user = CurrentUser()
//            if user.type == .MRUser {
//                performSegue(withIdentifier: SegueIdentifiers.loginMR, sender: self)
//            } else {
//                performSegue(withIdentifier: SegueIdentifiers.loginDoctor, sender: self)
//            }
            print("success :)")
        }
    }
    
}

