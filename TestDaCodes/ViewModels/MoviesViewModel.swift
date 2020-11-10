//
//  MoviesViewModel.swift
//  TestDaCodes
//
//  Created by Jaime Escobar on 09/11/20.
//

import Foundation

class MoviesViewModel {
    var movies: [Movie] = []
    
    // MARK:- Binding
    var moviesDidLoad: Box<Bool> = Box(false)
    var networkError: Box<NetworkError?> = Box(nil)

    // MARK:- Movies Networking
    private var moviesResponse: MovieResponse? {
        didSet {
            if let results = moviesResponse?.results {
                self.movies.append(contentsOf: results)
            }
        }
    }
    
    func loadMovies() {
        self.moviesDidLoad.value = false
        MovieServiceCaller.getPlayingNow { (result) in
            switch result {
            case .success(let response):
                self.moviesResponse = response
                self.moviesDidLoad.value = true
            case .failure(let error):
                self.networkError.value = error
            }
        }
    }

}
