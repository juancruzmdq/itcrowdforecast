//
//  LocalCity.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 8/5/18.
//

import Foundation

/// LocalCity will be a factory of his own class
extension LocalCity: ManagedObjectModelFactory, ManagedObjectModel {
    typealias ManagedObjectModelType = LocalCity
    static var KeyAttributeName = "uid"
}
