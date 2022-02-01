//
//  User+CoreDataProperties.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 01/02/22.
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
    @NSManaged public var license: String?
    @NSManaged public var mrnumber: String?
    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var speciality: Int16
    @NSManaged public var type: UserType

}

extension User : Identifiable {

}
