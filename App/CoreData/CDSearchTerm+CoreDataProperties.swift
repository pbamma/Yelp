//
//  CDSearchTerm+CoreDataProperties.swift
//  
//
//  Created by Philip Starner on 1/11/18.
//
//

import Foundation
import CoreData


extension CDSearchTerm {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDSearchTerm> {
        return NSFetchRequest<CDSearchTerm>(entityName: "CDSearchTerm")
    }

    @NSManaged public var id: String?
    @NSManaged public var lat: Double
    @NSManaged public var long: Double
    @NSManaged public var business: Set<CDBusiness>?

}

// MARK: Generated accessors for business
extension CDSearchTerm {

    @objc(addBusinessObject:)
    @NSManaged public func addToBusiness(_ value: CDBusiness)

    @objc(removeBusinessObject:)
    @NSManaged public func removeFromBusiness(_ value: CDBusiness)

    @objc(addBusiness:)
    @NSManaged public func addToBusiness(_ values: Set<CDBusiness>)

    @objc(removeBusiness:)
    @NSManaged public func removeFromBusiness(_ values: Set<CDBusiness>)

}
