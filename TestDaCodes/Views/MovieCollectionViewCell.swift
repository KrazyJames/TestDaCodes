//
//  MovieCollectionViewCell.swift
//  TestDaCodes
//
//  Created by Jaime Escobar on 09/11/20.
//

import UIKit
import AlamofireImage

final class MovieCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOulets
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    // MARK: - Functions
    func configure(with movie: Movie) {
        if let posterPath = movie.posterPath {
            guard let url = URL(string: APIManager.imageUrlBase.appending(posterPath)) else { return }
            self.posterImageView.af.setImage(withURL: url)
        }
        titleLabel.text = movie.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        releaseDateLabel.text = dateFormatter.string(from: movie.releaseDate)
        ratingLabel.text = "\(movie.voteAverage)"
    }
}
