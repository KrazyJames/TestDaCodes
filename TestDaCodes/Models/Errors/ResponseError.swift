//
//  ResponseError.swift
//  TestDaCodes
//
//  Created by Jaime Escobar on 09/11/20.
//

import Foundation

struct ResponseError: Decodable {
    let statusCode: Int
    let statusMessage: String
}
