//
//  MovieCollectionViewCell.swift
//  TestDaCodes
//
//  Created by Jaime Escobar on 09/11/20.
//

import UIKit
import AlamofireImage

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    
    func configure(with movie: Movie) {
        if let posterPath = movie.posterPath {
            guard let url = URL(string: APIManager.imageUrlBase.appending(posterPath)) else { return }
            self.posterImageView.af.setImage(withURL: url)
        } else {
            // Set placeholder image
        }
        titleLabel.text = movie.title
        releaseDateLabel.text = movie.releaseDate
        ratingLabel.text = "\(movie.voteAverage)"
    }
}
