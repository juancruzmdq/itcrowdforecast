//
//  CityListPresenter.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 6/5/18.
//

import UIKit

protocol CityListPresenterProtocol {

    /// Push a new CityDetailViewController with the CityDetailViewModel
    ///
    /// - Parameters:
    ///   - city: city to display
    ///   - navigation: push in this navigation controller
    func cityDetail(for city: LocalCity, in navigation: UINavigationController)

    /// Create a new instance of CitySearchResultsViewController with CitySearchResultsViewModel
    ///
    /// - Returns: New CitySearchResultsViewController instances
    func buildCitySearchResultsViewController() -> CitySearchResultsViewController
}

class CityListPresenter {
    
    let itCrowdForecast: ITCrowdForecast
    
    init(itCrowdForecast: ITCrowdForecast) {
        self.itCrowdForecast = itCrowdForecast
    }
    
}

extension CityListPresenter: CityListPresenterProtocol {
    
    func cityDetail(for city: LocalCity, in navigation: UINavigationController) {
        if let cityDetailViewController: CityDetailViewController = ITStoryboard.cityDetail.initialViewController() {
            cityDetailViewController.viewModel = CityDetailViewModel(for: city)
            navigation.pushViewController(cityDetailViewController, animated: true)
        }
    }
    
    func buildCitySearchResultsViewController() -> CitySearchResultsViewController {
        let citySearchResultsViewController = CitySearchResultsViewController()

        citySearchResultsViewController.viewModel = CitySearchResultsViewModel(googleMapsProvider: self.itCrowdForecast.googleMapsProvider)

        return citySearchResultsViewController
    }

}
