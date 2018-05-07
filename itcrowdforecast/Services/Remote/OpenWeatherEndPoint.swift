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
/// - byCityId: Look the forecast for a city with the given id
enum OpenWeatherEndPoint: EndPointProtocol {
    
    case byCityName(city: String, appId: String)
    case byCityId(uid: String, appId: String)

    var path: String {
        switch self {
        case .byCityName, .byCityId:
            return "/weather"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case let .byCityName(city, appId):
            return ["q": city,
                    "appid": appId]
        case let .byCityId(uid, appId):
            return ["id": uid,
                    "appid": appId]
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .byCityName, .byCityId:
            return HTTPMethod.GET
        }
    }

}
