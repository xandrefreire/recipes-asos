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
        guard index < _recipes.count else {
            return nil
        }
        return _recipes[index]
    }
    
    func recipes(filteredBy query: String, complexity: Recipe.Complexity? = nil) -> RecipeLibrary {
        let filtered = _recipes.filter {
            $0.contains(name: query) ||
            $0.contains(step: query) ||
            $0.contains(ingredient: query)
        }
        
        guard let complexity = complexity else {
            return RecipeLibrary(recipes: filtered)
        }
        
        return RecipeLibrary(recipes: filtered).recipes(withComplexity: complexity)
        
    }
    
    func recipes(withComplexity complexity: Recipe.Complexity?) -> RecipeLibrary {
        guard let complexity = complexity else {
            return RecipeLibrary(recipes: _recipes)
        }
        
        let filtered = _recipes.filter { $0.complexity == complexity }
        
        return RecipeLibrary(recipes: filtered)
        
    }
}
