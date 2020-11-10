//
//  MovieDetailsViewModel.swift
//  TestDaCodes
//
//  Created by Jaime Escobar on 09/11/20.
//

import Foundation

final class MovieDetailsViewModel {
    private let movieServiceCaller = MovieServiceCaller()
    var movieDetail: MovieDetail?
    
    // MARK:- Binding
    enum RequestStatus {
        case loading
        case didLoad
        case error(_ error: NetworkError)
    }
    
    var requestStatus: Box<RequestStatus> = Box(.loading)
    
    // MARK:- MovieDetails Networking
    private var movieDetailResponse: MovieDetail? {
        didSet {
            if let details = movieDetailResponse.self {
                self.movieDetail = details
            }
        }
    }
    
    func loadMovie(id: Int) {
        requestStatus.value = .loading
        movieServiceCaller.getMovieDetails(id: id) { result in
            switch result {
            case .success(let details):
                self.movieDetailResponse = details
                self.requestStatus.value = .didLoad
            case .failure(let error):
                self.requestStatus.value = .error(error)
            }
        }
    }
}
