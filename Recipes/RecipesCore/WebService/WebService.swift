//
//  WebService.swift
//  RecipesCore
//
//  Created by Alexandre Freire on 11/01/2019.
//  Copyright © 2019 Alexandre Freire. All rights reserved.
//

import Foundation
import RxSwift

let hour: TimeInterval = (1 * 60 * 60)

public enum WebServiceError: Error {
    case badStatus(Int, Data)
}

final class WebService {
    private var session = URLSession(configuration: .default)
    private let baseURL = URL(string: "https://mobile.asosservices.com/sampleapifortest")!
    private let decoder = JSONDecoder()
    
    private var cache: DataCaching = DataCacher()
    
    func load<T: Decodable>(_ type: T.Type, from endpoint: Endpoint, then completion: @escaping (T) -> Void, catchError: @escaping (Error) -> Void) {
        let decoder = self.decoder
        let request = endpoint.request(with: baseURL)
        let cache = self.cache
        
        if let data = cache.data(for: request), let object = try? decoder.decode(T.self, from: data) {
            completion(object)
            return
        }
        else {
            let task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    catchError(error)
                    return
                } else {
                    guard let httpResponse = response as? HTTPURLResponse else {
                        fatalError("Unsupported protocol")
                    }
                    
                    if 200 ..< 300 ~= httpResponse.statusCode {
                        if let data = data {
                            cache.store(response: httpResponse, data: data, for: request)
                            
                            if let object = try? decoder.decode(T.self, from: data) {
                                completion(object)
                                return
                            }
                        }
                        
                    } else {
                        catchError(WebServiceError.badStatus(httpResponse.statusCode, data ?? Data()))
                    }
                }
            }
            task.resume()
        }
    }
    
    func load<T>(_ type: T.Type, from endpoint: Endpoint) -> Observable<T> where T: Decodable {
        let decoder = self.decoder
        let request = endpoint.request(with: baseURL)
        let cache = self.cache

        if let data = cache.data(for: request), let object = try? decoder.decode(T.self, from: data) {
            return Observable.just(object)
        }
        
        return session.rx.data(request: request)
            .do(onNext: {
                cache.store(response: $0, data: $1, for: request)
            })
            .map { try decoder.decode(T.self, from: $1) }
            .catchError { error in
                guard let webServiceError = error as? WebServiceError else {
                    throw error
                }
                
                guard case let .badStatus(code, data) = webServiceError else {
                    throw error
                }
                
                throw WebServiceError.badStatus(code, data)
        }
        
    }
}

private extension Reactive where Base: URLSession {
    func data(request: URLRequest) -> Observable<(URLResponse, Data)> {
        return Observable.create { observer in
            let task = self.base.dataTask(with: request) { data, response, error in
                if let error = error {
                    observer.onError(error)
                } else {
                    guard let httpResponse = response as? HTTPURLResponse else {
                        fatalError("Unsupported protocol")
                    }
                    
                    if 200 ..< 300 ~= httpResponse.statusCode {
                        if let data = data {
                            observer.onNext((httpResponse, data))
                        }
                        observer.onCompleted()
                    } else {
                        observer.onError(WebServiceError.badStatus(httpResponse.statusCode, data ?? Data()))
                    }
                }
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}

