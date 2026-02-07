//
//  CurrencyViewModel.swift
//  Currency
//
//  Created by Ваган Галстян on 02.02.2026.
//

import SwiftUI
import Combine

final class CurrencyViewModel: ObservableObject {
    
    @Published var mainModel: CurrencyFieldModel
    @Published var secondModel: CurrencyFieldModel
    
    @Published var actualCurrency: CurrencyModel?
    @Published var currencies: [CurrencyModel] = []
    
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    private let service: ICurrencyService = CurrencyService(networkService: NetworkService())
    
    init() {
        self.mainModel = CurrencyFieldModel(currency: .init(), isMain: true)
        self.secondModel = CurrencyFieldModel(currency: .init())
    }
}

extension CurrencyViewModel {
    
    func updateModel(for isMainCurrency: Bool) {
        guard let rate = actualCurrency?.rate else { return }
        
        if isMainCurrency {
            secondModel.amount = (mainModel.amount ?? 0) * rate
        } else {
            mainModel.amount = (secondModel.amount ?? 0) / rate
        }
        
        if mainModel.amount == nil || secondModel.amount == nil {
            mainModel.amount = nil
            secondModel.amount = nil
        }
    }
    
    func changeCurrency(to model: CurrencyModel) {
        actualCurrency = model
        if mainModel.isMain {
            secondModel.currency = model
        } else {
            mainModel.currency = model
        }
        mainModel.amount = nil
        secondModel.amount = nil
    }
}

extension CurrencyViewModel {
    func fetchCurrencies() {
        isLoading = true
        
        service.fetchRates { [weak self] result in
            guard let self else { return }
            
            switch result {
            case let .success(models):
                DispatchQueue.main.async { [weak self] in
                    guard let model = models.first else { return }
                    
                    self?.currencies = models
                    self?.actualCurrency = model
                    self?.secondModel = CurrencyFieldModel(currency: model)
                    self?.isLoading = false
                }
                
            case let .failure(someError):
                DispatchQueue.main.async { [weak self] in
                    self?.isLoading = false
                    self?.error = someError
                }
            }
        }
    }
}
