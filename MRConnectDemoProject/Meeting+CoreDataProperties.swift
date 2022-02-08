//
//  Meeting+CoreDataProperties.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 08/02/22.
//
//

import Foundation
import CoreData


extension Meeting {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Meeting> {
        return NSFetchRequest<Meeting>(entityName: "Meeting")
    }

    @NSManaged public var id: Int16
    @NSManaged public var creator: String?
    @NSManaged public var title: String?
    @NSManaged public var desc: String?
    @NSManaged public var date: Date?
    @NSManaged public var doctors: Set<String>?
    @NSManaged public var medicines: Set<Int16>?

}

extension Meeting : Identifiable {

}
