//
//  Speciality+CoreDataProperties.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 01/02/22.
//
//

import Foundation
import CoreData


extension Speciality {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Speciality> {
        return NSFetchRequest<Speciality>(entityName: "Speciality")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?

}

extension Speciality : Identifiable {

}
