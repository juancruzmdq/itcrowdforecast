//
//  CityListViewModel.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import Foundation
import CoreData

protocol CityListViewModelDelegate: class {
    func cityListViewModelWillChange(_ cityListViewModel: CityListViewModel)
    func cityListViewModel(_ cityListViewModel: CityListViewModel, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    func cityListViewModelDidChange(_ cityListViewModel: CityListViewModel)
    func cityListViewModel(_ cityListViewModel: CityListViewModel, failLookupFor city: String)
    func cityListViewModel(_ cityListViewModel: CityListViewModel, loading: Bool)
}

class CityListViewModel: NSObject {
    
    private let localCitiesService: LocalCitiesService
    private let openWeatherProvider: OpenWeatherProvider

    weak var delegate: CityListViewModelDelegate?
    
    var fetchResultsController: NSFetchedResultsController<LocalCity>?
    
    var cities: [LocalCity]? {
        return self.fetchResultsController?.fetchedObjects
    }

    var loading: Bool = false {
        didSet {
            self.delegate?.cityListViewModel(self, loading: loading)
        }
    }

    init(localCitiesService: LocalCitiesService, openWeatherProvider: OpenWeatherProvider) {
        
        self.localCitiesService = localCitiesService
        self.openWeatherProvider = openWeatherProvider
        
        super.init()

        fetchResultsController = localCitiesService.buildCitiesFetchController()
        fetchResultsController?.delegate = self
        try? fetchResultsController?.performFetch()

    }
    
    func lookupForCityWith(name: String) {
        
        self.loading = true
        
        // Get city by name from remote service
        self.openWeatherProvider.weatherBy(city: name) { [weak self] result in
        
            guard let strongSelf = self else { return }
            
            strongSelf.loading = false
            
            switch result {
            case let .success(city):
                // store city in local store
                strongSelf.localCitiesService.updateOrCreateLocalCity(with: city)
            case .failure:
                strongSelf.delegate?.cityListViewModel(strongSelf, failLookupFor: name)
            }
        }
    }
    
    func delete(_ city: LocalCity) {
        self.localCitiesService.delete(city)
        // Force the fetchResultsController update, since I don't want to wait for the fetchResultsController.didChange, due in the view the delete animation looks better if is executed after the user swipe the cell
        try? self.fetchResultsController?.performFetch()
    }
    
    func refreshAllCities() {
        
        // Used to track the upload process of all assets, and notify when all task are complete
        let dispatchGroup = DispatchGroup()

        self.cities?.forEach { city in
            self.loading = true
            
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

        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let strongSelf = self else { return }
            // Once that all async tasks finished, finish this global task
            strongSelf.loading = false
        }

    }
    
}

extension CityListViewModel: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.delegate?.cityListViewModelWillChange(self)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        self.delegate?.cityListViewModel(self,
                                         didChange: anObject,
                                         at: indexPath,
                                         for: type,
                                         newIndexPath: newIndexPath)
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.delegate?.cityListViewModelDidChange(self)
    }

}
