//
//  ITCrowdForecast.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 6/5/18.
//

import Foundation
import Fabric
import Crashlytics

class ITCrowdForecast {
    
    private static let googleKey = "AIzaSyBOPxZFIR8nBaLzXACGA9kRW2CbYxMsMTk"
    private static let openWeatherKey = "e97ec39746568cc587b9fd0b7d34f7a1"
    private static let persistenContainerName = "itcrowdforecast"

    let coreDataStore: CoreDataStore
    let openWeatherProvider: OpenWeatherProvider?
    let googleMapsProvider: GoogleMapsProvider?
    
    init() {
        
        Fabric.with([Crashlytics.self])
        
        self.coreDataStore = CoreDataStore(persistenContainerName: ITCrowdForecast.persistenContainerName)
        self.openWeatherProvider = OpenWeatherProvider(openWeatherKey: ITCrowdForecast.openWeatherKey)
        self.googleMapsProvider = GoogleMapsProvider(googleKey: ITCrowdForecast.googleKey)
    }
}
