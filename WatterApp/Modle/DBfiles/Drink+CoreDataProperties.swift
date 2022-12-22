//
//  Drink+CoreDataProperties.swift
//  WatterApp
//
//  Created by IsraelBerezin on 01/12/2022.
//
//

import Foundation
import CoreData


extension Drink {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Drink> {
        return NSFetchRequest<Drink>(entityName: "Drink")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var amount: Int64
    @NSManaged public var date: Day?

}

extension Drink : Identifiable {

}
