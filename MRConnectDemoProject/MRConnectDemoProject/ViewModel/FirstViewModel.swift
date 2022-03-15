//
//  FirstViewModel.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 14/03/22.
//

import Foundation

struct FirstViewModel {
    
    func decideSegue(completion: @escaping (_ segueIdentifier: String) -> Void) {
        let authHandler = AuthHandler.shared
        
        if authHandler.currentUser == nil {
            completion(SegueIdentifiers.goToLoginSignup)
            
        } else {
            if let _ = UserDefaultManager().readData(for: "userId") {
                let user = CurrentUser()
                
                if user.type == .MRUser {
                    completion(SegueIdentifiers.loginMR)
                } else {
                    completion(SegueIdentifiers.loginDoctor)
                }
            } else {
                let firestore = FirestoreHandler()
                firestore.getUser(userId: authHandler.currentUser!.uid) { userDict in
                    if let userDict = userDict {
                        UserDefaultManager().saveUser(userDict)
                        
                        if userDict["userType"] as! Int == UserType.MRUser.rawValue {
                            completion(SegueIdentifiers.loginMR)
                        } else {
                            completion(SegueIdentifiers.loginDoctor)
                        }
                    } else {
                        let _ = authHandler.logOut()
                        completion(SegueIdentifiers.goToLoginSignup)
                    }
                }
            }
        }
    }
    
}
