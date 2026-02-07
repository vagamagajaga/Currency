//
//  Double+Extension.swift
//  Currency
//
//  Created by Ваган Галстян on 07.02.2026.
//

import Foundation

extension Double {
    func moneyFormat() -> Double {
        let factor = pow(10, Double(2))
        return (self * factor).rounded() / factor
    }
}

extension String {
    func toDouble() -> Double? {
        Double(self)
    }
}
