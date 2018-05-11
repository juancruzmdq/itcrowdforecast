//
//  ITCrowConfig.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 11/5/18.
//

import Foundation

typealias ITCrowConfig = ConfigType &
                         CoreDataStoreConfigProtocol &
                         OpenWeatherProviderConfigProtocol &
                         GoogleMapProviderConfigProtocol

extension Config: CoreDataStoreConfigProtocol {

    var persistenContainerName: String {
        // example of setting a config value dependng of the environment
        switch environment {
        case .dev:
            return "itcrowdforecast"
        default:
            assertionFailure("Undefined persistenContainerName for enviroment: \(self.environment)")
            return ""
        }

    }

}

extension Config: OpenWeatherProviderConfigProtocol {
    var openWeatherKey: String { return "e97ec39746568cc587b9fd0b7d34f7a1" }
    var openWeatherBaseURL: String { return "http://api.openweathermap.org/data/2.5" }
}

extension Config: GoogleMapProviderConfigProtocol {
    var googleKey: String { return "AIzaSyBOPxZFIR8nBaLzXACGA9kRW2CbYxMsMTk" }
    var googleBaseURL: String { return "https://maps.googleapis.com/maps/api/place" }
}
