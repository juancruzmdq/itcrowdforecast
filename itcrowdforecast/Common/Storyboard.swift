//
//  Storyboard.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import UIKit

protocol Storyboard { }

extension Storyboard where Self: RawRepresentable {
    
    var storyboard: UIStoryboard? {
        return UIStoryboard(name: "\(self.rawValue)", bundle: nil)
    }
    
    func initialViewController<T: UIViewController>() -> T? {
        return storyboard?.instantiateInitialViewController() as? T
    }

}
