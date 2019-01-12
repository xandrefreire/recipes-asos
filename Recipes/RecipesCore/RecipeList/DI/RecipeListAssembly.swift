//
//  RecipeListAssembly.swift
//  RecipesCore
//
//  Created by Alexandre Freire on 12/01/2019.
//  Copyright © 2019 Alexandre Freire. All rights reserved.
//

import Foundation

final public class RecipeListAssembly {
    
    // MARK: Properties
    private let imageLoadingAssembly: ImageLoadingAssembly
    private let webServiceAssembly: WebServiceAssembly

    // MARK: Initialization
    init(webServiceAssembly: WebServiceAssembly, imageLoadingAssembly: ImageLoadingAssembly) {
        self.webServiceAssembly = webServiceAssembly
        self.imageLoadingAssembly = imageLoadingAssembly
    }
    
    public func viewController() -> UIViewController {
        return RecipeListViewController(viewModel: viewModel(), cellPresenter: cellPresenter())
    }
    
    func viewModel() -> RecipeListViewModelProtocol {
        return RecipeListViewModel(repository: repository())
    }
    
    func repository() -> RecipeLibraryRepositoryProtocol {
        return RecipeLibraryRepository(webService: webServiceAssembly.webService)
    }
    
    func cellPresenter() -> RecipeCellPresenter {
        return RecipeCellPresenter(imageRepository: imageLoadingAssembly.imageRepository)
    }
}
