//
//  CurrencyFieldModel.swift
//  Currency
//
//  Created by Ваган Галстян on 02.02.2026.
//

import SwiftUI

struct CurrencyModel {
    let name: String
    let course: Double
    let image: ImageResource
}

extension CurrencyModel: Identifiable {
    var id: String {
        name
    }
    
    var formattedCourse: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        
        return numberFormatter.string(from: NSNumber(value: course)) ?? ""
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

//extension CurrencyFieldModel {
//    var stringAmount: String {
//        let numberFormatter = NumberFormatter()
//        numberFormatter.decimalSeparator = ","
//        
//        return numberFormatter.string(from: NSNumber(value: amount)) ?? ""
//    }
//}
