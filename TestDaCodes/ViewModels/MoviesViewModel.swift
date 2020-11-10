//
//  MoviesViewModel.swift
//  TestDaCodes
//
//  Created by Jaime Escobar on 09/11/20.
//

import Foundation

class MoviesViewModel {
    var movies: [Movie] = []
    
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
    var moviesDidLoad: Box<Bool> = Box(false)
    var networkError: Box<NetworkError?> = Box(nil)
    var isLoadingMovies: Bool = false

    // MARK:- Movies Networking
    private var moviesResponse: MovieResponse? {
        didSet {
            if let results = moviesResponse?.results {
                self.movies.append(contentsOf: results)
            }
        }
    }
    
    func loadMovies(page: Int = 1) {
        self.moviesDidLoad.value = false
        MovieServiceCaller.getPlayingNow(page: page) { (result) in
            switch result {
            case .success(let response):
                self.moviesResponse = response
                self.moviesDidLoad.value = true
            case .failure(let error):
                self.networkError.value = error
            }
        }
    }
    
    func reloadMovies() {
        movies.removeAll()
        moviesResponse = nil
        moviesDidLoad.value = false
        loadMovies()
    }
    
    func loadMoreMovies(_ currentRow: Int) {
        guard currentRow >= (movies.count - 5) else { return }
        guard !isLoadingMovies else { return }
        guard let nextPage = nextPage else { return }
        loadMovies(page: nextPage)
    }

}
