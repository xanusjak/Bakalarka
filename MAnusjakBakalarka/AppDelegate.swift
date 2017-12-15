//
//  AppDelegate.swift
//  MAnusjakBakalarka
//
//  Created by Milan Anusjak on 19/09/2017.
//  Copyright © 2017 Milan Anusjak. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            print("\(key) = \(value) \n")
        }
        
        self.setupAppeareance()
        
        let navController = UINavigationController(rootViewController: StartViewController())
        
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    fileprivate func setupAppeareance() {
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
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
    }

}

