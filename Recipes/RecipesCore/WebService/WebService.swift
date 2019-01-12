//
//  WebService.swift
//  RecipesCore
//
//  Created by Alexandre Freire on 11/01/2019.
//  Copyright © 2019 Alexandre Freire. All rights reserved.
//

import Foundation
import RxSwift

public enum WebServiceError: Error {
    case badStatus(Int, Data)
}

final class WebService {
    private let session = URLSession(configuration: .default)
    private let baseURL = URL(string: "https://mobile.asosservices.com/sampleapifortest")!
    private let decoder = JSONDecoder()
    
    func load<T: Decodable>(_ type: T.Type, from endpoint: Endpoint, then completion: @escaping (T) -> Void, catchError: @escaping (Error) -> Void) {
        let decoder = self.decoder
        let request = endpoint.request(with: baseURL)

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                catchError(error)
                return
            } else {
                guard let httpResponse = response as? HTTPURLResponse else {
                    fatalError("Unsupported protocol")
                }
                
                if 200 ..< 300 ~= httpResponse.statusCode {
                    if let data = data,
                     let object = try? decoder.decode(T.self, from: data) {
                        completion(object)
                        return
                    }
                } else {
                    catchError(WebServiceError.badStatus(httpResponse.statusCode, data ?? Data()))
                }
            }
        }
        task.resume()
    }
    
    func load<T>(_ type: T.Type, from endpoint: Endpoint) -> Observable<T> where T: Decodable {
        let decoder = self.decoder
        let request = endpoint.request(with: baseURL)
        
        return session.rx.data(request: request)
            .map { try decoder.decode(T.self, from: $0) }
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
    func data(request: URLRequest) -> Observable<Data> {
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
                            observer.onNext(data)
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
