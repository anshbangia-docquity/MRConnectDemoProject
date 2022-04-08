//
//  UserDefaultManager.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 24/01/22.
//

import Foundation

struct UserDefaultManager {
    
    func saveData(for key: String, value: Any) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func readData(for key: String) -> Any? {
        return UserDefaults.standard.value(forKey: key)
    }
    
    func saveUser(_ dict: [String: Any]) {
        dict.forEach { key, value in
            saveData(for: key, value: value)
        }
    }
    
    func reset() {
        UserDefaults.standard.removeObject(forKey: "userId")
        UserDefaults.standard.removeObject(forKey: "userType")
        UserDefaults.standard.removeObject(forKey: "userImageLink")
        UserDefaults.standard.removeObject(forKey: "userPassword")
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "userContact")
        UserDefaults.standard.removeObject(forKey: "userSpeciality")
        UserDefaults.standard.removeObject(forKey: "userQuali")
        UserDefaults.standard.removeObject(forKey: "userOffice")
        UserDefaults.standard.removeObject(forKey: "userMRNumber")
        UserDefaults.standard.removeObject(forKey: "userExp")
        UserDefaults.standard.removeObject(forKey: "userLicenseNumber")
    }
    
}

