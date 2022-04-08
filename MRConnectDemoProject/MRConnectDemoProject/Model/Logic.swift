////
////  Logic.swift
////  MRConnectDemoProject
////
////  Created by Ansh Bangia on 24/01/22.
////
//
//import Foundation
//import UIKit
//import AVFoundation
//
//struct Logic {
//    
//    let coreDataHandler = CoreDataHandler()
//    //let userDefault = UserDefaultManager.shared.defaults
//    lazy var dateFormatter = DateFormatter()
//    
//}
//
////MARK: - User
//extension Logic {
//    
//    func getUser(with email: String) -> User {
//        return coreDataHandler.fetchUser(email: email)[0]
//    }
//    
//    func getUsers(with emails: Set<String>) -> [User] {
//        var users: [User] = []
//        for email in emails.sorted() {
//            users.append(getUser(with: email))
//        }
//        return users
//    }
//    
//    func getDoctors() -> [User] {
//        return coreDataHandler.fetchUser(of: .Doctor)
//    }
//    
//    func getDoctors(contains name: String) -> [User] {
//        return coreDataHandler.fetchUser(of: .Doctor, contains: name)
//    }
//    
//    //MARK: - Authentication
//    
////    func logInUser(_ resultUser: [User], password: String) -> Bool {
////        if resultUser.count == 0 {
////            return false
////        }
////
////        let user = resultUser[0]
////
////        if password != user.password {
////            return false
////        }
////
////        userDefault.setValue(user.name, forKey: "userName")
////        userDefault.setValue(user.email, forKey: "userEmail")
////        userDefault.setValue(user.password, forKey: "userPassword")
////        userDefault.setValue(user.contact, forKey: "userContact")
////        userDefault.setValue(user.type.rawValue, forKey: "userType")
////
////        if user.type == .MRUser {
////            userDefault.setValue(user.license, forKey: "userLicense")
////        } else {
////            userDefault.setValue(user.mrnumber, forKey: "userMRNumber")
////            userDefault.setValue(user.speciality, forKey: "userSpeciality")
////            userDefault.setValue(user.office, forKey: "userOffice")
////            userDefault.setValue(user.quali, forKey: "userQuali")
////            userDefault.setValue(user.exp, forKey: "userExp")
////        }
////
////        return true
////    }
//    
//    func signUp(name: String, contact: String, email: String, password: String, type: UserType, license: String = "", mrnumber: String = "", speciality: Int16 = -1) -> Bool {
//        let resultUser = coreDataHandler.fetchUser(email: email)
//        if resultUser.count != 0 {
//            return false
//        }
//        
//        let result = coreDataHandler.signUpUser(name: name, contact: contact, email: email, password: password, type: type, license: license, mrnumber: mrnumber, speciality: speciality)
//        return result
//    }
//    
//    func logOut() {
//        userDefault.removeObject(forKey: "email")
//        userDefault.removeObject(forKey: "password")
//        userDefault.removeObject(forKey: "userType")
//        userDefault.removeObject(forKey: "userSpeciality")
//        userDefault.removeObject(forKey: "userPassword")
//        userDefault.removeObject(forKey: "userName")
//        userDefault.removeObject(forKey: "userMRNumber")
//        userDefault.removeObject(forKey: "userLicense")
//        userDefault.removeObject(forKey: "userEmail")
//        userDefault.removeObject(forKey: "userContact")
//        userDefault.removeObject(forKey: "userOffice")
//        userDefault.removeObject(forKey: "userQuali")
//        userDefault.removeObject(forKey: "userExp")
//
//        //userDefault.setValue(true, forKey: "authenticate")
//    }
//    
//    //MARK: - Update
//    func updateName(email: String, newName: String) -> Bool {
//        let user = coreDataHandler.fetchUser(email: email)[0]
//        return coreDataHandler.updateName(user, newName: newName)
//    }
//    
//    func updateNumber(email: String, newNum: String) -> Bool {
//        let user = coreDataHandler.fetchUser(email: email)[0]
//        return coreDataHandler.updateNumber(user, newNum: newNum)
//    }
//    
//    func updatePassword(email: String, newPass: String) -> Bool {
//        let user = coreDataHandler.fetchUser(email: email)[0]
//        return coreDataHandler.updatePassword(user, newPass: newPass)
//    }
//    
//    func updateOffice(email: String, office: String) -> Bool {
//        let user = coreDataHandler.fetchUser(email: email)[0]
//        return coreDataHandler.updateOffice(user, office: office)
//    }
//    
//    func updateQuali(email: String, quali: String) -> Bool {
//        let user = coreDataHandler.fetchUser(email: email)[0]
//        return coreDataHandler.updateQuali(user, quali: quali)
//    }
//    
//    func updateExp(email: String, exp: String) -> Bool {
//        let user = coreDataHandler.fetchUser(email: email)[0]
//        return coreDataHandler.updateExp(user, exp: exp)
//    }
//    
//    func saveProfileImage(email: String, img: UIImage) -> Bool {
//        let user = getUser(with: email)
//        return coreDataHandler.saveProfileImage(user, image: img)
//    }
//    
//}
//
////MARK: - Medicine
//extension Logic {
//    
//    func getMedicines() -> [Medicine] {
//        return coreDataHandler.fetchMedicines()
//    }
//    
//    func getMedicines(contains name: String) -> [Medicine] {
//        return coreDataHandler.fetchMedicines(contains: name)
//    }
//    
//    func getMedicine(with id: Int16) -> Medicine {
//        return coreDataHandler.fetchMedicine(id: id)
//    }
//    
//    func getMedicines(with ids: Set<Int16>) -> [Medicine] {
//        var medicines: [Medicine] = []
//        for id in ids {
//            medicines.append(getMedicine(with: id))
//        }
//        return medicines
//    }
//    
//    //MARK: - Create Medicine
//    func createMedicine(name: String, company: String, composition: String, price: Float, form: Int16) -> Bool {
//        return coreDataHandler.createMedicine(name: name, company: company, composition: composition, price: price, form: form)
//    }
//    
//}
//
////MARK: - Meetings
//extension Logic {
//    
//    func fetchMeetings(of mr: String) -> [Meeting] {
//        return coreDataHandler.fetchMeetings(of: mr)
//    }
//    
//    func fetchMeetings(for doctor: String) -> [Meeting] {
//        let result = coreDataHandler.fetchMeetings()
//        
//        var meetings: [Meeting] = []
//        for meeting in result {
//            if meeting.doctors!.contains(doctor) {
//                meetings.append(meeting)
//            }
//        }
//        
//        return meetings
//    }
//    
//    //MARK: - Create Meeting
//    func createMeeting(title: String, desc: String?, startDate: Date, endDate: Date, doctors: Set<String>, medicines: Set<Int16>) -> Bool {
//        return coreDataHandler.createMeeting(title: title, desc: desc, startDate: startDate, endDate: endDate, doctors: doctors, medicines: medicines)
//    }
//    
//    //MARK: - Update Meeting
//    func editMeeting(meeting: Meeting, title: String, desc: String?, startDate: Date, endDate: Date, doctors: Set<String>, medicines: Set<Int16>) -> Bool {
//        return coreDataHandler.editMeeting(meeting: meeting, title: title, desc: desc, startDate: startDate, endDate: endDate, doctors: doctors, medicines: medicines)
//    }
//    
//    //MARK: - Other
//    mutating func processMeetingDates(meetings: [Meeting]) -> ([String:[Meeting]], [String]) {
//        dateFormatter.dateFormat = "MMM d, yyyy"
//        var meetingDates: [String:[Meeting]] = [:]
//        var dates: [String] = []
//        for meeting in meetings {
//            let dateStr = dateFormatter.string(from: meeting.startDate!)
//            if meetingDates[dateStr] == nil
//            {
//                meetingDates[dateStr] = []
//                dates.append(dateStr)
//            }
//            meetingDates[dateStr]?.append(meeting)
//        }
//        
//        return (meetingDates, dates)
//    }
//    
//}
//
////MARK: - Recording
//extension Logic {
//    
//    func getRecordings(of meeting: Int16) -> [Recording] {
//        return coreDataHandler.fetchRecordings(of: meeting)
//    }
//    
//    //MARK: - Create Recording
//    func saveRecording(fileName: String, meeting: Int16) -> Bool {
//        return coreDataHandler.saveRecording(fileName: fileName, meeting: meeting)
//    }
//    
//}
//
////MARK: - Other
//extension Logic {
//    
//    mutating func combineDateTime(date: Date, time: Date) -> Date {
//        dateFormatter.dateFormat = "MM/dd/yyyy"
//        let dateStr = dateFormatter.string(from: date)
//        dateFormatter.dateFormat = "HH:mm"
//        let timeStr = dateFormatter.string(from: time)
//        
//        let dateTimeStr = dateStr + " " + timeStr
//        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
//        let date = dateFormatter.date(from: dateTimeStr)!
//        return date
//    }
//    
//    func checkRecordPermission() -> Bool {
//        var res = false
//        
//switch AVAudioSession.sharedInstance().recordPermission {
//        case AVAudioSession.RecordPermission.granted:
//            return true
//        case AVAudioSession.RecordPermission.denied:
//            return false
//        case AVAudioSession.RecordPermission.undetermined: AVAudioSession.sharedInstance().requestRecordPermission { allowed in
//            if allowed {
//                res = true
//            } else {
//                res = false
//            }
//        }
//        default:
//            break
//        }
//        return res
//    }
//    
//    func getDocumentsDirectory() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let documentsDirectory = paths[0]
//        return documentsDirectory
//    }
//    
//    func getAudioTime(time: TimeInterval) -> (Int, Int, Int) {
//        var time = time
//        let hr = Int(time / 3600)
//        time = time.truncatingRemainder(dividingBy: 3600)
//        let min = Int(time / 60)
//        time = time.truncatingRemainder(dividingBy: 60)
//        let sec = Int(time)
//        
//        return (hr, min, sec)
//        
//    }
//    
//}
//
//
