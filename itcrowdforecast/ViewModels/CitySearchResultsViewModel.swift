//
//  CitySearchResultsViewModel.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import Foundation

protocol CitySearchResultsViewModelDelegate: class {
    func citySearchResultsViewModelDidUpdate(_ citySearchResultsViewModel: CitySearchResultsViewModel)
}

class CitySearchResultsViewModel {
    
    private var googleMapsProvider: GoogleMapsProvider
    
    weak var delegate: CitySearchResultsViewModelDelegate?
    
    var input: String = "" {
        didSet {
            // Every time that the user update the input text, we update the prediction list
            self.inputUpdated()
        }
    }
    
    var items = [Prediction]() {
        didSet {
            self.delegate?.citySearchResultsViewModelDidUpdate(self)
        }
    }
 
    init(googleMapsProvider: GoogleMapsProvider) {
        self.googleMapsProvider = googleMapsProvider
    }
    
    func inputUpdated() {
        
        guard !self.input.isEmpty else { return }
        
        googleMapsProvider.autocomplete(input: self.input) { [weak self] predictions in
            
            guard let strongSelf = self else { return }
            
            switch predictions {
            case let .success(predictions):
                // Create a custom prediction with the text typed by the use
                let customPrediction = Prediction()
                customPrediction.description = strongSelf.input
                var newItems = [customPrediction]
                
                // Concat the predictions from the google servide
                newItems.append(contentsOf: predictions.items)
                
                strongSelf.items = newItems
                
            case let .failure(error):
                print(error)
            }
        }
    }
    
}
