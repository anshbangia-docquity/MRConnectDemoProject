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

//extension UserDefaults {
//    func clear() {
//        guard let domainName = Bundle.main.bundleIdentifier else {
//            return
//        }
//        removePersistentDomain(forName: domainName)
//        synchronize()
//    }
//}
