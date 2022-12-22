//
//  Day+CoreDataProperties.swift
//  WatterApp
//
//  Created by IsraelBerezin on 01/12/2022.
//
//

import Foundation
import CoreData


extension Day {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var total: Int64
    @NSManaged public var drink: NSSet?

}

// MARK: Generated accessors for drink
extension Day {

    @objc(addDrinkObject:)
    @NSManaged public func addToDrink(_ value: Drink)

    @objc(removeDrinkObject:)
    @NSManaged public func removeFromDrink(_ value: Drink)

    @objc(addDrink:)
    @NSManaged public func addToDrink(_ values: NSSet)

    @objc(removeDrink:)
    @NSManaged public func removeFromDrink(_ values: NSSet)

}

extension Day : Identifiable {

}
