//
//  CoreDataStore.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import UIKit
import CoreData

class CoreDataStore {
    
    var persistentStoreCoordinator: NSPersistentStoreCoordinator? {
        return self.persistentContainer.persistentStoreCoordinator
    }
    
    var managedObjectModel: NSManagedObjectModel? {
        return self.persistentContainer.managedObjectModel
    }
    
    var managedObjectContext: NSManagedObjectContext? {
        return self.persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "itcrowdforecast")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
