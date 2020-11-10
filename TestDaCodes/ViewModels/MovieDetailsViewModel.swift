//
//  MovieDetailsViewModel.swift
//  TestDaCodes
//
//  Created by Jaime Escobar on 09/11/20.
//

import Foundation

class MovieDetailsViewModel {
    
    var movie: MovieDetails?
    
    // MARK:- Binding
    var networkError: Box<NetworkError?> = Box(nil)
    var movieDetailsDidLoad: Box<Bool> = Box(false)
    
    // MARK:- MovieDetails Networking
    private var movieDetailResponse: MovieDetails? {
        didSet {
            if let details = movieDetailResponse.self {
                self.movie = details
            }
        }
    }
    
    func loadMovie(id: Int) {
        self.movieDetailsDidLoad.value = false
        MovieServiceCaller.getMovieDetails(id: id) { (result) in
            switch result {
            case .success(let details):
                self.movieDetailResponse = details
                self.movieDetailsDidLoad.value = true
            case .failure(let error):
                self.networkError.value = error
            }
        }
    }
}
