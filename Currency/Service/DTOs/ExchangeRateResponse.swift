//
//  ExchangeRateResponse.swift
//  Currency
//
//  Created by Ваган Галстян on 04.02.2026.
//

import Foundation

struct ExchangeRateResponse: Decodable {
    let ask: String // 18.4105000000
    let bid: String // 18.4069700000
    let book: String // usdc_mxn
    let date: String // 2025-10-20T20:14:57.361483956
}

