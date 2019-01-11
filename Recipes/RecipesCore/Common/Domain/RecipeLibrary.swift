//
//  RecipeLibrary.swift
//  RecipesCore
//
//  Created by Alexandre Freire on 11/01/2019.
//  Copyright © 2019 Alexandre Freire. All rights reserved.
//

import Foundation

typealias Filter = (String) -> Bool

struct RecipeLibrary {
    
    private let _recipes: [Recipe]

    init(recipes: [Recipe]) {
        _recipes = recipes
    }
    
    var count: Int {
        return _recipes.count
    }
    
    func recipe(at index: Int) -> Recipe? {
        return _recipes[index]
    }
    
    func recipes(filteredBy query: String) -> RecipeLibrary {
        let filtered = _recipes.filter {
            $0.contains(name: query) ||
            $0.contains(step: query) ||
            $0.contains(ingredient: query)
        }
        
        return RecipeLibrary(recipes: filtered)
    }
}
