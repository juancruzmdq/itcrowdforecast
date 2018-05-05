//
//  ManagedObjectHelper.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import Foundation
import CoreData

class ManagedObjectHelper<T: NSManagedObject> {

    static func first(in context: NSManagedObjectContext, with uid: String, entityName: String? = nil) -> T? {
        
        let predicate = NSPredicate(format: "uid == %@", uid)
        
        return self.all(in: context, withPredicate: predicate, entityName: entityName).first
    }
    
    static func inserted(in context: NSManagedObjectContext) -> T? {
        
        return NSEntityDescription.insertNewObject(forEntityName: NSStringFromClass(T.self), into: context) as? T
    }
    
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
