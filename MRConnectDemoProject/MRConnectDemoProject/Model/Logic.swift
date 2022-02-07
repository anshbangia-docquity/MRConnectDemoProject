//
//  Logic.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 24/01/22.
//

import Foundation

struct Logic {
    
    let coreDataHandler = CoreDataHandler()
    let userDefault = UserDefaultManager.shared.defaults
    
    func logIn(email: String, password: String) -> Bool {
        let resultUser = coreDataHandler.fetchUser(email: email)
        let result = logInUser(resultUser, password: password)
        return result
    }
    
    func updateName(email: String, newName: String) -> Bool {
        let user = coreDataHandler.fetchUser(email: email)[0]
        return coreDataHandler.updateName(user, newName: newName)
    }
    
    func updatePassword(email: String, newPass: String) -> Bool {
        let user = coreDataHandler.fetchUser(email: email)[0]
        return coreDataHandler.updatePassword(user, newPass: newPass)
    }
    
    func logInUser(_ resultUser: [User], password: String) -> Bool {
        if resultUser.count == 0 {
            return false
        }
        
        let user = resultUser[0]
        
        if password != user.password {
            return false
        }
                
        userDefault.setValue(user.name, forKey: "userName")
        userDefault.setValue(user.email, forKey: "userEmail")
        userDefault.setValue(user.password, forKey: "userPassword")
        userDefault.setValue(user.contact, forKey: "userContact")
        userDefault.setValue(user.type.rawValue, forKey: "userType")
        
        if user.type == .MRUser {
            userDefault.setValue(user.license, forKey: "userLicense")
        } else {
            userDefault.setValue(user.mrnumber, forKey: "userMRNumber")
            userDefault.setValue(user.speciality, forKey: "userSpeciality")
        }
        
        return true
    }
    
    func signUp(name: String, contact: String, email: String, password: String, type: UserType, license: String = "", mrnumber: String = "", speciality: Int16 = -1) -> Bool {
        let resultUser = coreDataHandler.fetchUser(email: email)
        let result = coreDataHandler.signUpUser(resultUser, name: name, contact: contact, email: email, password: password, type: type, license: license, mrnumber: mrnumber, speciality: speciality)
        return result
    }
    
}


