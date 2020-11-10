//
//  ViewController.swift
//  TestDaCodes
//
//  Created by Jaime Escobar on 09/11/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    private let moviesViewModel = MoviesViewModel()
    private var selectedMovieId: Int?
    private let refreshControl = UIRefreshControl()
    
    private enum DesigningConstants {
        static let collectionViewCellHeight: CGFloat = 270
        static let reusableCellID = "MovieCollectionViewCell"
        static let segueID = "showDetailsSegue"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bindValues()
    }
    
    // MARK:- Functions
    @objc private func refresh() {
        moviesViewModel.reloadMovies()
    }
    
    private func configureView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    private func presentAlert(with error: NetworkError) {
        let alert = UIAlertController(title: "Oops! something went wrong", message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.moviesViewModel.reloadMovies()
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    // MARK:- Binding
    private func bindValues() {
        moviesViewModel.requestStatus.bind { [weak self] status in
            switch status {
            case .loading:
                // I'd add activity indicator
                break
            case .didLoad:
                guard let self = self else { return }
                self.refreshControl.endRefreshing()
                self.collectionView.reloadData()
            case .error(let error):
                guard let self = self else { return }
                self.presentAlert(with: error)
                self.refreshControl.endRefreshing()
            }
        }
        moviesViewModel.loadMovies()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailViewController {
            if let id = selectedMovieId {
                destination.configure(with: id)
            }
        }
    }

}

// MARK:- Collection View Data Source
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesViewModel.totalMovies
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DesigningConstants.reusableCellID, for: indexPath) as? MovieCollectionViewCell else {
            assertionFailure("Unable to deque MovieCollectionViewCell at ViewController")
            return UICollectionViewCell()
        }
        guard let movie = moviesViewModel.getMovie(at: indexPath.row) else {
            return UICollectionViewCell()
        }
        cell.configure(with: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        moviesViewModel.loadMoreMovies(indexPath.row)
    }
    
}

// MARK:- Collection View Delegate
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMovieId = moviesViewModel.getMovie(at: indexPath.row)?.id
        performSegue(withIdentifier: DesigningConstants.segueID, sender: self)
    }
}

// MARK:- Collection View Delegate Flow Layout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2-20, height: DesigningConstants.collectionViewCellHeight)
    }
}
