//
//  ProfileViewModel.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 15/03/22.
//

import Foundation

struct ProfileViewModel {
    
    func getProfileImage(urlStr: String, completion: @escaping (_ imgData: Data) -> Void) {
        let url = URL(string: urlStr)
        guard let url = url else { return }
        
        let data = try? Data(contentsOf: url)
        guard let data = data else { return }
        
        completion(data)
    }
    
    func changePassword(to newPass: String, completion: @escaping (_ error: ErrorType?) -> Void) {
        let authHandler = AuthHandler.shared
        
        authHandler.changePassword(to: newPass) { error in
            if error == nil {
                let firestore = FirestoreHandler()
                
                firestore.updatePassword(userId: authHandler.currentUser!.uid, newPass: newPass) { error in
                    if error != nil {
                        completion(.defaultError)
                    } else {
                        UserDefaultManager().saveData(for: "userPassword", value: newPass)
                        completion(nil)
                    }
                }
            } else {
                completion(error)
            }
        }
    }
    
    func logOut() -> Bool {
        let authHandler = AuthHandler.shared
        
        if authHandler.logOut() {
            UserDefaultManager().reset()
            
            return true
        }
        
        return false
    }
    
}
