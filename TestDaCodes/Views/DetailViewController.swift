//
//  DetailViewController.swift
//  TestDaCodes
//
//  Created by Jaime Escobar on 09/11/20.
//

import UIKit
import AlamofireImage

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private let movieDetailsViewModel = MovieDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingValues()
    }
    
    func configure(with movieId: Int) {
        movieDetailsViewModel.loadMovie(id: movieId)
    }
    
    private func bindingValues() {
        movieDetailsViewModel.networkError.bind { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        movieDetailsViewModel.movieDetailsDidLoad.bind { [weak self] didLoad in
            guard let self = self else { return }
            guard didLoad else { return }
            self.setUpView()
        }
    }
    
    private func setUpView() {
        guard let movie = movieDetailsViewModel.movie else { return }
        if let posterPath = movie.posterPath {
            guard let url = URL(string: APIManager.imageUrlBase.appending(posterPath)) else { return }
            self.imageView.af.setImage(withURL: url)
        }
        titleLabel.text = movie.title
        if let duration = movie.runtime {
            durationLabel.text = "\(duration) min"
        } else {
            durationLabel.text = "-- min"
        }
        dateLabel.text = movie.releaseDate
        rateLabel.text = "\(movie.voteAverage)"
        genresLabel.text = getGenresAsString(genres: movie.genres)
        descriptionLabel.text = movie.overview
    }
    
    private func getGenresAsString(genres: [Genre]) -> String {
        let stringGenres = genres.map { genre -> String in
            return genre.name
        }
        return stringGenres.reduce("", { $0 == "" ? $1 : $0 + ", " + $1 })
    }
    
}
