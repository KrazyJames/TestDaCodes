//
//  ResponseError.swift
//  TestDaCodes
//
//  Created by Jaime Escobar on 09/11/20.
//

import Foundation

struct ResponseError: Decodable {
    let message: String
    let exception: String?
    let file: String?
    let trace: [Trace]?
}

struct Trace: Decodable {
    let file: String
    let line: Int
    let function: String
    let `class`: String
    let type: String
}
