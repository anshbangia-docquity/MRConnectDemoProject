//
//  User+CoreDataProperties.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 25/01/22.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var contact: String?
    @NSManaged public var email: String?
    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var type: UserType
    @NSManaged public var mrnumber: String?
    @NSManaged public var speciality: String?
    @NSManaged public var license: String?

}

extension User : Identifiable {

}
