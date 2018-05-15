//
//  LocalCitiesService.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import Foundation
import CoreData

protocol LocalCitiesServiceProtocol {
    
    /// Create a NSFetchedResultsController to retrieve the LocalCity instances
    ///
    /// - Returns: NSFetchedResultsController<LocalCity> instance
    func buildCitiesFetchController() -> NSFetchedResultsController<LocalCity>?

    /// Look locally an instance of the specified city to update it, if doesn't exist create the instance
    ///
    /// - Parameter city: city to create/update
    /// - Returns: Block that get the LocalCity as parametter
    func updateOrCreateLocalCity(with city: City, completion: ((LocalCity?) -> Void)?)

    /// Look locally an instance of the specified city to update it, if doesn't exist create the instance
    ///
    /// - Parameter city: city to create/update
    /// - Returns: Block that get the LocalCity as parametter
    func updateOrCreateLocalCities(with cities: [City], completion: (([LocalCity]) -> Void)?)
    
    /// Delete an instance of the city
    ///
    /// - Parameter city: city to delete
    func delete(_ city: LocalCity)
}

/// Class with a set of services to manage the LocalCity instances
class LocalCitiesService {
    
    private let store: CoreDataStore

    /// Create an instance of LocalCitiesService that will work with the speficied CoreDataStore
    ///
    /// - Parameter store: CoreDataStore used by this service
    init(store: CoreDataStore) {
        self.store = store
    }

}

extension LocalCitiesService: LocalCitiesServiceProtocol {
    
    func buildCitiesFetchController() -> NSFetchedResultsController<LocalCity>? {
        return LocalCity.fetchResultsController(in: self.store.viewContext,
                                                sortBy: [ NSSortDescriptor(key: "name", ascending: true) ])
    }

    func updateOrCreateLocalCity(with city: City, completion: ((LocalCity?) -> Void)?) {

        let context = self.store.viewContext
        
        DispatchQueue.global(qos: .background).async {
            
            let childContext = context.childContext()
            
            let updatedCity = self.map(city: city, in: childContext)
            
            childContext.recurrentSaveContext()
            
            completion?(updatedCity)
        }

    }
    
    func updateOrCreateLocalCities(with cities: [City], completion: (([LocalCity]) -> Void)?) {
        
        let context = self.store.viewContext
        
        var resultCities = [LocalCity]()
        
        DispatchQueue.global(qos: .background).async {
            
            let childContext = context.childContext()
            
            cities.forEach { city in
                if let updatedCity = self.map(city: city, in: childContext) {
                    resultCities.append(updatedCity)
                }
            }
            
            childContext.recurrentSaveContext()
            
            completion?(resultCities)
        }
    }

    func delete(_ city: LocalCity) {
        city.managedObjectContext?.delete(city)
        city.managedObjectContext?.recurrentSaveContext()
    }

}

private extension LocalCitiesService {
    
    func map(city: City, in context: NSManagedObjectContext) -> LocalCity? {
        
        let localCity = LocalCity.getOrCreateObject(in: context, with: "\(city.uid)")
        
        localCity?.uid = city.uid
        localCity?.name = city.name
        localCity?.latitude = city.latitude ?? 0
        localCity?.longitude = city.longitude ?? 0
        
        localCity?.temperature = city.temperature ?? 0
        localCity?.pressure = city.pressure ?? 0
        localCity?.humidity = city.humidity ?? 0
        localCity?.minTemperature = city.minTemperature ?? 0
        localCity?.maxTemperature = city.maxTemperature ?? 0
        
        return localCity
    }
    
}
