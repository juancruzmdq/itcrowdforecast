//
//  OpenWeatherProvider.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import Foundation

class OpenWeatherProvider {
    
    private static let openWeatherKey = "e97ec39746568cc587b9fd0b7d34f7a1"
    private static let openWeatherBaseURL = "http://api.openweathermap.org/data/2.5"

    private let remoteProviderService: RemoteProviderService
    
    init?() {
        guard let url = URL(string: OpenWeatherProvider.openWeatherBaseURL) else { return nil }

        let session = URLSession(configuration: .default)
        self.remoteProviderService = RemoteProviderService(baseUrl: url, session: session)
        self.remoteProviderService.delegate = self
    }

    func weatherBy(city: String, completion: @escaping (Result<City>) -> Void) {
        let endPoint = OpenWeatherEndPoint.byCityName(city: city, appId: OpenWeatherProvider.openWeatherKey)
        self.remoteProviderService.call(endpoint: endPoint, completion: completion)
    }
}

extension OpenWeatherProvider: RemoteProviderServiceDelegate {
    
    func remoteProviderServiceValidate(response: [String: Any]) -> RemoteProviderServiceError? {
        if let cod = response["cod"] as? String,
            let message = response["message"] as? String {
            return RemoteProviderServiceError.serviceFailed(code: cod, message: message)
        }
        return nil
    }
    
}
