//
//  CityListPresenter.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 6/5/18.
//

import UIKit

class CityListPresenter {
    
    func cityDetail(for city: LocalCity, in navigation: UINavigationController) {
        
        if let cityDetailViewController = Storyboard.cityDetail.initialViewController() as? CityDetailViewController {
        
            cityDetailViewController.viewModel = CityDetailViewModel(for: city)
            navigation.pushViewController(cityDetailViewController, animated: true)
        }
    }
}
