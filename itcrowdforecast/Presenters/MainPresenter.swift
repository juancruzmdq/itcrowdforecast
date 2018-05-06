//
//  MainPresenter.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import UIKit

class MainPresenter {
    
    let window: UIWindow
    let coreDataStore: CoreDataStore
    
    init(coreDataStore: CoreDataStore) {
        self.coreDataStore = coreDataStore
        self.window = UIWindow(frame: UIScreen.main.bounds)
    }
    
    func presentMainUI() {
        
        if let cityListViewController = Storyboard.cityList.initialViewController() as? CityListViewController,
            let openWeatherProvider = OpenWeatherProvider() {
            
            let localCitiesService = LocalCitiesService(store: self.coreDataStore)
            
            cityListViewController.viewModel = CityListViewModel(localCitiesService: localCitiesService, openWeatherProvider: openWeatherProvider)
            cityListViewController.presenter = CityListPresenter()
            
            let navigationController = UINavigationController(rootViewController: cityListViewController)

            self.window.rootViewController = navigationController
            self.window.makeKeyAndVisible()
        }
        
    }
    
}
