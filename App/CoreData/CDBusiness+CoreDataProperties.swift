//
//  CDBusiness+CoreDataProperties.swift
//  
//
//  Created by Philip Starner on 1/11/18.
//
//

import Foundation
import CoreData


extension CDBusiness {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDBusiness> {
        return NSFetchRequest<CDBusiness>(entityName: "CDBusiness")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var price: String?
    @NSManaged public var rating: Float
    @NSManaged public var phone: String?
    @NSManaged public var address: String?
    @NSManaged public var isOpenNow: Bool
    @NSManaged public var hoursStart: String?
    @NSManaged public var hoursEnd: String?
    @NSManaged public var imageURL: String?

}
