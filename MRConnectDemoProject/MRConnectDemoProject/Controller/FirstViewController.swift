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
    
    //let logic = Logic()
    
    //var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
   //     try? auth.signOut()
        usersCollectionRef = database.collection("Users")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        handle = auth.addStateDidChangeListener { _, user in
////            guard let self = self else { return }
//            if user == nil {
//                self.performSegue(withIdentifier: "goToLoginSignup", sender: self)
//            } else {
////                print("login done")
////                return
//                guard let user = user else { return }
//                self.userDocRef = self.usersCollectionRef.document(user.uid)
//
//                var type: UserType?
//                self.userDocRef.getDocument { snapshot, error in
//                    guard error == nil, let userData = snapshot?.data() else { return }
//                    guard let userType = userData["type"] as? Int16 else { return }
//                    type = UserType(rawValue: userType)
//                }
//
//                if let type = type {
//                    if type == .MRUser {
//                        self.performSegue(withIdentifier: "logInMR", sender: self)
//                    } else {
//                        self.performSegue(withIdentifier: "logInDoctor", sender: self)
//                    }
//                }
//            }
//        }
        if auth.currentUser == nil {
            self.performSegue(withIdentifier: "goToLoginSignup", sender: self)
        } else {
            guard let user = auth.currentUser else { return }
            self.userDocRef = self.usersCollectionRef.document(user.uid)

            self.userDocRef.getDocument { snapshot, error in
                guard error == nil, let userData = snapshot?.data() else { return }
                guard let userType = userData["type"] as? Int16 else { return }
                let type = UserType(rawValue: userType)
                if let type = type {
                    if type == .MRUser {
                        self.performSegue(withIdentifier: "logInMR", sender: self)
                    } else {
                        self.performSegue(withIdentifier: "logInDoctor", sender: self)
                    }
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        guard let handle = handle else { return }
//        auth.removeStateDidChangeListener(handle)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        if auth.currentUser == nil {
//            performSegue(withIdentifier: "goToLoginSignup", sender: self)
//            return
//        } else {
//            print("Logged In Ho Bhai")
//            return
//        }
//
//        guard let user = auth.currentUser else { return }
//        userDocRef = usersCollectionRef.document(user.uid)
//
//        var type: UserType?
//        userDocRef.getDocument { snapshot, error in
//            guard error == nil, let userData = snapshot?.data() else { return }
//            guard let userType = userData["type"] as? Int16 else { return }
//            type = UserType(rawValue: userType)
//        }
//
//        if let type = type {
//            if type == .MRUser {
//                performSegue(withIdentifier: "logInMR", sender: self)
//            } else {
//                performSegue(withIdentifier: "logInDoctor", sender: self)
//            }
//        }
//    }
    
}

