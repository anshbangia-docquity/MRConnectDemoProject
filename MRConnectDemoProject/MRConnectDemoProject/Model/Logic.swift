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
    
    static func signUp(name: String, contact: String, email: String, password: String, type: UserType, license: String = "", mrnumber: String = "", speciality: Int16 = -1) -> Bool {
        
        let resultUser = fetchUser(email: email)
        
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
    
    static func createMedicine(name: String, company: String, composition: String, price: Float, form: String) -> Bool {
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
    
    static func fetchUser(of type: UserType) -> [User] {
        var result: [User] = []
        do {
            let request = User.fetchRequest() as NSFetchRequest<User>
            let pred = NSPredicate(format: "type == %d", type.rawValue)
            request.predicate = pred
            
            result = try context.fetch(request)
        } catch {
        }
        
        return result
    }
    
    static func fetchSpecId(of speciality: String) -> Int16 {
        var result: [Speciality] = []
        do {
            let request = Speciality.fetchRequest() as NSFetchRequest<Speciality>
            let pred = NSPredicate(format: "name == %@", speciality)
            request.predicate = pred
            
            result = try context.fetch(request)
        } catch {}
        
        if result.count == 0 {
            var num = userDefault.value(forKey: "numOfSpec") as! Int16
            let newSpec = Speciality(context: context)
            newSpec.id = num
            newSpec.name = speciality
            do {
                try context.save()
            } catch {
            }
            
            num += Int16(1)
            userDefault.setValue(num, forKey: "numOfSpec")
            
            return newSpec.id
        } else {
            return result[0].id
        }
    }
    
    static func fillSecialities() -> [String] {
        var result: [Speciality] = []
        do {
            let request = Speciality.fetchRequest() as NSFetchRequest<Speciality>
            let sort = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sort]
            
            result = try context.fetch(request)
        } catch {}
        
        var str: [String] = []
        for i in result {
            str.append("\(i.name!)")
        }
        return str
    }
    
    static func fetchMedicines() -> [Medicine] {
        var result: [Medicine] = []
        do {
            let request = Medicine.fetchRequest() as NSFetchRequest<Medicine>
            var sort = NSSortDescriptor(key: "company", ascending: true)
            request.sortDescriptors = [sort]
            sort = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors?.append(sort)
            
            result = try context.fetch(request)
        } catch {}
        
        return result
    }
    
    static func fetchSpec(with id: Int16) -> String {
        var result: [Speciality] = []
        do {
            let request = Speciality.fetchRequest() as NSFetchRequest<Speciality>
            let pred = NSPredicate(format: "id == %d", id)
            request.predicate = pred
            
            result = try context.fetch(request)
        } catch {}
        
        return result[0].name!
    }
    
}


