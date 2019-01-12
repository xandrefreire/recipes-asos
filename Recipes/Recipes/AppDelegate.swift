//
//  AppDelegate.swift
//  Recipes
//
//  Created by Alexandre Freire on 11/01/2019.
//  Copyright © 2019 Alexandre Freire. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let appAssembly = AppAssembly()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let initialViewController = appAssembly.coreAssembly.recipeListAssemby.viewController()
        
        appAssembly.navigationController.pushViewController(initialViewController, animated: false)
        
        appAssembly.window.rootViewController = appAssembly.navigationController
        
        appAssembly.window.makeKeyAndVisible()
        return true
    }
}

