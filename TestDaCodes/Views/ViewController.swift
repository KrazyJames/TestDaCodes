//
//  ViewController.swift
//  TestDaCodes
//
//  Created by Jaime Escobar on 09/11/20.
//

import UIKit

private let reusableCellID = "MovieCollectionViewCell"

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    private let moviesViewModel = MoviesViewModel()
    private var selectedMovie: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setUp() {
        moviesViewModel.loadMovies()
        bindValues()
    }
    
    private func bindValues() {
        moviesViewModel.networkError.bind { [weak self] error in
            guard self != nil else { return }
            if let error = error {
                print(error.localizedDescription)
            }
        }
        moviesViewModel.moviesDidLoad.bind { [weak self] didLoad in
            guard let self = self else { return }
            guard didLoad else { return }
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailViewController {
            if let item = selectedMovie {
                destination.configure(with: item)
            }
        }
    }

}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesViewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableCellID, for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: moviesViewModel.movies[indexPath.row])
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMovie = moviesViewModel.movies[indexPath.row].id
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2-20, height: 270.0)
    }
}
