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
        let cache = self.cache
        return Observable.create{ observer in
            
            cache.retrieveImageInDiskCache(forKey: url.absoluteString) { result in
                switch result {
                case .success(let image):
                    if let image = image {
                        observer.onNext(image)
                        observer.onCompleted()
                    }
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            let task = self.downloader.downloadImage(with: url) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let value):
                    self.cache.storeToDisk(value.image.pngData() ?? Data(), forKey: url.absoluteString)
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

