//
//  MainPresenter.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import UIKit

class MainPresenter {
    
    let window: UIWindow
    let itCrowdForecast: ITCrowdForecast
    
    init(itCrowdForecast: ITCrowdForecast) {
        self.itCrowdForecast = itCrowdForecast
        self.window = UIWindow(frame: UIScreen.main.bounds)
    }
    
    func presentMainUI() {
        
        if let cityListViewController = Storyboard.cityList.initialViewController() as? CityListViewController,
            let openWeatherProvider = self.itCrowdForecast.openWeatherProvider {
            
            let localCitiesService = LocalCitiesService(store: self.itCrowdForecast.coreDataStore)
            
            cityListViewController.viewModel = CityListViewModel(localCitiesService: localCitiesService, openWeatherProvider: openWeatherProvider)
            cityListViewController.presenter = CityListPresenter(itCrowdForecast: self.itCrowdForecast)
            
            let navigationController = UINavigationController(rootViewController: cityListViewController)

            self.window.rootViewController = navigationController
            self.window.makeKeyAndVisible()
        }
        
    }
    
}
