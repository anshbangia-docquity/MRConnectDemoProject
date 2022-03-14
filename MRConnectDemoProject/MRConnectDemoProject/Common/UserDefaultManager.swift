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
    
}

