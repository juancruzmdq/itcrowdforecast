//
//  GoogleMapsProvider.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import Foundation

/// Protocol to be implemented by the GoogleMapProviderConfig provider
protocol GoogleMapProviderConfigProtocol {
    var googleKey: String { get }
    var googleBaseURL: String { get }
}

protocol GoogleMapsProviderProtocol {
    
    /// Return a list of predictions with posibles cities names for the input text
    ///
    /// - Parameters:
    ///   - input: text to autocomplete
    ///   - completion: callback with the service response
    func autocomplete(input: String, completion: @escaping (Result<Predictions>) -> Void)
}

/// Service to interact with the GoogleMap's API
class GoogleMapsProvider {
    
    private let googleBaseURL: String
    private let googleKey: String
    private let remoteService: RemoteServiceProtocol
    
    /// Create a new googleMap service with the given key
    ///
    /// - Parameter config: instance of a GoogleMapProviderConfigProtocol
    /// - networkActivityIndicator: Activity indicator handler
    init(config: GoogleMapProviderConfigProtocol, networkActivityIndicator: NetworkActivityIndicatorProtocol? = nil) {
        
        self.googleKey = config.googleKey
        self.googleBaseURL = config.googleBaseURL

        let session = URLSession(configuration: .default)
        let url = URL(string: self.googleBaseURL)!
        
        self.remoteService = RemoteService(baseUrl: url,
                                           session: session,
                                           strategies: [KeyValueQueryItemStrategy(key: "key", value: self.googleKey),
                                                        NetworkActivityIndicatorStrategy(networkActivityIndicator: networkActivityIndicator)])
    }
    
}

extension GoogleMapsProvider: GoogleMapsProviderProtocol {
    
    func autocomplete(input: String, completion: @escaping (Result<Predictions>) -> Void) {
        let endPoint = GoogleMapsEndPoint.Autocomplete.get(for: input, key: self.googleKey)
        self.remoteService.call(endpoint: endPoint, completion: completion)
    }
    
}
