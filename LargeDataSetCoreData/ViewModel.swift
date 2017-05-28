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
    private var citiesFRC: NSFetchedResultsController<City>?
    private var countriesFRC: NSFetchedResultsController<Country>?
    
    init() {
        fillDatabaseIfNeeded()
        setupFRCs()
    }
    
    // MARK: Filling with data
    
    private func fillDatabaseIfNeeded() {
        if savedCitiesCount() == 0 {
            fillDatabase(withEntityName: City.entityName())
        }
        
        if savedCountriesCount() == 0 {
            fillDatabase(withEntityName: Country.entityName())
        }
    }
    
    private func fillDatabase(withEntityName entityName: String) {
        let context = coreDataStack.persistentContainer.viewContext
        let entitiesCount = 5000
        
        for i in 0..<entitiesCount {
            let entity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
            let value = "\(entityName) \(i)"
            entity.setValue(value, forKey: "name")
        }
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    private func savedCitiesCount() -> Int {
        let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
        return numberOfEntities(withFetchRequest: fetchRequest)
    }
    
    private func savedCountriesCount() -> Int {
        let fetchRequest: NSFetchRequest<Country> = Country.fetchRequest()
        return numberOfEntities(withFetchRequest: fetchRequest)
    }
    
    private func numberOfEntities<T>(withFetchRequest fetchRequest: NSFetchRequest<T>) -> Int {
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
    
    private func setupFRCs() {
        let citiesFetchRequest: NSFetchRequest<City> = City.fetchRequest()
        citiesFetchRequest.fetchBatchSize = 50
        let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        citiesFetchRequest.sortDescriptors = [nameSortDescriptor]
        
        citiesFRC = NSFetchedResultsController(fetchRequest: citiesFetchRequest,
                                               managedObjectContext: coreDataStack.persistentContainer.viewContext,
                                               sectionNameKeyPath: nil,
                                               cacheName: nil)
        
        let countriesFetchRequest: NSFetchRequest<Country> = Country.fetchRequest()
        countriesFetchRequest.fetchBatchSize = 50
        countriesFetchRequest.sortDescriptors = [nameSortDescriptor]
        
        countriesFRC = NSFetchedResultsController(fetchRequest: countriesFetchRequest,
                                                           managedObjectContext: coreDataStack.persistentContainer.viewContext,
                                                           sectionNameKeyPath: nil,
                                                           cacheName: nil)
        
        do {
            try citiesFRC?.performFetch()
            try countriesFRC?.performFetch()
        } catch {
            print("error")
        }
    }
    
    public func numberOfSections() -> Int {
        return 2
    }
    
    public func numberOfEntities(inSection section: Int) -> Int {
        if section == 0 {
            return citiesFRC?.fetchedObjects?.count ?? 0
        } else if section == 1 {
            return countriesFRC?.fetchedObjects?.count ?? 0
        } else {
            return 0
        }
    }
    
    public func entityName(forIndePath indexPath: IndexPath) -> String? {
        if indexPath.section == 0 {
            return citiesFRC?.object(at: indexPath).name
        } else if indexPath.section == 1 {
            let offset = IndexPath(row: indexPath.row, section: indexPath.section - 1)
            return countriesFRC?.object(at: offset).name
        } else {
            return nil
        }
    }

}
