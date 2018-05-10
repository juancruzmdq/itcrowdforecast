//
//  MainPresenter.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import UIKit

protocol MainPresenterProtocol {
    
    /// Create a new CityListViewController with the CityListViewModel, and add as rootViewController in the main window
    func presentMainUI()
}

class MainPresenter {
    
    let window: UIWindow
    let itCrowdForecast: ITCrowdForecast
    
    init(itCrowdForecast: ITCrowdForecast) {
        self.itCrowdForecast = itCrowdForecast
        self.window = UIWindow(frame: UIScreen.main.bounds)
    }
    
}

extension MainPresenter: MainPresenterProtocol {
    
    func presentMainUI() {
        
        if let cityListViewController: CityListViewController = ITStoryboard.cityList.initialViewController() {
            
            cityListViewController.viewModel = CityListViewModel(citiesServices: self.itCrowdForecast.citiesServices)
            cityListViewController.presenter = CityListPresenter(itCrowdForecast: self.itCrowdForecast)
            
            let navigationController = UINavigationController(rootViewController: cityListViewController)

            self.window.rootViewController = navigationController
            self.window.makeKeyAndVisible()
        }
        
    }
    
}
