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

    private var isSwitched: Bool = false
    
    init() {
        let dollar = CurrencyModel(name: "USDc", rate: 1, image: .usa)
        
        self.mainModel = CurrencyFieldModel(currency: dollar, amount: nil, isMain: true)
        self.secondModel = CurrencyFieldModel(currency: dollar, amount: nil, isMain: true)
    }
}

extension CurrencyViewModel {
    
    func updateModel(for isMainCurrency: Bool) {
        if isMainCurrency {
            if isSwitched {
                mainModel.amount = (secondModel.amount ?? 0) * mainModel.currency.rate
            } else {
                secondModel.amount = (mainModel.amount ?? 0) * secondModel.currency.rate
            }
        } else {
            if isSwitched {
                secondModel.amount = (mainModel.amount ?? 0) / mainModel.currency.rate
            } else {
                mainModel.amount = (secondModel.amount ?? 0) / secondModel.currency.rate
            }
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
    
    func switchModels() {
        isSwitched.toggle()
        let temp = mainModel
        mainModel = secondModel
        secondModel = temp
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

// TODELETE: Mock


//let euro = CurrencyModel(name: "EUR", rate: 0.8, image: .eur)
//let arg = CurrencyModel(name: "ARS", rate: 11.2, image: .arg)
//let bra = CurrencyModel(name: "BRL", rate: 4.8, image: .bra)
//let col = CurrencyModel(name: "COP", rate: 2.8, image: .col)
//let mex = CurrencyModel(name: "MXN", rate: 21.8, image: .mex)
