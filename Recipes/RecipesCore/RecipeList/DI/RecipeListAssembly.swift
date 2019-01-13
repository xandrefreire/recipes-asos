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
    private let searchAssembly: SearchAssembly
    private let detailAssembly: RecipeDetailAssembly

    // MARK: Initialization
    init(webServiceAssembly: WebServiceAssembly, imageLoadingAssembly: ImageLoadingAssembly, searchAssembly: SearchAssembly, detailAssembly: RecipeDetailAssembly) {
        self.webServiceAssembly = webServiceAssembly
        self.imageLoadingAssembly = imageLoadingAssembly
        self.searchAssembly = searchAssembly
        self.detailAssembly = detailAssembly
    }
    
    public var viewController: UIViewController {
        return RecipeListViewController(viewModel: viewModel(), cellPresenter: cellPresenter(), searchNavigator: searchAssembly.searchNavigator())
    }
    
    func viewModel() -> RecipeListViewModelProtocol {
        return RecipeListViewModel(repository: repository(), detailNavigator: detailAssembly.detailNavigator())
    }
    
    func repository() -> RecipeLibraryRepositoryProtocol {
        return RecipeLibraryRepository(webService: webServiceAssembly.webService)
    }
    
    func cellPresenter() -> RecipeCellPresenter {
        return RecipeCellPresenter(imageRepository: imageLoadingAssembly.imageRepository)
    }
}

extension RecipeListAssembly: RecipeListViewControllerProvider {}
