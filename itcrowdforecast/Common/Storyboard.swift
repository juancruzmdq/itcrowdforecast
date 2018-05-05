//
//  Storyboard.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import UIKit

enum Storyboard: String {
    case cityList = "CityList"
}

extension Storyboard {
    
    var storyboard: UIStoryboard? {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
    
    func initialViewController<T: UIViewController>() -> T? {
        return storyboard?.instantiateInitialViewController() as? T
    }

}
