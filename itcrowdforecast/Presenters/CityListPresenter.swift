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
    func cityDetail(for city: LocalCity, in navigation: UINavigationController) {
        
        if let cityDetailViewController = Storyboard.cityDetail.initialViewController() as? CityDetailViewController {
        
            cityDetailViewController.viewModel = CityDetailViewModel(for: city)
            navigation.pushViewController(cityDetailViewController, animated: true)
        }
    }
    
    func buildCitySearchResultsViewController() -> CitySearchResultsViewController {
        let citySearchResultsViewController = CitySearchResultsViewController()

        if let googleMapsProvider = self.itCrowdForecast.googleMapsProvider {
            citySearchResultsViewController.viewModel = CitySearchResultsViewModel(googleMapsProvider: googleMapsProvider)
        }
        return citySearchResultsViewController
    }

}
