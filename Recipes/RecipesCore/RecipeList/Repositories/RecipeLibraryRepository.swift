//
//  RecipeLibraryRepository.swift
//  RecipesCore
//
//  Created by Alexandre Freire on 12/01/2019.
//  Copyright © 2019 Alexandre Freire. All rights reserved.
//

import RxSwift

protocol RecipeLibraryRepositoryProtocol {
    func library() -> Observable<RecipeLibrary>
}

final class RecipeLibraryRepository: RecipeLibraryRepositoryProtocol {
    
    // MARK: Properties
    private let webService: WebService
    
    // MARK: Initialization
    init(webService: WebService) {
        self.webService = webService
    }
    
    // MARK: RecipeLibraryRepositoryProtocol
    func library() -> Observable<RecipeLibrary> {
        return webService.load([Recipe].self, from: .allRecipes)
            .map(RecipeLibrary.init)
    }
    
}
