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
    
    func changeNumber(to newNum: String, userId: String) {
        changeInfo(userId: userId, key: "userContact", newVal: newNum)
    }
    
    func changeName(to newName: String, userId: String) {
        changeInfo(userId: userId, key: "userName", newVal: newName)
    }
    
    func changeExp(to newExp: String, userId: String) {
        changeInfo(userId: userId, key: "userExp", newVal: newExp)
    }
    
    func changeQuali(to newQuali: String, userId: String) {
        changeInfo(userId: userId, key: "userQuali", newVal: newQuali)
    }
    
    func changeOffice(to newOffice: String, userId: String) {
        changeInfo(userId: userId, key: "userOffice", newVal: newOffice)
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
