//
//  FirstViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 02/02/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class FirstViewController: UIViewController {
    
    let auth = FirebaseAuth.Auth.auth()
    let database = Firestore.firestore()
    var usersCollectionRef: CollectionReference!
    var userDocRef: DocumentReference!
    
    let logic = Logic()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usersCollectionRef = database.collection("Users")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if auth.currentUser == nil {
            performSegue(withIdentifier: "goToLoginSignup", sender: self)
            return
        }
        
        guard let user = auth.currentUser else { return }
        userDocRef = usersCollectionRef.document(user.uid)
        
        var type: UserType?
        userDocRef.getDocument { snapshot, error in
            guard error == nil, let userData = snapshot?.data() else { return }
            guard let userType = userData["type"] as? Int16 else { return }
            type = UserType(rawValue: userType)
        }
        
        if let type = type {
            if type == .MRUser {
                performSegue(withIdentifier: "logInMR", sender: self)
            } else {
                performSegue(withIdentifier: "logInDoctor", sender: self)
            }
        }
    }

}

