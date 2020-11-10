//
//  ViewController.swift
//  TestDaCodes
//
//  Created by Jaime Escobar on 09/11/20.
//

import UIKit

private let reusableCellID = "MovieCollectionViewCell"
private let segueID = "showDetailsSegue"

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    private let moviesViewModel = MoviesViewModel()
    private var selectedMovie: Int?
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        collectionView.delegate = self
        collectionView.dataSource = self
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    // MARK:- Functions
    @objc func refresh() {
        if !moviesViewModel.isLoadingMovies {
            moviesViewModel.reloadMovies()
        }
    }
    
    func setUp() {
        moviesViewModel.loadMovies()
        bindValues()
    }
    
    private func presentAlert(with error: NetworkError) {
        let alert = UIAlertController(title: "Occurrió un error", message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.moviesViewModel.reloadMovies()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK:- Binding
    private func bindValues() {
        moviesViewModel.networkError.bind { [weak self] error in
            guard let self = self else { return }
            guard let error = error else { return }
            self.presentAlert(with: error)
            self.refreshControl.endRefreshing()
            self.moviesViewModel.networkError.value = nil
        }
        
        moviesViewModel.moviesDidLoad.bind { [weak self] didLoad in
            guard let self = self else { return }
            guard didLoad else { return }
            self.refreshControl.endRefreshing()
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailViewController {
            if let movie = selectedMovie {
                destination.configure(with: movie)
            }
        }
    }

}

// MARK:- Collection View Data Source
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesViewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableCellID, for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: moviesViewModel.movies[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        moviesViewModel.loadMoreMovies(indexPath.row)
    }
    
}

// MARK:- Collection View Delegate
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMovie = moviesViewModel.movies[indexPath.row].id
        performSegue(withIdentifier: segueID, sender: self)
    }
}

// MARK:- Collection View Delegate Flow Layout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2-20, height: kDesigning.collectionViewCellHeight)
    }
}

private enum kDesigning {
    static let collectionViewCellHeight: CGFloat = 270
}
