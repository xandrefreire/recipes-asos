//
//  RecipeCellPresenter.swift
//  RecipesCore
//
//  Created by Alexandre Freire on 12/01/2019.
//  Copyright © 2019 Alexandre Freire. All rights reserved.
//

import RxSwift
import RxCocoa

final class RecipeCellPresenter {
    
    // MARK: Properties
    private let imageRepository: ImageRepositoryProtocol
    
    // MARK: Initialization
    init(imageRepository: ImageRepositoryProtocol) {
        self.imageRepository = imageRepository
    }
    
    func present(_ recipe: Recipe, in cell: RecipeCell) {
        setupViews(of: cell)
        bindImage(at: recipe.imageURL, to: cell)
        cell.titleLabel.text = recipe.name.capitalized
        cell.ingredientsLabel.text = "\(recipe.ingredientsCount) ingredients"
        cell.timeLabel.text = recipe.timeRequired
        cell.complexityLabel.text = recipe.complexity.rawValue.uppercased()
        setLabelColor(cell.complexityLabel, forComplexity: recipe.complexity)

    }
}

private extension RecipeCellPresenter {
    func bindImage(at url: URL?, to cell: RecipeCell) {
        guard let url = url else {
            return
        }
        
        imageRepository.image(withURL: url)
            .observeOn(MainScheduler.instance)
            .bind(to: cell.imageView.rx.image)
            .disposed(by: cell.disposeBag)
    }
    
    func setupViews(of cell: RecipeCell) {
        cell.contentView.layer.cornerRadius = 5.0
        cell.contentView.layer.borderWidth = 0.5
        cell.contentView.layer.borderColor = UIColor.gray.cgColor
        cell.contentView.layer.masksToBounds = true
    }
    
    func setLabelColor(_ label: UILabel, forComplexity complexity: Recipe.Complexity) {
        switch complexity {
        case .easy:
            label.textColor = .greenRecipe
        case .medium:
            label.textColor = .orangeRecipe
        case .hard:
            label.textColor = .redRecipe
        }
    }
}
