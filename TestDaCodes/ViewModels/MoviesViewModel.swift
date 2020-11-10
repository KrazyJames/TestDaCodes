//
//  MoviesViewModel.swift
//  TestDaCodes
//
//  Created by Jaime Escobar on 09/11/20.
//

import Foundation

final class MoviesViewModel {
    private let movieServiceCaller = MovieServiceCaller()
    private var movies: [Movie] = []
    
    var totalMovies: Int {
        return movies.count
    }
    
    var hasNextPage: Bool {
        guard let response = moviesResponse else { return false }
        return response.totalPages - response.page > 0
    }
    
    var nextPage: Int? {
        if hasNextPage {
            guard let currentPage = self.moviesResponse?.page else { return nil }
            return currentPage + 1
        } else {
            return nil
        }
    }
    
    // MARK:- Binding
    enum RequestStatus {
        case loading
        case didLoad
        case error(_ error: NetworkError)
    }
    
    private var isLoading = false
    var requestStatus: Box<RequestStatus> = Box(.loading)

    // MARK:- Movies Networking
    private var moviesResponse: MovieResponse? {
        didSet {
            if let results = moviesResponse?.results {
                self.movies.append(contentsOf: results)
            }
        }
    }
    
    func loadMovies(page: Int = 1) {
        requestStatus.value = .loading
        isLoading = true
        movieServiceCaller.getPlayingNow(page: page) { result in
            self.isLoading = false
            switch result {
            case .success(let response):
                self.moviesResponse = response
                self.requestStatus.value = .didLoad
            case .failure(let error):
                self.requestStatus.value = .error(error)
            }
        }
    }
    
    func reloadMovies() {
        guard !isLoading else { return }
        movies.removeAll()
        moviesResponse = nil
        loadMovies()
    }
    
    func loadMoreMovies(_ currentRow: Int) {
        guard currentRow >= (movies.count - 5) else { return }
        guard !isLoading else { return }
        guard let nextPage = nextPage else { return }
        loadMovies(page: nextPage)
    }
    
    func getMovie(at index: Int) -> Movie? {
        return movies[safe: index]
    }
}
