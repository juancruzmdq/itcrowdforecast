//
//  GoogleMapsEndPoint.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import Foundation

enum GoogleMapsEndPoint: EndPointProtocol {
    case autocomplete(input: String, key: String)
    
    var path: String {
        switch self {
        case .autocomplete:
            return "/maps/api/place/autocomplete/json"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case let .autocomplete(input, key):
            return ["input": input,
                    "key": key]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .autocomplete:
            return HTTPMethod.GET
        }
    }
    
}
