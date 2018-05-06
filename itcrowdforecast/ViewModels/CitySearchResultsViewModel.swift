//
//  CitySearchResultsViewModel.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import Foundation

protocol CitySearchResultsViewModelDelegate: class {
    func searchResultDidUpdate(_ citySearchResultsViewModel: CitySearchResultsViewModel)
}

class CitySearchResultsViewModel {
    
    let googleMapsProvider = GoogleMapsProvider()
    
    weak var delegate: CitySearchResultsViewModelDelegate?
    
    var input: String = "" {
        didSet {
            self.inputUpdated()
        }
    }
    
    var items = [Prediction]() {
        didSet {
            self.delegate?.searchResultDidUpdate(self)
        }
    }
 
    func inputUpdated() {
        
        guard !self.input.isEmpty else { return }
        
        googleMapsProvider?.autocomplete(input: self.input) { [weak self] predictions in
            
            guard let strongSelf = self else { return }
            
            switch predictions {
            case let .success(predictions):
                let customPrediction = Prediction()
                customPrediction.description = strongSelf.input
                var newItems = [customPrediction]
                newItems.append(contentsOf: predictions.items)
                strongSelf.items = newItems
            case let .failure(error):
                print(error)
            }
        }
    }
    
}
