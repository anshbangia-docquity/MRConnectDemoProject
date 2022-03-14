//
//  User+CoreDataProperties.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 15/02/22.
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
    @NSManaged public var profileImage: Data?
    @NSManaged public var speciality: Int16
    //@NSManaged public var type: UserType
    @NSManaged public var office: String?
    @NSManaged public var quali: String?
    @NSManaged public var exp: String?

}

extension User : Identifiable {

}
