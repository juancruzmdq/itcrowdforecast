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
        
        self.openWeatherProvider.weatherBy(city: name) { [weak self] result in
        
            guard let strongSelf = self else { return }
            
            strongSelf.loading = false
            
            switch result {
            case let .success(city):
                strongSelf.localCitiesService.updateOrCreateLocalCity(with: city)
            case .failure:
                strongSelf.delegate?.cityListViewModel(strongSelf, failLookupFor: name)
            }
        }
    }
    
    func delete(_ city: LocalCity) {
        self.localCitiesService.delete(city)
        try? self.fetchResultsController?.performFetch()
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
