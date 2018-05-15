//
//  NSManagedObjectContext+SaveRecurrent.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 15/5/18.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
    func recurrentSaveContext() {
        context.perform {
            do {
                try context.save()
            } catch {
                print("Unable to save [\(context.debugDescription)] context. Error: \(error)")
                return
            }
            
            if let parentContext = context.parent {
                self.recurrentSaveContext(parentContext)
            }
        }
    }
}
