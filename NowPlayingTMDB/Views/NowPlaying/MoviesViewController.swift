//
//  ViewController.swift
//  NowPlayingTMDB
//
//  Created by Yuichi Fujiki on 4/24/19.
//  Copyright © 2019 Yfujiki. All rights reserved.
//

import UIKit
import os

class MoviesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    private lazy var dataSource = {
        return MoviesDataSource(size: Constants.MOVIE_CELL_SIZE())
    }()
    private lazy var delegate: MoviesDelegate = {
        let del = MoviesDelegate(size: Constants.MOVIE_CELL_SIZE())
        del.selectionDelegate = self
        return del
    }()
    private lazy var apiManager = {
        APIManager()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Now Playing"

        collectionView.register(UINib(nibName: "PosterCell", bundle: nil), forCellWithReuseIdentifier: PosterCell.self.description())
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()

        apiManager.nowPlaying(page: 1) { [weak self] result in
            switch(result) {
            case .success(let moviesPage):
                self?.dataSource.addMovies(moviesPage.results)
                self?.collectionView.reloadData()
            case .failure(let error):
                // ToDo: Display on the view
                os_log("Failed to obtain error : %@", error.localizedDescription)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "movieSelected") {
            let movieDetailViewController = segue.destination as! MovieDetailViewController
            guard let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first else {
                return
            }

            if let movie = self.dataSource.movie(at: selectedIndexPath.item) {
                movieDetailViewController.movie = movie
            }

            collectionView.deselectItem(at: selectedIndexPath, animated: true)
        }
    }
}

extension MoviesViewController: MoviesDelegateSelectionDelegate {
    func didSelectItemAt(item: Int) {
        performSegue(withIdentifier: "movieSelected", sender: nil)
    }
}
