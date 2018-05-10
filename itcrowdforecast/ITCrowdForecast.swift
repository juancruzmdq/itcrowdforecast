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
    let networkActivityIndicator: NetworkActivityIndicatorProtocol
    let openWeatherProvider: OpenWeatherProviderProtocol
    let googleMapsProvider: GoogleMapsProviderProtocol
    let citiesServices: CitiesServicesProtocol
    
    init() {
        
        Fabric.with([Crashlytics.self])
        
        self.networkActivityIndicator = StatusBarNetworkActivityIndicator()
        self.coreDataStore = CoreDataStore(persistenContainerName: ITCrowdForecast.persistenContainerName)
        self.openWeatherProvider = OpenWeatherProvider(openWeatherKey: ITCrowdForecast.openWeatherKey, networkActivityIndicator: self.networkActivityIndicator)
        self.googleMapsProvider = GoogleMapsProvider(googleKey: ITCrowdForecast.googleKey, networkActivityIndicator: self.networkActivityIndicator)
        self.citiesServices = CitiesServices(localCitiesService: LocalCitiesService(store: self.coreDataStore ), openWeatherProvider: openWeatherProvider)

    }
}
