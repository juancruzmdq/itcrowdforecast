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
        
        guard let context = self.store.managedObjectContext else { return nil }
        
        return LocalCity.fetchResultsController(in: context, sortBy: [ NSSortDescriptor(key: "name", ascending: true) ])
    }
    
    func updateOrCreateLocalCity(with city: City, completion: ((LocalCity?) -> Void)?) {

        guard let context = self.store.managedObjectContext else {
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            
            let childContext = context.childContext()
            
            // TODO: Extract this to Mappers?
            let localCity = LocalCity.getOrCreateObject(in: childContext, with: "\(city.uid)")
            
            localCity?.uid = city.uid
            localCity?.name = city.name
            localCity?.latitude = city.latitude ?? 0
            localCity?.longitude = city.longitude ?? 0
            
            localCity?.temperature = city.temperature ?? 0
            localCity?.pressure = city.pressure ?? 0
            localCity?.humidity = city.humidity ?? 0
            localCity?.minTemperature = city.minTemperature ?? 0
            localCity?.maxTemperature = city.maxTemperature ?? 0
            
            childContext.recurrentSaveContext()
        }

    }

    func delete(_ city: LocalCity) {
        city.managedObjectContext?.delete(city)
        city.managedObjectContext?.recurrentSaveContext()
    }

}
