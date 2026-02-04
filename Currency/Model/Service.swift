//
//  Service.swift
//  Currency
//
//  Created by Ваган Галстян on 03.02.2026.
//

import Foundation

class Service {
    var doubleFormat: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.decimalSeparator = "."
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
        return formatter
    }
}
