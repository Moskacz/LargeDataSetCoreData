//
//  City+CoreDataProperties.swift
//  LargeDataSetCoreData
//
//  Created by Michał Moskała on 26.05.2017.
//  Copyright © 2017 Michal Moskala. All rights reserved.
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var name: String?

}
