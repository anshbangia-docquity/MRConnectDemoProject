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
    
    func changeInfo(userId: String, key: String, newVal: String, completion: @escaping (_ error: ErrorType?) -> Void) {
        let firestore = FirestoreHandler()
        
        firestore.updateInfo(userId: userId, key: key, newVal: newVal) { error in
            if error != nil {
                completion(.defaultError)
            } else {
                UserDefaultManager().saveData(for: key, value: newVal)
                completion(nil)
            }
        }

    }
    
    func changePassword(to newPass: String, completion: @escaping (_ error: ErrorType?) -> Void) {
        let authHandler = AuthHandler.shared
        
        authHandler.changePassword(to: newPass) { error in
            if error == nil {
                changeInfo(userId: authHandler.currentUser!.uid, key: "userPassword", newVal: newPass) { error in
                    completion(error)
                }
            } else {
                completion(error)
            }
        }
    }
    
    func changeNumber(to newNum: String, completion: @escaping (_ error: ErrorType?) -> Void) {
        let authHandler = AuthHandler.shared
        
        changeInfo(userId: authHandler.currentUser!.uid, key: "userContact", newVal: newNum) { error in
            completion(error)
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
