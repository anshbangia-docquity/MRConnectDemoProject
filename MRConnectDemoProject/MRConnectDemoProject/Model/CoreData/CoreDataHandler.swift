//
//  CoreDataHandler.swift
//  MRConnectDemoProject
//
//  Created by Apple on 02/02/22.
//

import Foundation
import CoreData

struct CoreDataHandler {
    
    let context = PersistentStorage.shared.context
    let userDefault = UserDefaultManager.shared.defaults
    
    func fetchUser(email: String) -> [User] {
        var result: [User] = []
        do {
            let request = User.fetchRequest() as NSFetchRequest<User>
            let pred = NSPredicate(format: "email == %@", email)
            request.predicate = pred
            
            result = try PersistentStorage.shared.context.fetch(request)
        } catch {
        }

        return result
    }
    
    func signUpUser(_ resultUser: [User], name: String, contact: String, email: String, password: String, type: UserType, license: String, mrnumber: String, speciality: Int16) -> Bool {
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

        return true
    }
    
    func fetchUser(of type: UserType) -> [User] {
        var result: [User] = []
        do {
            let request = User.fetchRequest() as NSFetchRequest<User>
            let pred = NSPredicate(format: "type == %d", type.rawValue)
            request.predicate = pred
            let sort = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
            request.sortDescriptors = [sort]
            
            result = try PersistentStorage.shared.context.fetch(request)
        } catch {
        }
        
        return result
    }
    
    func fetchUser(of type: UserType, contains name: String) -> [User] {
        var result: [User] = []
        do {
            let request = User.fetchRequest() as NSFetchRequest<User>
            let pred = NSPredicate(format: "type == %d && name CONTAINS[c] %@", type.rawValue, name)
            request.predicate = pred
            let sort = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
            request.sortDescriptors = [sort]
            
            result = try PersistentStorage.shared.context.fetch(request)
        } catch {
        }
        
        return result
    }
    
    func fetchMedicines() -> [Medicine] {
        var result: [Medicine] = []
        do {
            let request = Medicine.fetchRequest() as NSFetchRequest<Medicine>
            var sort = NSSortDescriptor(key: "company", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
            request.sortDescriptors = [sort]
            sort = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
            request.sortDescriptors?.append(sort)
            
            result = try PersistentStorage.shared.context.fetch(request)
        } catch {}
        
        return result
    }
    
    func fetchMedicines(contains name: String) -> [Medicine] {
        var result: [Medicine] = []
        do {
            let request = Medicine.fetchRequest() as NSFetchRequest<Medicine>
            let pred = NSPredicate(format: "name CONTAINS[c] %@ || company CONTAINS[c] %@", name, name)
            request.predicate = pred
            var sort = NSSortDescriptor(key: "company", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
            request.sortDescriptors = [sort]
            sort = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
            request.sortDescriptors?.append(sort)
            
            result = try PersistentStorage.shared.context.fetch(request)
        } catch {}
        
        return result
    }
    
    func createMedicine(name: String, company: String, composition: String, price: Float, form: Int16) -> Bool {
        let newMed = Medicine(context: context)
        newMed.name = name
        newMed.company = company
        newMed.composition = composition
        newMed.price = price
        newMed.form = form
        
        let num = Int16(fetchMedicines().count)
        newMed.id = num
        
        let email = userDefault.value(forKey: "userEmail") as? String
        newMed.creator = email!
        
        do {
            try context.save()
        } catch {
            return false
        }
        
        return true
    }
    
}