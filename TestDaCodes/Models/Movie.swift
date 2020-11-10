//
//  Movie.swift
//  TestDaCodes
//
//  Created by Jaime Escobar on 09/11/20.
//

import Foundation

struct Movie: Decodable {
    let id: Int
    let title: String
    let posterPath: String?
    let voteAverage: Double
    let releaseDate: Date
}

struct MovieDetails: Decodable {
    let id: Int
    let genres: [Genre]
    let overview: String?
    let posterPath: String?
    let releaseDate: Date?
    let runtime: Int?
    let voteAverage: Double
    let title: String
}

struct Genre: Decodable {
    let id: Int
    let name: String
}

struct MovieResponse: Decodable {
    let results: [Movie]
    let page: Int
    let totalResults: Int
    let totalPages: Int
}
