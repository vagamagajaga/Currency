//
//  MockService.swift
//  Currency
//
//  Created by Ваган Галстян on 07.02.2026.
//

import Foundation

struct MockService {
    static let mockCurrencyList: Data = """
    [
      "MXN",
      "ARS",
      "BRL",
      "COP"
    ]
    """.data(using: .utf8)!
}
