//
//  ImageLoadingAssembly.swift
//  RecipesCore
//
//  Created by Alexandre Freire on 12/01/2019.
//  Copyright © 2019 Alexandre Freire. All rights reserved.
//

import Foundation
import Kingfisher

final class ImageLoadingAssembly {
    private(set) lazy var imageRepository: ImageRepositoryProtocol = ImageRepository(imageManager: KingfisherManager.shared)
}
