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
    
    init() {
        let url = URL(string: OpenWeatherProvider.openWeatherBaseURL)
        let session = URLSession(configuration: .default)
        self.remoteProviderService = RemoteProviderService(baseUrl: url, session: session)
    }

    func weatherBy(city: String, completion: @escaping (Result<City>) -> Void) {
        let endPoint = OpenWeatherEndPoint.byCityName(city: city, appId: OpenWeatherProvider.openWeatherKey)
        self.remoteProviderService.call(endpoint: endPoint, completion: completion)
    }
}
