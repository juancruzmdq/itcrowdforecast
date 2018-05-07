//
//  OpenWeatherProvider.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import Foundation

/// Service to interact with the OpenWeather's API
class OpenWeatherProvider {
    
    private static let openWeatherBaseURL = "http://api.openweathermap.org/data/2.5"

    private let openWeatherKey: String
    private let remoteProviderService: RemoteProviderService
    
    /// Create a new instance of the OpenWeather API service with the specified account key
    ///
    /// - Parameter openWeatherKey: account key string
    init?(openWeatherKey: String) {
        guard let url = URL(string: OpenWeatherProvider.openWeatherBaseURL) else { return nil }

        self.openWeatherKey = openWeatherKey
        
        let session = URLSession(configuration: .default)
        self.remoteProviderService = RemoteProviderService(baseUrl: url, session: session)
        self.remoteProviderService.delegate = self
    }

    /// Get the weather report for a city with the specified name
    ///
    /// - Parameters:
    ///   - city: city name
    ///   - completion: callback with the service response
    func weatherBy(city: String, completion: @escaping (Result<City>) -> Void) {
        let endPoint = OpenWeatherEndPoint.byCityName(city: city, appId: self.openWeatherKey)
        self.remoteProviderService.call(endpoint: endPoint, completion: completion)
    }

    /// Get the weather report for a city with the specified id
    ///
    /// - Parameters:
    ///   - uid: city id
    ///   - completion: callback with the service response
    func weatherBy(uid: String, completion: @escaping (Result<City>) -> Void) {
        let endPoint = OpenWeatherEndPoint.byCityId(uid: uid, appId: self.openWeatherKey)
        self.remoteProviderService.call(endpoint: endPoint, completion: completion)
    }
}

extension OpenWeatherProvider: RemoteProviderServiceDelegate {
    
    func remoteProviderServiceValidate(response: [String: Any]) -> RemoteProviderServiceError? {
        // If the response has a error code and a message, return a new RemoteProviderServiceError
        if let cod = response["cod"] as? Double,
            let message = response["message"] as? String {
            return RemoteProviderServiceError.serviceFailed(code: String(format: "%.0f", cod), message: message)
        }
        return nil
    }
    
}
