//
//  OpenWeatherEndPoint.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import Foundation

/// Set of OpenWeather endpoints
///
/// - CityWeather: can return a city info by Id, or by cityname
enum OpenWeatherEndPoint {
    /// Namepace for "/weather" enpoints
    enum CityWeather {
        private static let path = "/weather"
        
        static func get(withName name: String, key: String) -> Endpoint<City> {
            return Endpoint(method: .get,
                            path: OpenWeatherEndPoint.CityWeather.path,
                            parameters: ["q": name] )
        }
        static func get(withId uid: String, key: String) -> Endpoint<City> {
            return Endpoint(method: .get,
                            path: OpenWeatherEndPoint.CityWeather.path,
                            parameters: ["id": uid] )
        }
    }
    
}
