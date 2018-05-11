//
//  OpenWeatherProvider.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import Foundation

/// Protocol to be implemented by the OpenWeatherProviderConfig provider
protocol OpenWeatherProviderConfigProtocol {
    var openWeatherKey: String { get }
    var openWeatherBaseURL: String { get }
}

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
    
    private let openWeatherBaseURL: String
    private let openWeatherKey: String
    
    private var remoteService: RemoteServiceProtocol
    
    /// Create a new instance of the OpenWeather API service with the specified account key
    ///
    /// - Parameter config: instance of a OpenWeatherProviderConfigProtocol
    /// - networkActivityIndicator: Activity indicator handler
    init(config: OpenWeatherProviderConfigProtocol, networkActivityIndicator: NetworkActivityIndicatorProtocol?) {
        
        self.openWeatherKey = config.openWeatherKey
        self.openWeatherBaseURL = config.openWeatherBaseURL

        let session = URLSession(configuration: .default)
        let url = URL(string: self.openWeatherBaseURL)!
        
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
