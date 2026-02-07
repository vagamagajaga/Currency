//
//  CurrencyFieldModel.swift
//  Currency
//
//  Created by Ваган Галстян on 02.02.2026.
//

import SwiftUI

struct CurrencyModel {
    let name: String
    let rate: Double
    let image: ImageResource
    
    init() {
        self.name = "USDc"
        self.rate = 1
        self.image = .usa
    }
    
    init(name: String, rate: Double, image: ImageResource) {
        self.name = name
        self.rate = rate
        self.image = image
    }
}

extension CurrencyModel: Identifiable {
    var id: String {
        name
    }
    
    var stringRate: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        
        return numberFormatter.string(from: NSNumber(value: rate)) ?? ""
    }
}

struct CurrencyFieldModel {
    var currency: CurrencyModel
    var amount: Double?
    let isMain: Bool
    
    init(
        currency: CurrencyModel,
        amount: Double? = nil,
        isMain: Bool = false
    ) {
        self.currency = currency
        self.amount = amount
        self.isMain = isMain
    }
}

extension CurrencyFieldModel: Equatable {
    static func == (lhs: CurrencyFieldModel, rhs: CurrencyFieldModel) -> Bool {
        lhs.amount == rhs.amount && lhs.currency.name == rhs.currency.name
    }
}
