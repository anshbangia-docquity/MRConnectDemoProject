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
    static let userDefault = UserDefaultManager.shared.defaults
    static var user: User? = nil
    static let medForm: [Int16:String] = [0:MyStrings.capsule, 1:MyStrings.tablet, 2:MyStrings.syrup, 3:MyStrings.injection]
    static let specialities: [Int16:String] = [
        0:MyStrings.cardiologist,
        1:MyStrings.dermatologist,
        2:MyStrings.gynecologist,
        3:MyStrings.neurologist,
        4:MyStrings.oncologist,
        5:MyStrings.pediatrician,
        6:MyStrings.physician,
        7:MyStrings.psychiatrist,
        8:MyStrings.radiologist,
        9:MyStrings.surgeon
    ]
    static var seletedSpec: Int16 = -1
    
    static func logIn(email: String, password: String) -> Bool {
        let resultUser = CoreDataHandler().fetchUser(email: email)
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
    
    static func signUp(name: String, contact: String, email: String, password: String, type: UserType, license: String = "", mrnumber: String = "", speciality: Int16 = -1) -> Bool {
        
        let resultUser = CoreDataHandler().fetchUser(email: email)
        
        let result = signUpUser(resultUser, name: name, contact: contact, email: email, password: password, type: type, license: license, mrnumber: mrnumber, speciality: speciality)
        return result
    }
    
    static func signUpUser(_ resultUser: [User], name: String, contact: String, email: String, password: String, type: UserType, license: String, mrnumber: String, speciality: Int16) -> Bool {
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
    
    static func createMedicine(name: String, company: String, composition: String, price: Float, form: Int16) -> Bool {
        let newMed = Medicine(context: context)
        newMed.name = name
        newMed.company = company
        newMed.composition = composition
        newMed.price = price
        newMed.form = form
        
        var num = userDefault.value(forKey: "numOfMed") as! Int16
        newMed.id = num
        newMed.creator = user?.email
        
        do {
            try context.save()
        } catch {
            return false
        }
        
        num += 1
        userDefault.setValue(num, forKey: "numOfMed")
        
        return true
    }
}


