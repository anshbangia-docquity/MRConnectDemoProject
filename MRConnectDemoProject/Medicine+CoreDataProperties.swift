//
//  Medicine+CoreDataProperties.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 13/02/22.
//
//

import Foundation
import CoreData


extension Medicine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Medicine> {
        return NSFetchRequest<Medicine>(entityName: "Medicine")
    }

    @NSManaged public var company: String?
    @NSManaged public var composition: String?
    @NSManaged public var creator: String?
    @NSManaged public var form: Int16
    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var price: Float

}

extension Medicine : Identifiable {

}
