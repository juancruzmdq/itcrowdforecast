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
        
        let cityListViewController = Storyboard.cityList.initialViewController() as? CityListViewController
        cityListViewController?.viewModel = CityListViewModel(citiesProvider: CitiesProvider(store: self.coreDataStore), openWeatherProvider: OpenWeatherProvider())

        let navigationController = UINavigationController(rootViewController: cityListViewController!) // TODO: remove this !

        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }
}
