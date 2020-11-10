//
//  APIManager.swift
//  TestDaCodes
//
//  Created by Jaime Escobar on 09/11/20.
//

import Foundation

struct APIManager {
    static let urlBase = "https://api.themoviedb.org/3"
    static let imageUrlBase = "https://image.tmdb.org/t/p/w500"
    static let apiKey = "634b49e294bd1ff87914e7b9d014daed"
}

enum HTTPParameterField: String {
    case apiKey = "api_key"
    case language = "language"
}
