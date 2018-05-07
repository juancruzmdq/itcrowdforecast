//
//  CitiesServices.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 7/5/18.
//

import Foundation
import CoreData

protocol CitiesServicesProtocol: LocalCitiesServiceProtocol, OpenWeatherProviderProtocol {
    
    /// Get all cities stored locally, and call API tu update the forecast.
    ///
    /// - Parameter completion: Block called at the ende of cities the update.
    func reloadAllCities(completion:@escaping () -> Void)
}

class CitiesServices {
    
    let localCitiesService: LocalCitiesServiceProtocol
    let openWeatherProvider: OpenWeatherProviderProtocol
    
    init(localCitiesService: LocalCitiesServiceProtocol, openWeatherProvider: OpenWeatherProviderProtocol) {
        self.localCitiesService = localCitiesService
        self.openWeatherProvider = openWeatherProvider
    }
    
}

extension CitiesServices: CitiesServicesProtocol {
    
    func reloadAllCities(completion:@escaping () -> Void) {
        
        // Get all cities
        let fetchResultsController = localCitiesService.buildCitiesFetchController()
        try? fetchResultsController?.performFetch()
        
        // Used to track the upload process of all assets, and notify when all task are complete
        let dispatchGroup = DispatchGroup()
        
        fetchResultsController?.fetchedObjects?.forEach { city in
            
            guard let cityName = city.name else { return }
            
            // Indicate the begining of a new async task
            dispatchGroup.enter()
            
            // I've tried to update the list using weatherBy(id), but the API return diferents cities with the same id
            // Check this two API call
            // http://api.openweathermap.org/data/2.5/weather?q=Tucuman,%20Tucum%C3%A1n,%20Argentina&appid=e97ec39746568cc587b9fd0b7d34f7a1
            // http://api.openweathermap.org/data/2.5/weather?id=3934608&appid=e97ec39746568cc587b9fd0b7d34f7a1
            // or this two:
            // http://api.openweathermap.org/data/2.5/weather?q=Mar%20del%20Plata,%20Buenos%20Aires,%20Argentina&appid=e97ec39746568cc587b9fd0b7d34f7a1
            // http://api.openweathermap.org/data/2.5/weather?q=Caleta%20Olivia,%20Santa%20Cruz%20Province,%20Argentina&appid=e97ec39746568cc587b9fd0b7d34f7a1
            self.openWeatherProvider.weatherBy(city: cityName) { [weak self] result in
                
                guard let strongSelf = self else { return }
                
                switch result {
                case let .success(city):
                    strongSelf.localCitiesService.updateOrCreateLocalCity(with: city)
                default:
                    break
                }
                // Indicate the begining of a new async task
                dispatchGroup.leave()
            }
            
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            // Once that all async tasks finished, finish this global task
            completion()
        }
        
    }
    
    func buildCitiesFetchController() -> NSFetchedResultsController<LocalCity>? {
        return self.localCitiesService.buildCitiesFetchController()
    }
    
    func updateOrCreateLocalCity(with city: City) {
        self.localCitiesService.updateOrCreateLocalCity(with: city)
    }
    
    func delete(_ city: LocalCity) {
        self.localCitiesService.delete(city)
    }
    
    func weatherBy(city: String, completion: @escaping (Result<City>) -> Void) {
        self.openWeatherProvider.weatherBy(city: city, completion: completion)
    }
    
    func weatherBy(uid: String, completion: @escaping (Result<City>) -> Void) {
        self.openWeatherProvider.weatherBy(uid: uid, completion: completion)
    }

}
