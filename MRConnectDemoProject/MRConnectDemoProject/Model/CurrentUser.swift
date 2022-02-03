//
//  CurrentUser.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 02/02/22.
//

import Foundation
import UIKit

class CurrentUser {
    
    let userDefault = UserDefaultManager.shared.defaults
    let coreDataHandler = CoreDataHandler()
    
    var contact: String {
        return userDefault.value(forKey: "userContact") as! String
    }
    var email: String {
        return userDefault.value(forKey: "userEmail") as! String
    }
    var license: String {
        return userDefault.value(forKey: "userLicense") as! String
    }
    var mrnumber: String {
        return userDefault.value(forKey: "userMRNumber") as! String
    }
    var name: String {
        return userDefault.value(forKey: "userName") as! String
    }
    var password: String {
        return userDefault.value(forKey: "userPassword") as! String
    }
    var speciality: Int16 {
        return userDefault.value(forKey: "userSpeciality") as! Int16
    }
    var type: UserType {
        let num = userDefault.value(forKey: "userType") as! Int16
        return UserType(rawValue: num)!
    }
    var profileImage: UIImage? {
        let img = coreDataHandler.fetchProfileImage(self.email)
        if img == nil {
            return nil
        }
        
        return UIImage(data: img!)
    }
    
}
