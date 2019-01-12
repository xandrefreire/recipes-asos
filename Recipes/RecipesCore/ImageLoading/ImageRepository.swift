//
//  ImageRepository.swift
//  RecipesCore
//
//  Created by Alexandre Freire on 12/01/2019.
//  Copyright © 2019 Alexandre Freire. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

public protocol ImageRepositoryProtocol {
    func image(withURL url: URL) -> Observable<UIImage>
}

internal protocol ImageManager {
    func image(withURL url: URL) -> Observable<UIImage>
}

extension KingfisherManager: ImageManager {
    func image(withURL url: URL) -> Observable<UIImage> {
        return Observable.create{ observer in
            let task = self.downloader.downloadImage(with: url) { result in
                switch result {
                case .success(let value):
                    observer.onNext(value.image)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                task?.cancel()
            }
        }
    }
}

final class ImageRepository: ImageRepositoryProtocol {
    private let imageManager: ImageManager
    
    init(imageManager: ImageManager) {
        self.imageManager = imageManager
    }
    
    func image(withURL url: URL) -> Observable<UIImage> {
        return imageManager.image(withURL: url)
    }
}

