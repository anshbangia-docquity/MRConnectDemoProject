//
//  Logic.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 24/01/22.
//

import Foundation
import CoreData

struct Logic {
    
    static let context = PersistentStorage.shared.context
    static var user: User? = nil
    static let specialities = ["Cardiologist", "Dermatologist", "Gynecologist", "Neurologist", "Oncologist", "Pediatrician", "Physician", "Psychiatrist", "Radiologist", "Surgeon", "Other..."]
    
    static func logIn(email: String, password: String) -> Bool {
        let resultUser = fetchUser(email: email)
        let result = logInUser(resultUser, password: password)
        return result
    }
    
    static func logInUser(_ resultUser: [User], password: String) -> Bool {
        if resultUser.count == 0 {
            return false
        }
        if password != resultUser[0].password {
            return false
        }
                
        user = resultUser[0]
        
        return true
    }
    
    static func signUp(name: String, contact: String, email: String, password: String, type: UserType, license: String = "", mrnumber: String = "", speciality: String = "") -> Bool {
        
        let resultUser = fetchUser(email: email)
        
        let result = signUpUser(resultUser, name: name, contact: contact, email: email, password: password, type: type, license: license, mrnumber: mrnumber, speciality: speciality)
        return result
    }
    
    static func signUpUser(_ resultUser: [User], name: String, contact: String, email: String, password: String, type: UserType, license: String, mrnumber: String, speciality: String) -> Bool {
        if resultUser.count != 0 {
            return false
        }
        
        let newUser = User(context: context)
        newUser.name = name
        newUser.contact = contact
        newUser.email = email
        newUser.password = password
        newUser.type = type
        
        if type == .MRUser {
            newUser.license = license
        } else {
            newUser.mrnumber = mrnumber
            newUser.speciality = speciality
        }

        do {
            try context.save()
        } catch {
            return false
        }
        
        user = newUser
        return true
    }
    
    static func fetchUser(email: String) -> [User] {
        var result: [User] = []
        do {
            let request = User.fetchRequest() as NSFetchRequest<User>
            let pred = NSPredicate(format: "email == %@", email)
            request.predicate = pred
            
            result = try context.fetch(request)
        } catch {
        }
        return result
    }
    
}

