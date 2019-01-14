//
//  DataCache.swift
//  RecipesCore
//
//  Created by Alexandre Freire on 12/01/2019.
//  Copyright © 2019 Alexandre Freire. All rights reserved.
//

import Foundation

public protocol DataCaching: class {
    
    func data(for urlRequest: URLRequest) -> Data?
    
    func store(response: URLResponse, data: Data, for request: URLRequest)
}

final class DataCacher: DataCaching {
    
    private var cache: URLCache {
        let cache = URLCache(memoryCapacity: 0, diskCapacity: 500 * 1024 * 1024, diskPath: "recipes/cache")
        URLCache.shared = cache
        return cache
    }
    
    private var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        return formatter
    }
    
    func data(for request: URLRequest) -> Data? {
        guard let cachedResponse = cache.cachedResponse(for: request) else {
            return nil
        }
            
        guard let httpResponse = cachedResponse.response as? HTTPURLResponse else {
            fatalError("Unsupported protocol")
        }
        
        if let dateString = httpResponse.allHeaderFields["Date"] as? String,
            let date = formatter.date(from: dateString) {
            
            let now = Date()
            
            if now.minutes(from: date) < 60 {
                return cachedResponse.data
            }
        }
        
        return nil
    }
    
    func store(response: URLResponse, data: Data, for request: URLRequest) {
        cache.removeAllCachedResponses()
        let cached = CachedURLResponse(response: response, data: data)
        cache.storeCachedResponse(cached, for: request)
    }
}


