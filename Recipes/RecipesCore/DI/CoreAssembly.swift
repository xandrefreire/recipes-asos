//
//  CoreAssembly.swift
//  RecipesCore
//
//  Created by Alexandre Freire on 12/01/2019.
//  Copyright © 2019 Alexandre Freire. All rights reserved.
//

import Foundation


final public class CoreAssembly {
    public private(set) lazy var recipeListAssemby = RecipeListAssembly(webServiceAssembly: webServiceAssembly, imageLoadingAssembly: imageLoadingAssembly, searchAssembly: searchAssembly, detailAssembly: recipeDetailAssembly)
    
    private(set) lazy var recipeDetailAssembly = RecipeDetailAssembly(imageLoadingAssembly: imageLoadingAssembly, navigationController: navigationController)
    
    private(set) lazy var imageLoadingAssembly = ImageLoadingAssembly()
    
    private(set) lazy var searchAssembly = SearchAssembly()
    
    private(set) lazy var webServiceAssembly = WebServiceAssembly()
    
    private let navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
