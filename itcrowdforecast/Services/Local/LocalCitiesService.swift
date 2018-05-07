//
//  LocalCitiesService.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import Foundation
import CoreData

/// Class with a set of services to manage the LocalCity instances
class LocalCitiesService {
    
    private let store: CoreDataStore
    
    /// Create an instance of LocalCitiesService that will work with the speficied CoreDataStore
    ///
    /// - Parameter store: CoreDataStore used by this service
    init(store: CoreDataStore) {
        self.store = store
    }
    
    /// Create a NSFetchedResultsController to retrieve the LocalCity instances
    ///
    /// - Returns: NSFetchedResultsController<LocalCity> instance
    func buildCitiesFetchController() -> NSFetchedResultsController<LocalCity>? {
        
        guard let context = self.store.managedObjectContext else { return nil }
        
        let citiesFetchRequest: NSFetchRequest<LocalCity> = LocalCity.fetchRequest()
        citiesFetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        let fetchResultsController = NSFetchedResultsController(fetchRequest: citiesFetchRequest,
                                                                managedObjectContext: context,
                                                                sectionNameKeyPath: nil,
                                                                cacheName: nil)
        
        return fetchResultsController
    }
    
    /// Look locally an instance of the specified city to update it, if doesn't exist create the instance
    ///
    /// - Parameter city: city to create/update
    func updateOrCreateLocalCity(with city: City) {
        
        guard let context = self.store.managedObjectContext else {
            return
        }
        var localCity: LocalCity?
        
        // Try to recover the city with id
        if let uid = city.uid {
            localCity = ManagedObjectHelper<LocalCity>.object(in: context, with: "\(uid)")
        }
        
        // If didn't found it then create it
        if localCity == nil {
            localCity = ManagedObjectHelper<LocalCity>.inserted(in: context)
        }
        
        localCity?.uid = city.uid ?? 0
        localCity?.name = city.name
        localCity?.latitude = city.latitude ?? 0
        localCity?.longitude = city.longitude ?? 0

        localCity?.temperature = city.temperature ?? 0
        localCity?.pressure = city.pressure ?? 0
        localCity?.humidity = city.humidity ?? 0
        localCity?.minTemperature = city.minTemperature ?? 0
        localCity?.maxTemperature = city.maxTemperature ?? 0

        context.perform {
            do {
                try context.save()
            } catch {
                print("Unable to save [\(context.debugDescription)] context. Error: \(error)")
            }
        }

    }

    /// Delete an instance of the city
    ///
    /// - Parameter city: city to delete
    func delete(_ city: LocalCity) {
        guard let context = self.store.managedObjectContext else {
            return
        }
        
        context.delete(city)

        context.perform {
            do {
                try context.save()
            } catch {
                print("Unable to save [\(context.debugDescription)] context. Error: \(error)")
            }
        }

    }
}
