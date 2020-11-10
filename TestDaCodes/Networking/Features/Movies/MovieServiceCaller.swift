//
//  MovieServiceCaller.swift
//  TestDaCodes
//
//  Created by Jaime Escobar on 09/11/20.
//

import Foundation

class MovieServiceCaller {
    static func getPlayingNow(page: Int, completion: @escaping (Result<MovieResponse, NetworkError>) -> Void) {
        let router = MovieRouter.getPlayingNow(page: page)
        ServiceRequester.request(router: router) { (result) in
            completion(result)
        }
    }
    
    static func getMovieDetails(id: Int, completion: @escaping (Result<MovieDetails, NetworkError>) -> Void) {
        let router = MovieRouter.getMovieDetails(id: id)
        ServiceRequester.request(router: router) { (result) in
            completion(result)
        }
    }
}
