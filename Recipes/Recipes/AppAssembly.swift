//
//  AppAssembly.swift
//  Recipes
//
//  Created by Alexandre Freire on 12/01/2019.
//  Copyright © 2019 Alexandre Freire. All rights reserved.
//

import Foundation
import RecipesCore

final class AppAssembly {
    private(set) lazy var window = UIWindow(frame: UIScreen.main.bounds)
    private(set) lazy var navigationController = UINavigationController()
    private(set) lazy var coreAssembly = CoreAssembly(navigationController: navigationController)
}
