//
//  RecipeDetailViewController.swift
//  RecipesCore
//
//  Created by Alexandre Freire on 13/01/2019.
//  Copyright © 2019 Alexandre Freire. All rights reserved.
//

import UIKit

protocol RecipeDetailViewControllerProvider: class {
    func viewController(recipe: Recipe) -> RecipeDetailViewController
}

class RecipeDetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var ingredientsStackView: UIStackView!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var instructionsStackView: UIStackView!
    
    // MARK: Properties
    private let presenter: RecipeDetailPresenter
    private let imagePresenter: RecipeImagePresenter
    
    // MARK: Initialization
    init(presenter: RecipeDetailPresenter, imagePresenter: RecipeImagePresenter) {
        self.presenter = presenter
        self.imagePresenter = imagePresenter
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        presenter.didLoad()
    }
}

extension RecipeDetailViewController: RecipeDetailView {
    func setIngredientsHeaderTitle(_ title: String) {
        ingredientsLabel.text = title
    }
    
    func setInstructionsHeaderTitle(_ title: String) {
        instructionsLabel.text = title

    }
    
    func setRecipeTitle(_ title: String) {
        titleLabel.text = title

    }
    
    func setRecipeImage(at url: URL?) {
        imagePresenter.presentImage(at: url, in: imageView)
    }
    
    func update(with ingredients: [Ingredient]) {
        ingredientsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let ingredientsViews: [UIView] = ingredients.map {
            let ingredientView = RowView.instantiate()
            ingredientView.leftLabel.text = $0.name.capitalized
            ingredientView.rightLabel.text = "(\($0.quantity))"
            
            return ingredientView
        }
        
        ingredientsViews.forEach { ingredientsStackView.addArrangedSubview($0) }

    }
    
    func update(with steps: [Step]) {
        let stepsViews: [UIView] = steps.enumerated().map {
            let stepView = RowView.instantiate()
            stepView.leftLabel.text = "\($0+1))  \($1.description)"
            stepView.rightLabel.text = ""

            return stepView
        }
        
        stepsViews.forEach { instructionsStackView.addArrangedSubview($0) }

    }
}
