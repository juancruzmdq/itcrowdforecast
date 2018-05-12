//
//  CitiesServices.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 7/5/18.
//

import Foundation
import CoreData

enum ModelServiceResultError {
    case remoteServiceError(_: RemoteServiceError)
    case localServiceError(_: String)
    
    var localizedDescription: String {
        switch self {
        case let .remoteServiceError(error):
            return "remoteServiceError: \(error.localizedDescription)"
        case let .localServiceError(message):
            return "localServiceError: \(message)"
        }
    }
}

enum ModelServiceResult<T> {
    case success(_: T)
    case failure(_: ModelServiceResultError)
}

protocol CitiesServicesProtocol: LocalCitiesServiceProtocol {
    
    /// Get all cities stored locally, and call API tu update the forecast.
    ///
    /// - Parameter completion: Block called at the ende of cities the update.
    func reloadAllCities(completion:@escaping () -> Void)
    
    func weatherBy(city: String, completion: @escaping (ModelServiceResult<LocalCity>) -> Void)
    
    func weatherBy(uid: String, completion: @escaping (ModelServiceResult<LocalCity>) -> Void)
}

/// This class is in charge of the interaction between LocalCitiesService and OpenWeatherProvider
class CitiesServices {
    
    let localCitiesService: LocalCitiesServiceProtocol
    let openWeatherProvider: OpenWeatherProviderProtocol
    
    init(localCitiesService: LocalCitiesServiceProtocol, openWeatherProvider: OpenWeatherProviderProtocol) {
        self.localCitiesService = localCitiesService
        self.openWeatherProvider = openWeatherProvider
    }
    
}

extension CitiesServices: CitiesServicesProtocol {
    
    func weatherBy(city: String, completion: @escaping (ModelServiceResult<LocalCity>) -> Void) {
        
        self.openWeatherProvider.weatherBy(city: city) { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
            case let .success(city):
                // store city in local store
                strongSelf.localCitiesService.updateOrCreateLocalCity(with: city) { city in
                    if let city = city {
                        completion(.success(city))
                    } else {
                        completion(.failure(.localServiceError("Return empty instance of LocalCity")))
                    }
                }
            case let .failure(error):
                completion(.failure(.remoteServiceError(error)))
            }
        }

    }
    
    func weatherBy(uid: String, completion: @escaping (ModelServiceResult<LocalCity>) -> Void) {
        
        self.openWeatherProvider.weatherBy(uid: uid) { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
            case let .success(city):
                // store city in local store
                strongSelf.localCitiesService.updateOrCreateLocalCity(with: city) { city in
                    if let city = city {
                        completion(.success(city))
                    } else {
                        completion(.failure(.localServiceError("Return empty instance of LocalCity")))
                    }
                }
            case let .failure(error):
                completion(.failure(.remoteServiceError(error)))
            }
        }
    }
    
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
                    strongSelf.localCitiesService.updateOrCreateLocalCity(with: city, completion: nil)
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
    
    func updateOrCreateLocalCity(with city: City, completion: ((LocalCity?) -> Void)?) {
        self.localCitiesService.updateOrCreateLocalCity(with: city, completion: completion)
    }
    
    func delete(_ city: LocalCity) {
        self.localCitiesService.delete(city)
    }
    
}
