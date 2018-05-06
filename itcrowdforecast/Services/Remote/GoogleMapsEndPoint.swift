//
//  GoogleMapsEndPoint.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import Foundation

/// Set of GoogleMaps endpoints
///
/// - autocomplete: given an input text, return a list of cities name predictions 
enum GoogleMapsEndPoint: EndPointProtocol {
    
    case autocomplete(input: String, key: String)
    
    var path: String {
        switch self {
        case .autocomplete:
            return "/autocomplete/json"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case let .autocomplete(input, key):
            return ["input": input,
                    "key": key]
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .autocomplete:
            return HTTPMethod.GET
        }
    }
    
}
