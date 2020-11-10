//
//  NetworkErrors.swift
//  TestDaCodes
//
//  Created by Jaime Escobar on 09/11/20.
//

import Foundation

enum NetworkError: Error {
    case serverError(error: ResponseError)
    case invalidJSON(Error)
    case invalidStatusCode(Int)
    case noData
    case falseResponse(message: String)
    case unknown(Error)
    case invalidParameters
    
    var localizedDescription: String {
        switch self {
        case .serverError(let error):
            return "Server Error: \n\(error.statusMessage)"
        case .invalidJSON(let error):
            return "Server Error: \n\(error.localizedDescription)"
        case .invalidStatusCode(let code):
            return "Status Error: \(code)"
        case .noData:
            return "Data not found"
        case .falseResponse(let message):
            return message
        case .unknown(let error):
            return error.localizedDescription
        case .invalidParameters:
            return "Invalid parameters"
        }
    }
}
