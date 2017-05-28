//
//  Country+CoreDataProperties.swift
//  LargeDataSetCoreData
//
//  Created by Michał Moskała on 26.05.2017.
//  Copyright © 2017 Michal Moskala. All rights reserved.
//

import Foundation
import CoreData


extension Country {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Country> {
        return NSFetchRequest<Country>(entityName: entityName())
    }
    
    @nonobjc public class func entityName() -> String {
        return "Country"
    }

    @NSManaged public var name: String?

}
