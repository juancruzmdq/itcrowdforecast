//
//  OpenWeatherProvider.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import Foundation

protocol OpenWeatherProviderProtocol {
    
    /// Get the weather report for a city with the specified name
    ///
    /// - Parameters:
    ///   - city: city name
    ///   - completion: callback with the service response
    func weatherBy(city: String, completion: @escaping (Result<City>) -> Void)
    
    /// Get the weather report for a city with the specified id
    ///
    /// - Parameters:
    ///   - uid: city id
    ///   - completion: callback with the service response
    func weatherBy(uid: String, completion: @escaping (Result<City>) -> Void)
}

/// Service to interact with the OpenWeather's API
class OpenWeatherProvider {
    
    private static let openWeatherBaseURL = "http://api.openweathermap.org/data/2.5"
    
    private let openWeatherKey: String
    private var remoteService: RemoteServiceProtocol
    
    /// Create a new instance of the OpenWeather API service with the specified account key
    ///
    /// - Parameter openWeatherKey: account key string
    /// - networkActivityIndicator: Activity indicator handler
    init(openWeatherKey: String, networkActivityIndicator: NetworkActivityIndicatorProtocol?) {
        
        self.openWeatherKey = openWeatherKey
        
        let session = URLSession(configuration: .default)
        let url = URL(string: OpenWeatherProvider.openWeatherBaseURL)!
        
        self.remoteService = RemoteService(baseUrl: url,
                                           session: session,
                                           strategies: [KeyValueQueryItemStrategy(key: "appid", value: openWeatherKey),
                                                        NetworkActivityIndicatorStrategy(networkActivityIndicator: networkActivityIndicator),
                                                        OpenWeatherResponseValidationStrategy()])
    }
}

extension OpenWeatherProvider: OpenWeatherProviderProtocol {

    func weatherBy(city: String, completion: @escaping (Result<City>) -> Void) {
        let endPoint = OpenWeatherEndPoint.CityWeather.get(withName: city, key: self.openWeatherKey)
        self.remoteService.call(endpoint: endPoint, completion: completion)
    }

    func weatherBy(uid: String, completion: @escaping (Result<City>) -> Void) {
        let endPoint = OpenWeatherEndPoint.CityWeather.get(withId: uid, key: self.openWeatherKey)
        self.remoteService.call(endpoint: endPoint, completion: completion)
    }
}
