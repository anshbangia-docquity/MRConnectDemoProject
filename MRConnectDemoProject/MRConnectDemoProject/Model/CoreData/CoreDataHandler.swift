//
//  CoreDataHandler.swift
//  MRConnectDemoProject
//
//  Created by Apple on 02/02/22.
//

import Foundation
import CoreData
import UIKit

struct CoreDataHandler {
    
    let context = PersistentStorage.shared.context
    
}

//MARK: - User
extension CoreDataHandler {
    
    func fetchUser(email: String) -> [User] {
        var result: [User] = []
        do {
            let request = User.fetchRequest() as NSFetchRequest<User>
            let pred = NSPredicate(format: "email == %@", email)
            request.predicate = pred
            
            result = try PersistentStorage.shared.context.fetch(request)
        } catch {}

        return result
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
        } catch {}
        
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
    
    func fetchProfileImage(_ email: String) -> Data? {
        let user = fetchUser(email: email)[0]
        
        return user.profileImage
    }
    
    //MARK: - Create User
    func signUpUser(name: String, contact: String, email: String, password: String, type: UserType, license: String, mrnumber: String, speciality: Int16) -> Bool {
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
            newUser.office = ""
            newUser.quali = ""
            newUser.exp = ""
        }

        do {
            try context.save()
        } catch {
            return false
        }

        return true
    }
    
    //MARK: - Update User
    func updateName(_ user: User, newName: String) -> Bool {
        user.name = newName
        
        do {
            try context.save()
        } catch {
            return false
        }
        
        return true
    }
    
    func updateNumber(_ user: User, newNum: String) -> Bool {
        user.contact = newNum
        
        do {
            try context.save()
        } catch {
            return false
        }
        
        return true
    }

    
    func updatePassword(_ user: User, newPass: String) -> Bool {
        user.password = newPass
        
        do {
            try context.save()
        } catch {
            return false
        }
        
        return true
    }
    
    func updateOffice(_ user: User, office: String) -> Bool {
        user.office = office
        
        do {
            try context.save()
        } catch {
            return false
        }
        
        return true
    }
    
    func updateQuali(_ user: User, quali: String) -> Bool {
        user.quali = quali
        
        do {
            try context.save()
        } catch {
            return false
        }
        
        return true
    }
    
    func updateExp(_ user: User, exp: String) -> Bool {
        user.exp = exp
        
        do {
            try context.save()
        } catch {
            return false
        }
        
        return true
    }
    
    func saveProfileImage(_ user: User, image: UIImage) -> Bool {
        user.profileImage = image.jpegData(compressionQuality: 1) as Data?
        do {
            try context.save()
        } catch {
            return false
        }
        return true
    }
    
}

//MARK: - Medicines
extension CoreDataHandler {
    
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
    
    func fetchMedicine(id: Int16) -> Medicine {
        var result: [Medicine] = []
        do {
            let request = Medicine.fetchRequest() as NSFetchRequest<Medicine>
            let pred = NSPredicate(format: "id == %d", id)
            request.predicate = pred
            
            result = try PersistentStorage.shared.context.fetch(request)
        } catch {}

        return result[0]
    }
    
    //MARK: - Create Medicine
    func createMedicine(name: String, company: String, composition: String, price: Float, form: Int16) -> Bool {
        let newMed = Medicine(context: context)
        newMed.name = name
        newMed.company = company
        newMed.composition = composition
        newMed.price = price
        newMed.form = form
        
        let num = Int16(fetchMedicines().count)
        newMed.id = num
        
        let email = CurrentUser().email
        newMed.creator = email
        
        do {
            try context.save()
        } catch {
            return false
        }
        
        return true
    }
    
}

//MARK: - Meetings
extension CoreDataHandler {
    
    func fetchMeetings() -> [Meeting] {
        var result: [Meeting] = []
        do {
            let request = Meeting.fetchRequest() as NSFetchRequest<Meeting>
            let sort = NSSortDescriptor(key: "startDate", ascending: true)
            request.sortDescriptors = [sort]
            
            result = try PersistentStorage.shared.context.fetch(request)
        } catch {}
        
        return result
    }
    
    func fetchMeetings(of creator: String) -> [Meeting] {
        var result: [Meeting] = []
        do {
            let request = Meeting.fetchRequest() as NSFetchRequest<Meeting>
            let pred = NSPredicate(format: "creator == %@", creator)
            request.predicate = pred
            let sort = NSSortDescriptor(key: "startDate", ascending: true)
            request.sortDescriptors = [sort]
            
            result = try PersistentStorage.shared.context.fetch(request)
        } catch {}
        
        return result
    }
    
    //MARK: - Create Meeting
    func createMeeting(title: String, desc: String?, startDate: Date, endDate: Date, doctors: Set<String>, medicines: Set<Int16>) -> Bool {
        let newMeet = Meeting(context: context)
        newMeet.title = title
        newMeet.desc = desc
        newMeet.startDate = startDate
        newMeet.endDate = endDate
        newMeet.doctors = doctors
        newMeet.medicines = medicines
        
        let num = Int16(fetchMeetings().count)
        newMeet.id = num
        
        let email = CurrentUser().email
        newMeet.creator = email
        
        do {
            try context.save()
        } catch {
            return false
        }
        
        return true
    }
    
    //MARK: - Update Meeting
    func editMeeting(meeting: Meeting, title: String, desc: String?, startDate: Date, endDate: Date, doctors: Set<String>, medicines: Set<Int16>) -> Bool {
        meeting.title = title
        meeting.desc = desc
        meeting.startDate = startDate
        meeting.endDate = endDate
        meeting.doctors = doctors
        meeting.medicines = medicines

        do {
            try context.save()
        } catch {
            return false
        }
        
        return true
    }
    
}

//MARK: - Recording
extension CoreDataHandler {
    
    func saveRecording(fileName: String, meeting: Int16) -> Bool {
        let rec = Recording(context: context)
        
        rec.fileName = fileName
        rec.meeting = meeting
        
        do {
            try context.save()
        } catch {
            return false
        }
        
        return true
    }
    
}



