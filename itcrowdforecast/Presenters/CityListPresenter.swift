//
//  CityListPresenter.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 6/5/18.
//

import UIKit

class CityListPresenter {
    
    let itCrowdForecast: ITCrowdForecast
    
    init(itCrowdForecast: ITCrowdForecast) {
        self.itCrowdForecast = itCrowdForecast
    }
    
    /// Push a new CityDetailViewController with the CityDetailViewModel
    ///
    /// - Parameters:
    ///   - city: city to display
    ///   - navigation: push in this navigation controller
    func cityDetail(for city: LocalCity, in navigation: UINavigationController) {
        
        if let cityDetailViewController = Storyboard.cityDetail.initialViewController() as? CityDetailViewController {
        
            cityDetailViewController.viewModel = CityDetailViewModel(for: city)
            navigation.pushViewController(cityDetailViewController, animated: true)
        }
    }
    
    /// Create a new instance of CitySearchResultsViewController with CitySearchResultsViewModel
    ///
    /// - Returns: New CitySearchResultsViewController instances
    func buildCitySearchResultsViewController() -> CitySearchResultsViewController {
        let citySearchResultsViewController = CitySearchResultsViewController()

        if let googleMapsProvider = self.itCrowdForecast.googleMapsProvider {
            citySearchResultsViewController.viewModel = CitySearchResultsViewModel(googleMapsProvider: googleMapsProvider)
        }
        return citySearchResultsViewController
    }

}
