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
    private let imageRepository: ImageRepository
    
    // MARK: Initialization
    init(imageRepository: ImageRepository) {
        self.imageRepository = imageRepository
    }
    
    func present(_ recipe: Recipe, in cell: RecipeCell) {
        
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
}
