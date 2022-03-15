//
//  CurrentUser.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 02/02/22.
//

import Foundation

struct CurrentUser {
    
    let userDefaultManager = UserDefaultManager()
    
    var type: UserType {
        let val = userDefaultManager.readData(for: "userType") as! Int
        return UserType(rawValue: val)!
    }
    
    var imageLink: String {
        let str = userDefaultManager.readData(for: "userImageLink") as? String
        return str ?? ""
    }
    
    var name: String {
        let str = userDefaultManager.readData(for: "userName") as? String
        return str ?? "NA"
    }
    
    var email: String {
        let str = userDefaultManager.readData(for: "userEmail") as? String
        return str ?? "NA"
    }
    
    var contact: String {
        let str = userDefaultManager.readData(for: "userContact") as? String
        return str ?? "NA"
    }
    
    var office: String {
        let str = userDefaultManager.readData(for: "userOffice") as? String
        return str ?? ""
    }
    
    var quali: String {
        let str = userDefaultManager.readData(for: "userQuali") as? String
        return str ?? ""
    }
    
    var exp: String {
        let str = userDefaultManager.readData(for: "userExp") as? String
        return str ?? ""
    }
    
    var password: String {
        let str = userDefaultManager.readData(for: "userPassword") as? String
        return str ?? ""
    }
    
}


