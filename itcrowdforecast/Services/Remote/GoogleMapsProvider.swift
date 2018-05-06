//
//  GoogleMapsProvider.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import Foundation

/// Service to interact with the GoogleMap's API
class GoogleMapsProvider {
    
    private static let googleBaseURL = "https://maps.googleapis.com/maps/api/place"
    
    private let googleKey: String
    private let remoteProviderService: RemoteProviderService
    
    init?(googleKey: String) {
        guard let url = URL(string: GoogleMapsProvider.googleBaseURL) else { return nil }

        self.googleKey = googleKey

        let session = URLSession(configuration: .default)
        self.remoteProviderService = RemoteProviderService(baseUrl: url, session: session)
    }
    
    func autocomplete(input: String, completion: @escaping (Result<Predictions>) -> Void) {
        let endPoint = GoogleMapsEndPoint.autocomplete(input: input, key: self.googleKey)
        self.remoteProviderService.call(endpoint: endPoint, completion: completion)
    }
}
