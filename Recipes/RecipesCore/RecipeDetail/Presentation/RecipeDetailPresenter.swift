//
//  RecipeDetailPresenter.swift
//  RecipesCore
//
//  Created by Alexandre Freire on 13/01/2019.
//  Copyright © 2019 Alexandre Freire. All rights reserved.
//

import Foundation

protocol RecipeDetailView: class {
    var title: String? { get set }
    func setIngredientsHeaderTitle(_ title: String)
    func setInstructionsHeaderTitle(_ title: String)
    func setRecipeTitle(_ title: String)
    func setRecipeImage(at url: URL?)
    func update(with ingredients: [Ingredient])
    func update(with steps: [Step])
}

final class RecipeDetailPresenter {
    weak var view: RecipeDetailView?
    private let recipe: Recipe
    private let detailNavigator: DetailNavigator

    init(recipe: Recipe, detailNavigator: DetailNavigator) {
        self.detailNavigator = detailNavigator
        self.recipe = recipe
    }
    
    func didLoad() {
        view?.title = NSLocalizedString("Recipe", comment: "")
        view?.setRecipeTitle(recipe.name)
        view?.setIngredientsHeaderTitle("Ingredients".uppercased())
        view?.setInstructionsHeaderTitle("Instructions".uppercased())
        view?.setRecipeImage(at: recipe.imageURL)
        view?.update(with: recipe.ingredients)
        view?.update(with: recipe.steps)
    }
}
