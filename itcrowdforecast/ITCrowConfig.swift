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
    var openWeatherKey: String {
        switch environment {
        case .dev:
            return "e97ec39746568cc587b9fd0b7d34f7a1"
        default:
            assertionFailure("Undefined openWeatherKey for enviroment: \(self.environment)")
            return ""
        }
    }
    
    var openWeatherBaseURL: String {
        switch environment {
        case .dev:
            return "http://api.openweathermap.org/data/2.5"
        default:
            assertionFailure("Undefined openWeatherBaseURL for enviroment: \(self.environment)")
            return ""
        }
    }
    
}

extension Config: GoogleMapProviderConfigProtocol {
    var googleKey: String {
        switch environment {
        case .dev:
            return "AIzaSyBOPxZFIR8nBaLzXACGA9kRW2CbYxMsMTk"
        default:
            assertionFailure("Undefined googleKey for enviroment: \(self.environment)")
            return ""
        }

    }
    
    var googleBaseURL: String {
        switch environment {
        case .dev:
            return "https://maps.googleapis.com/maps/api/place"
        default:
            assertionFailure("Undefined googleBaseURL for enviroment: \(self.environment)")
            return ""
        }

    }
    
}
