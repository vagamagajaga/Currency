//
//  CurrencyService.swift
//  Currency
//
//  Created by Ваган Галстян on 04.02.2026.
//

import SwiftUI

typealias RawComponents = (String, [String])

protocol ICurrencyService {
    func fetchRates(completion: @escaping (Result<[CurrencyModel], Error>) -> Void)
}

final class CurrencyService {
    
    private let networkService: INetwork
    
    private let host = "https://api.dolarapp.dev/v1"
    
    init(networkService: INetwork) {
        self.networkService = networkService
    }
}

extension CurrencyService: ICurrencyService {
    func fetchRates(completion: @escaping (Result<[CurrencyModel], Error>) -> Void) {
        getCurrencyModels { result in
            switch result {
            case let .success(currencyModels):
                completion(.success(currencyModels))
                
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

private extension CurrencyService {
    func getCurrencyList(completion: @escaping (Result<[String], Error>) -> Void) {
        guard let url = provideURL(api: .currencies) else {
            return
        }
        
        networkService.makeRequest(with: url) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case let .success(data):
                guard let currencyList = decodeData([String].self, from: data) else {
                    
                    completion(.failure(CurrencyError.invalidData))
                    return
                }
                
                completion(.success(currencyList))
                
            case let .failure(error):
                // Set mock data
//                completion(.failure(error))
                
                guard let currencyList = decodeData([String].self, from: MockService.mockCurrencyList) else {
                    
                    completion(.failure(CurrencyError.invalidData))
                    return
                }
                
                completion(.success(currencyList))
            }
        }
    }
    
    func getCurrencyModels(
        completion: @escaping (Result<[CurrencyModel], Error>) -> Void
    ) {
        getCurrencyList { [weak self] result in
            guard let self else { return }
            
            switch result {
            case let .success(list):
                guard let components = provideComponents(for: [("currencies", list)]),
                    let url = provideURL(api: .rates, queryItems: components)
                else {
                    completion(.failure(CurrencyError.noCurrency))
                    return
                }
                
                networkService.makeRequest(with: url) { [weak self] result in
                    guard let self else { return }

                    switch result {
                    case let .success(data):
                        guard let rates = decodeData([ExchangeRateResponse].self, from: data)
                        else {
                            completion(.failure(CurrencyError.parsingError))
                            return
                        }
                        
                        completion(.success(provideCurrencyModel(from: rates)))
                        
                    case let .failure(error):
                        completion(.failure(error))
                    }
                }
                
            case let .failure(error):
                completion(.failure(error))
                
            }
        }
    }
}

private extension CurrencyService {
    func decodeData<T: Decodable>(
        _ type: T.Type,
        from data: Data
    ) -> T? {
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            return nil
        }
    }
    
    private func provideURL(
        api: ExchangeApi,
        queryItems: [URLQueryItem]? = nil
    ) -> URL? {
        var components = URLComponents(string: "\(host)/\(api.rawValue)")
        components?.queryItems = queryItems?.isEmpty == true ? nil : queryItems

        guard let url = components?.url else {
            debugPrint("Invalid URL")
            return nil
        }

        return url
    }
    
    func provideComponents(for currencies: [RawComponents]) -> [URLQueryItem]? {
        guard !currencies.isEmpty else { return nil }
        
        return currencies.map { key, values  in
            URLQueryItem(name: key, value: values.joined(separator: ","))
        }
    }
    
    func provideCurrencyModel(from data: [ExchangeRateResponse]) -> [CurrencyModel] {
        data.compactMap {
            let name = $0.book.replacingOccurrences(of: "usdc_", with: "").uppercased()
            
            guard let image = provideImageResourse(from: name),
                  let rate = Double($0.bid)?.moneyFormat()
            else {
                return nil
            }
            
            return CurrencyModel(
                name: name,
                rate: rate,
                image: image
            )
        }
    }
    
    func provideImageResourse(from name: String) -> ImageResource? {
        switch name {
        case "ARS": ImageResource(name: "arg", bundle: .main)
        case "BRL": ImageResource(name: "bra", bundle: .main)
        case "COP": ImageResource(name: "col", bundle: .main)
        case "EURc": ImageResource(name: "eur", bundle: .main)
        case "MXN": ImageResource(name: "mex", bundle: .main)
        default: nil
        }
    }
}
