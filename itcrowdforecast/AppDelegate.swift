//
//  AppDelegate.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 4/5/18.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let coreDataStore = CoreDataStore()
    lazy var mainPresenter = {
        MainPresenter(coreDataStore: coreDataStore)
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Fabric.with([Crashlytics.self])
        
        mainPresenter.presentMainUI()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        coreDataStore.saveContext()
    }
    
}
