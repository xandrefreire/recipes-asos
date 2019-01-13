//
//  RecipeDetailAssembly.swift
//  RecipesCore
//
//  Created by Alexandre Freire on 13/01/2019.
//  Copyright © 2019 Alexandre Freire. All rights reserved.
//

import Foundation

final class RecipeDetailAssembly {
    
    // MARK: Properties
    private let navigationController: UINavigationController
    private let imageLoadingAssembly: ImageLoadingAssembly

    // MARK: Initialization
    init(imageLoadingAssembly: ImageLoadingAssembly, navigationController: UINavigationController) {
        self.imageLoadingAssembly = imageLoadingAssembly
        self.navigationController = navigationController
    }
    
    
    func detailNavigator() -> DetailNavigator {
        return PhoneDetailNavigator(navigationController: navigationController, viewControllerProvider: self)
    }
    
    func presenter(recipe: Recipe) -> RecipeDetailPresenter {
        return RecipeDetailPresenter(recipe: recipe, detailNavigator: detailNavigator())
    }
    
    func imagePresenter() -> RecipeImagePresenter {
        return RecipeImagePresenter(imageRepository: imageLoadingAssembly.imageRepository)
    }
}

extension RecipeDetailAssembly: RecipeDetailViewControllerProvider {
    func viewController(recipe: Recipe) -> RecipeDetailViewController {
        return RecipeDetailViewController(presenter: presenter(recipe: recipe), imagePresenter: imagePresenter())
    }
    
    
}
