//
//  DataCache.swift
//  RecipesCore
//
//  Created by Alexandre Freire on 12/01/2019.
//  Copyright © 2019 Alexandre Freire. All rights reserved.
//

import Foundation

public protocol DataCacheProtocol: class {
    
    func data(for urlRequest: URLRequest) -> Data?
    
    func setData(_ data: Data, for urlRequest: URLRequest)
}




