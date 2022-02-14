//
//  Meeting+CoreDataProperties.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 13/02/22.
//
//

import Foundation
import CoreData


extension Meeting {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Meeting> {
        return NSFetchRequest<Meeting>(entityName: "Meeting")
    }

    @NSManaged public var creator: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var desc: String?
    @NSManaged public var doctors: Set<String>?
    @NSManaged public var id: Int16
    @NSManaged public var medicines: Set<Int16>?
    @NSManaged public var title: String?
    @NSManaged public var endDate: Date?

}

extension Meeting : Identifiable {

}
