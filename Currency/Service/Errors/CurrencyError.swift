//
//  CurrencyError.swift
//  Currency
//
//  Created by Ваган Галстян on 07.02.2026.
//

import Foundation

enum CurrencyError: LocalizedError {
    case invalidData
    case noCurrency
    case parsingError
    
    var localizedDescription: String? {
        switch self {
        case .invalidData:
            return "Invalid data"
            
        case .noCurrency:
            return "Do not get currencies"
            
        case .parsingError:
            return "Parsing error"
        }
    }
}
