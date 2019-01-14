//
//  RecipeDetailImagePresenter.swift
//  RecipesCore
//
//  Created by Alexandre Freire on 13/01/2019.
//  Copyright © 2019 Alexandre Freire. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class RecipeImagePresenter {
    
    private let imageRepository: ImageRepositoryProtocol
    
    let disposeBag = DisposeBag()
    
    init(imageRepository: ImageRepositoryProtocol) {
        self.imageRepository = imageRepository
    }
    
    func presentImage(at url: URL?, in imageView: UIImageView) {
        guard let url = url else {
            imageView.image = UIImage(named: "no_image.jpg")
            return
        }
        
        imageRepository.image(withURL: url)
            .observeOn(MainScheduler.instance)
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
    }
}
