//
//  Endpoint.swift
//  RecipesCore
//
//  Created by Alexandre Freire on 11/01/2019.
//  Copyright © 2019 Alexandre Freire. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

enum Endpoint {
    case allRecipes
}

extension Endpoint {
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        switch self {
        case .allRecipes:
            return "recipes.json"
        }
        
    }
    
    var parameters: [String : String] {
        switch self {
        case .allRecipes:
            return [:]
        }
    }
}
internal extension Endpoint {
    func request(with baseURL: URL) -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = parameters.map(URLQueryItem.init)
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = method.rawValue
        
        request.cachePolicy = .useProtocolCachePolicy
        
        return request
    }
}
