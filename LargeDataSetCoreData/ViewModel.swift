//
//  ViewModel.swift
//  LargeDataSetCoreData
//
//  Created by Michał Moskała on 26.05.2017.
//  Copyright © 2017 Michal Moskala. All rights reserved.
//

import Foundation
import CoreData

class ViewModel {
    
    private let coreDataStack = CoreDataStack()
    private var frc: NSFetchedResultsController<City>?
    
    init() {
        fillDatabaseIfNeeded()
        setupFRC()
    }
    
    // MARK: Filling with data
    
    private func fillDatabaseIfNeeded() {
        guard numberOfEntities() == 0 else {
            return
        }
        
        fillDatabase()
    }
    
    private func fillDatabase() {
        let context = coreDataStack.persistentContainer.viewContext
        let entitiesCount = 50000
        
        for i in 0..<entitiesCount {
            let city = NSEntityDescription.insertNewObject(forEntityName: "City", into: context) as! City
            city.name = "City \(i)"
        }
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    private func numberOfEntities() -> Int {
        let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
        fetchRequest.resultType = NSFetchRequestResultType.countResultType
        do {
            let count = try coreDataStack.persistentContainer.viewContext.count(for: fetchRequest)
            return count
        } catch {
            print(error)
            return 0
        }
    }
    
    // MARK: accessing data
    
    private func setupFRC() {
        let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
        let cityNameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [cityNameSortDescriptor]
        
        frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                         managedObjectContext: coreDataStack.persistentContainer.viewContext,
                                         sectionNameKeyPath: nil,
                                         cacheName: nil)
        
        do {
            try frc?.performFetch()
        } catch {
            print("error")
        }
    }
    
    public func numberOfCities() -> Int {
        guard let citiesCount = frc?.fetchedObjects?.count else {
            return 0
        }
        
        return citiesCount
    }
    
    public func cityName(forIndexPath indexPath: IndexPath) -> String? {
        return frc?.object(at: indexPath).name
    }
}
