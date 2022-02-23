//
//  Recording+CoreDataProperties.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 18/02/22.
//
//

import Foundation
import CoreData


extension Recording {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recording> {
        return NSFetchRequest<Recording>(entityName: "Recording")
    }

    @NSManaged public var fileName: String?
    @NSManaged public var meeting: Int16

}

extension Recording : Identifiable {

}
