//
//  LocalCitiesService.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import Foundation
import CoreData

class LocalCitiesService {
    
    let store: CoreDataStore
    
    init(store: CoreDataStore) {
        self.store = store
    }
    
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
    
    func updateOrCreateLocalCity(with city: City) {
        
        guard let context = self.store.managedObjectContext else {
            return
        }
        var localCity: LocalCity?
            
        if let uid = city.uid {
            localCity = ManagedObjectHelper<LocalCity>.first(in: context, with: "\(uid)")
        }
        
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
