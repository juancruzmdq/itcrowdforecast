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
    
    private let citiesServices: CitiesServicesProtocol

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

    init(citiesServices: CitiesServicesProtocol) {
        
        self.citiesServices = citiesServices
        
        super.init()

        self.fetchResultsController = self.citiesServices.buildCitiesFetchController()
        self.fetchResultsController?.delegate = self
        try? self.fetchResultsController?.performFetch()

    }
    
    func lookupForCityWith(name: String) {
        
        self.loading = true
        
        // Get city by name from remote service
        self.citiesServices.weatherBy(city: name) { [weak self] result in
        
            guard let strongSelf = self else { return }
            
            strongSelf.loading = false
            
            switch result {
            case .success:
            break // nothing to do, the info will be updated with fetchResultsController
            case .failure:
                strongSelf.delegate?.cityListViewModel(strongSelf, failLookupFor: name)
            }
        }
    }
    
    func delete(_ city: LocalCity) {
        self.citiesServices.delete(city)
        // Force the fetchResultsController update, since I don't want to wait for the fetchResultsController.didChange, due in the view the delete animation looks better if is executed after the user swipe the cell
        try? self.fetchResultsController?.performFetch()
    }
    
    func refreshAllCities() {
        
        self.loading = true
        self.citiesServices.reloadAllCities { [weak self] _ in
            guard let strongSelf = self else { return }

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
