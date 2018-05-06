//
//  OpenWeatherProvider.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import Foundation

class OpenWeatherProvider {
    
    private let openWeatherKey: String
    private static let openWeatherBaseURL = "http://api.openweathermap.org/data/2.5"

    private let remoteProviderService: RemoteProviderService
    
    init?(openWeatherKey: String) {
        guard let url = URL(string: OpenWeatherProvider.openWeatherBaseURL) else { return nil }

        self.openWeatherKey = openWeatherKey
        
        let session = URLSession(configuration: .default)
        self.remoteProviderService = RemoteProviderService(baseUrl: url, session: session)
        self.remoteProviderService.delegate = self
    }

    func weatherBy(city: String, completion: @escaping (Result<City>) -> Void) {
        let endPoint = OpenWeatherEndPoint.byCityName(city: city, appId: self.openWeatherKey)
        self.remoteProviderService.call(endpoint: endPoint, completion: completion)
    }
}

extension OpenWeatherProvider: RemoteProviderServiceDelegate {
    
    func remoteProviderServiceValidate(response: [String: Any]) -> RemoteProviderServiceError? {
        if let cod = response["cod"] as? Double,
            let message = response["message"] as? String {
            return RemoteProviderServiceError.serviceFailed(code: String(format: "%.0f", cod), message: message)
        }
        return nil
    }
    
}
