//
//  DataCache.swift
//  RecipesCore
//
//  Created by Alexandre Freire on 12/01/2019.
//  Copyright © 2019 Alexandre Freire. All rights reserved.
//

import Foundation

public protocol DataCache: class {
    
    func data(for url: URL) -> CacheDataWithDate?
    
    func setData(_ data: Data, for url: URL)
}

public final class CacheDataWithDate {
    let date: NSDate
    let data: NSData
    
    init(data: NSData, date: NSDate) {
        (self.data, self.date) = (data, date)
    }
}

final class MemoryDataCache: DataCache {
    
    private let cache = NSCache<NSURL, CacheDataWithDate>()
    
    func data(for url: URL) -> CacheDataWithDate? {
        return cache.object(forKey: url as NSURL)
    }
    
    func setData(_ data: Data, for url: URL) {
        let dataWithDate = CacheDataWithDate(data: data as NSData, date: Date() as NSDate)
        cache.setObject(dataWithDate, forKey: url as NSURL)
    }
}
