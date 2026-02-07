//
//  NetworkError.swift
//  Currency
//
//  Created by Ваган Галстян on 07.02.2026.
//

import Foundation

enum NetworkError: LocalizedError {
    case responseError(Int)
    case noResponse
    
    var errorDescription: String? {
        switch self {
        case let .responseError(code):
            return "code \(code)"
            
        case .noResponse:
            return "No response"
        }
    }
}
