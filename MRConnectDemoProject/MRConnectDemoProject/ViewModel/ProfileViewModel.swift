//
//  ProfileViewModel.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 15/03/22.
//

import Foundation
import UIKit

struct ProfileViewModel {
    
    func getProfileImage(urlStr: String, completion: @escaping (_ imgData: Data?) -> Void) {
        let url = URL(string: urlStr)
        guard let url = url else {
            completion(nil)
            return
        }
        
        let data = try? Data(contentsOf: url)
        guard let data = data else {
            completion(nil)
            return
        }
        
        completion(data)
    }
    
    func saveProfileImage(img: UIImage, completion: @escaping (_ error: ErrorType?) -> Void) {
        let authHandler = AuthHandler.shared
        
        if let imgData = img.pngData() {
            let storage = StorageHandler()
            
//            storage.uploadImage(userId: authHandler.currentUser!.uid, imgData: imgData) { url in
//                let urlStr = url.absoluteString
//                changeInfo(userId: authHandler.currentUser!.uid, key: "userImageLink", newVal: urlStr) { error in
//                    completion(error)
//                }
//            }
        }

    }
    
    func changeInfo(userId: String, key: String, newVal: String) {
        let firestore = FirestoreHandler()
        
        firestore.updateInfo(userId: userId, key: key, newVal: newVal)
        UserDefaultManager().saveData(for: key, value: newVal)
    }
    
    func changePassword(to newPass: String, completion: @escaping (_ error: ErrorType?) -> Void) {
        let authHandler = AuthHandler.shared
        
        authHandler.changePassword(to: newPass) { error in
            if error == nil {
                changeInfo(userId: authHandler.currentUser!.uid, key: "userPassword", newVal: newPass)
            }
            completion(error)
        }
    }
    
    func changeNumber(to newNum: String, completion: @escaping (_ error: ErrorType?) -> Void) {
        let authHandler = AuthHandler.shared
        
//        changeInfo(userId: authHandler.currentUser!.uid, key: "userContact", newVal: newNum) { error in
//            completion(error)
//        }
    }
    
    func changeName(to newName: String, completion: @escaping (_ error: ErrorType?) -> Void) {
        let authHandler = AuthHandler.shared
        
//        changeInfo(userId: authHandler.currentUser!.uid, key: "userName", newVal: newName) { error in
//            completion(error)
//        }
    }
    
    func changeExp(to newExp: String, completion: @escaping (_ error: ErrorType?) -> Void) {
        let authHandler = AuthHandler.shared
        
//        changeInfo(userId: authHandler.currentUser!.uid, key: "userExp", newVal: newExp) { error in
//            completion(error)
//        }
    }
    
    func changeQuali(to newQuali: String, completion: @escaping (_ error: ErrorType?) -> Void) {
        let authHandler = AuthHandler.shared
        
//        changeInfo(userId: authHandler.currentUser!.uid, key: "userQuali", newVal: newQuali) { error in
//            completion(error)
//        }
    }
    
    func changeOffice(to newOffice: String, completion: @escaping (_ error: ErrorType?) -> Void) {
        let authHandler = AuthHandler.shared
        
//        changeInfo(userId: authHandler.currentUser!.uid, key: "userOffice", newVal: newOffice) { error in
//            completion(error)
//        }
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
