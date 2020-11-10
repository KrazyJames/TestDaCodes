//
//  MovieServiceCaller.swift
//  TestDaCodes
//
//  Created by Jaime Escobar on 09/11/20.
//

import Foundation

final class MovieServiceCaller {
    private let serviceRequester = ServiceRequester()
    
    func getPlayingNow(page: Int, completion: @escaping (Result<MovieResponse, NetworkError>) -> Void) {
        let router = MovieRouter.getPlayingNow(page: page)
        serviceRequester.request(router: router) { (result) in
            completion(result)
        }
    }
    
    func getMovieDetails(id: Int, completion: @escaping (Result<MovieDetails, NetworkError>) -> Void) {
        let router = MovieRouter.getMovieDetails(id: id)
        serviceRequester.request(router: router) { (result) in
            completion(result)
        }
    }
}
