//
//  NetworkService.swift
//  Currency
//
//  Created by Ваган Галстян on 04.02.2026.
//

import Foundation

protocol INetwork {
    func makeRequest(with url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}

struct NetworkService: INetwork {
    func makeRequest(with url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                handler(.failure(NetworkError.noResponse))
                return
            }
            
            guard 200..<300 ~= httpResponse.statusCode else {
                handler(.failure(NetworkError.responseError(httpResponse.statusCode)))
                return
            }
            
            if let error = error {
                handler(.failure(error))
            }
            
            if let data = data {
                handler(.success(data))
            }
        }

        task.resume()
    }
}
