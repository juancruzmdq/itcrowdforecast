//
//  AppDelegate.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 4/5/18.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    lazy var itCrowdForecast: ITCrowdForecast = {
        ITCrowdForecast()
    }()
    
    lazy var mainPresenter = {
        MainPresenter(itCrowdForecast: self.itCrowdForecast)
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.mainPresenter.presentMainUI()
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.itCrowdForecast.coreDataStore.saveContext()
    }
    
}
