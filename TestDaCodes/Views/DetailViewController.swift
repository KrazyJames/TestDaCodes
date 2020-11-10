//
//  DetailViewController.swift
//  TestDaCodes
//
//  Created by Jaime Escobar on 09/11/20.
//

import UIKit
import AlamofireImage

final class DetailViewController: UIViewController {
    
    // MARK: - IBOulets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Properties
    private let movieDetailsViewModel = MovieDetailsViewModel()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingValues()
    }
    
    // MARK: - Functions
    func configure(with movieId: Int) {
        movieDetailsViewModel.loadMovie(id: movieId)
    }
    
    private func presentAlert(with error: NetworkError) {
        let alert = UIAlertController(title: "Oops! something went wrong", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    private func setUpView() {
        guard let movie = movieDetailsViewModel.movieDetail else { return }
        if let posterPath = movie.posterPath {
            guard let url = URL(string: APIManager.imageUrlBase.appending(posterPath)) else { return }
            self.imageView.af.setImage(withURL: url)
        }
        titleLabel.text = movie.title
        durationLabel.text = "\(movie.runtime ?? 0) min"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateLabel.text = dateFormatter.string(from: movie.releaseDate ?? Date())
        rateLabel.text = "\(movie.voteAverage)"
        genresLabel.text = getGenresAsString(genres: movie.genres)
        descriptionLabel.text = movie.overview
    }
    
    private func getGenresAsString(genres: [Genre]) -> String {
        let stringGenres = genres.map { return $0.name }
        return stringGenres.reduce("", { $0 == "" ? $1 : $0 + ", " + $1 })
    }
   
    // MARK:- Binding
    private func bindingValues() {
        movieDetailsViewModel.requestStatus.bind { [weak self] status in
            guard let self = self else { return }
            switch status {
            case .loading:
                // I'd add activity indicator here
                break
            case .didLoad:
                self.setUpView()
            case .error(let error):
                self.presentAlert(with: error)
            }
        }
    }
    
}
