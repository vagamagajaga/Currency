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
    
    @Published var actualCurrency: CurrencyModel
    @Published var currencies: [CurrencyModel] = []
    
    private var isSwitched: Bool = false
    
    init() {
        let dollar = CurrencyModel(name: "USDc", course: 1, image: .usa)
        let euro = CurrencyModel(name: "EUR", course: 0.8, image: .eur)
        let arg = CurrencyModel(name: "ARS", course: 11.2, image: .arg)
        let bra = CurrencyModel(name: "BRL", course: 4.8, image: .bra)
        let col = CurrencyModel(name: "COP", course: 2.8, image: .col)
        let mex = CurrencyModel(name: "MXN", course: 21.8, image: .mex)
        
        self.mainModel = CurrencyFieldModel(currency: dollar, amount: nil, isMain: true)
        self.secondModel = CurrencyFieldModel(currency: euro, amount: nil)
        
        self.actualCurrency = euro
        
        self.currencies = [euro, arg, bra, col, mex]
    }
}

extension CurrencyViewModel {
    
    func updateModel(for isMainCurrency: Bool) {
        if isMainCurrency {
            if isSwitched {
                mainModel.amount = (secondModel.amount ?? 0) * mainModel.currency.course
            } else {
                secondModel.amount = (mainModel.amount ?? 0) * secondModel.currency.course
            }
        } else {
            if isSwitched {
                secondModel.amount = (mainModel.amount ?? 0) / mainModel.currency.course
            } else {
                mainModel.amount = (secondModel.amount ?? 0) / secondModel.currency.course
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
    func fetchData() async {
        
    }
}
