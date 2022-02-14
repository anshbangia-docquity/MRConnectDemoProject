//
//  FirstViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 02/02/22.
//

import UIKit
import FirebaseFirestore

class FirstViewController: UIViewController {
    
    let userDefault = UserDefaultManager.shared.defaults
    
    let database = Firestore.firestore()
    
    func saveData(text: String) {
        let docRef = database.document("docquity/example")
        docRef.setData(["text": text])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let docRef = database.document("docquity/example")
        docRef.addSnapshotListener { snapshot, error in
            guard let data = snapshot?.data(), error == nil else { return }
            
            print(data)
        }
        

        
        if let authenticate = userDefault.value(forKey: "authenticate") as? Bool {
            if authenticate {
                performSegue(withIdentifier: "goToLoginSignup", sender: self)
            } else {
                if CurrentUser().type == .MRUser {
                    xyz()
                    performSegue(withIdentifier: "logInMR", sender: self)
                } else {
                    performSegue(withIdentifier: "logInDoctor", sender: self)
                }
            }
        } else {
            performSegue(withIdentifier: "goToLoginSignup", sender: self)
        }
    }
    
    func xyz() {
        let text = "ansh"
        saveData(text: text)
    }

}

