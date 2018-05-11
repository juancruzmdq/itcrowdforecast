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
    
    let config: ITCrowConfig
    let coreDataStore: CoreDataStore
    let networkActivityIndicator: NetworkActivityIndicatorProtocol
    let openWeatherProvider: OpenWeatherProviderProtocol
    let googleMapsProvider: GoogleMapsProviderProtocol
    let citiesServices: CitiesServicesProtocol
    
    init() {
        
        Fabric.with([Crashlytics.self])
        
        self.config = Config(bundle: .main, locale: .current)

        self.networkActivityIndicator = StatusBarNetworkActivityIndicator()

        self.coreDataStore = CoreDataStore(config: self.config)

        self.openWeatherProvider = OpenWeatherProvider(config: self.config,
                                                       networkActivityIndicator: self.networkActivityIndicator)
        
        self.googleMapsProvider = GoogleMapsProvider(config: self.config,
                                                     networkActivityIndicator: self.networkActivityIndicator)
        
        self.citiesServices = CitiesServices(localCitiesService: LocalCitiesService(store: self.coreDataStore ),
                                             openWeatherProvider: openWeatherProvider)

    }
}
