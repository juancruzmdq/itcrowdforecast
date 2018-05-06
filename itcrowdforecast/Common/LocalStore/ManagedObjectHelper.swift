//
//  ManagedObjectHelper.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import Foundation
import CoreData

class ManagedObjectHelper<T: NSManagedObject> {
    
    /// return the first instance with a given id
    ///
    /// - Parameters:
    ///   - context: coredata context to search the instance
    ///   - uid: id of the instance
    ///   - entityName: entityname of the instance
    /// - Returns: An instance of a NSManagedObject with the given id
    static func object(in context: NSManagedObjectContext, with uid: String, entityName: String? = nil) -> T? {
        let predicate = NSPredicate(format: "uid == %@", uid)
        return self.all(in: context, withPredicate: predicate, entityName: entityName).first
    }
    
    /// Create a new instance of an object of the declared generyc type
    ///
    /// - Parameter context: coredata context to create the instance
    /// - Returns: An instance of a NSManagedObject
    static func inserted(in context: NSManagedObjectContext) -> T? {
        return NSEntityDescription.insertNewObject(forEntityName: NSStringFromClass(T.self), into: context) as? T
    }
    
    /// Return all NSManagedObject that fullfil the specified predicate
    ///
    /// - Parameters:
    ///   - context: coredata context to do the search
    ///   - predicate: predicate used for the query
    ///   - entityName: entityname of the searched instances
    /// - Returns: A list of NSManagedObject
    static func all(in context: NSManagedObjectContext, withPredicate predicate: NSPredicate? = nil, entityName: String? = nil) -> [T] {
        let entityNameForRequest = entityName ?? NSStringFromClass(T.self)
        
        let fetchRequest = NSFetchRequest<T>(entityName: entityNameForRequest)
        fetchRequest.predicate = predicate
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Unable fetch objects of type: \(entityNameForRequest) with predicate: \(String(describing: predicate)). Error: \(error)")
            return []
        }
    }

}
