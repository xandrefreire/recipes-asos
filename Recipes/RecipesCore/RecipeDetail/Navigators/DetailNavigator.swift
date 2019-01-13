//
//  DetailNavigator.swift
//  RecipesCore
//
//  Created by Alexandre Freire on 13/01/2019.
//  Copyright © 2019 Alexandre Freire. All rights reserved.
//

import Foundation

protocol DetailNavigator {
    func showDetail(of recipe: Recipe)
}

final class PhoneDetailNavigator: DetailNavigator {
    // MARK: - Properties
    private let navigationController: UINavigationController
    
    private unowned let viewControllerProvider: RecipeDetailViewControllerProvider
    
    init(navigationController: UINavigationController, viewControllerProvider: RecipeDetailViewControllerProvider) {
        self.navigationController = navigationController
        self.viewControllerProvider = viewControllerProvider
    }
    
    
    func showDetail(of recipe: Recipe) {
        let viewController = viewControllerProvider.viewController(recipe: recipe)

        navigationController.pushViewController(viewController, animated: true)
    }
    
    
}
