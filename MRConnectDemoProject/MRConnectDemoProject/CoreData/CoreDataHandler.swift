//
//  CoreDataHandler.swift
//  MRConnectDemoProject
//
//  Created by Apple on 02/02/22.
//

import Foundation
import CoreData

struct CoreDataHandler {
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
    
    func fetchUser(of type: UserType) -> [User] {
        var result: [User] = []
        do {
            let request = User.fetchRequest() as NSFetchRequest<User>
            let pred = NSPredicate(format: "type == %d", type.rawValue)
            request.predicate = pred
            
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
            sort = NSSortDescriptor(key: "name", ascending: true)
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
            var sort = NSSortDescriptor(key: "company", ascending: true)
            request.sortDescriptors = [sort]
            sort = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors?.append(sort)
            
            result = try PersistentStorage.shared.context.fetch(request)
        } catch {}
        
        return result
    }
}
