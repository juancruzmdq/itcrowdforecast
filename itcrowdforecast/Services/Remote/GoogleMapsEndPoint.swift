//
//  GoogleMapsEndPoint.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import Foundation

/// Set of GoogleMaps endpoints
///
/// - Autocomplete: given an input text, return a list of cities name predictions
enum GoogleMapsEndPoint {
    /// Namespace for "/autocomplete/json"
    enum Autocomplete {
        private static let path = "/autocomplete/json"
        
        static func get(for input: String, key: String) -> Endpoint<Predictions> {
            return Endpoint(method: .get,
                            path: GoogleMapsEndPoint.Autocomplete.path,
                            parameters: ["input": input] )
        }
    }
    
}
