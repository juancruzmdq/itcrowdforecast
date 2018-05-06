//
//  GoogleMapsProvider.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import Foundation

class GoogleMapsProvider {
    
    private static let googleKey = "AIzaSyBOPxZFIR8nBaLzXACGA9kRW2CbYxMsMTk"
    private static let googleBaseURL = "https://maps.googleapis.com/maps/api/place"
    
    private let remoteProviderService: RemoteProviderService
    
    init?() {
        guard let url = URL(string: GoogleMapsProvider.googleBaseURL) else { return nil }
        let session = URLSession(configuration: .default)
        self.remoteProviderService = RemoteProviderService(baseUrl: url, session: session)
    }
    
    func autocomplete(input: String, completion: @escaping (Result<Predictions>) -> Void) {
        let endPoint = GoogleMapsEndPoint.autocomplete(input: input, key: GoogleMapsProvider.googleKey)
        self.remoteProviderService.call(endpoint: endPoint, completion: completion)
    }
}
