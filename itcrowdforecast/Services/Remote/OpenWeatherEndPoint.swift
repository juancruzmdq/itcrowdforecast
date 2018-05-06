//
//  OpenWeatherEndPoint.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import Foundation

/// Set of OpenWeather's endpoints
///
/// - byCityName: Look the forecast for a city with the given name
enum OpenWeatherEndPoint: EndPointProtocol {
    
    case byCityName(city: String, appId: String)
    
    var path: String {
        switch self {
        case .byCityName:
            return "/weather"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case let .byCityName(city, appId):
            return ["q": city,
                    "appid": appId]
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .byCityName:
            return HTTPMethod.GET
        }
    }

}
