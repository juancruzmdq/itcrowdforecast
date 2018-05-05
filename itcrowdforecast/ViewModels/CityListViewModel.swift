//
//  CityListViewModel.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import Foundation
import CoreData

protocol CityListViewModelDelegate: class {
    func citiesDidChange(_ cityListViewModel: CityListViewModel)
}

class CityListViewModel: NSObject {
    
    let citiesProvider: CitiesProvider
    let openWeatherProvider: OpenWeatherProvider
    var fetchResultsController: NSFetchedResultsController<LocalCity>?
    weak var delegate: CityListViewModelDelegate?
    
    init(citiesProvider: CitiesProvider, openWeatherProvider: OpenWeatherProvider) {
        
        self.citiesProvider = citiesProvider
        self.openWeatherProvider = openWeatherProvider
        
        super.init()

        fetchResultsController = citiesProvider.buildCitiesFetchController()
        fetchResultsController?.delegate = self
        try? fetchResultsController?.performFetch()

    }
    
    var cities: [LocalCity]? {
        return self.fetchResultsController?.fetchedObjects
    }
    
    func lookupForCityWith(name: String) {
        
        self.openWeatherProvider.weatherBy(city: name) { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
            case let .success(city):
                strongSelf.citiesProvider.updateOrCreate(city)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func delete(_ city: LocalCity) {
        self.citiesProvider.delete(city)
        try? self.fetchResultsController?.performFetch()
    }
    
}

extension CityListViewModel: NSFetchedResultsControllerDelegate {

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.delegate?.citiesDidChange(self)
    }

}
