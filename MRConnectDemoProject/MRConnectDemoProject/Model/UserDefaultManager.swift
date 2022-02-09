//
//  UserDefaultManager.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 24/01/22.
//

import Foundation

class UserDefaultManager {
    
    static let shared = UserDefaultManager()
    let defaults = UserDefaults(suiteName: "com.data.saved")!
    
}

