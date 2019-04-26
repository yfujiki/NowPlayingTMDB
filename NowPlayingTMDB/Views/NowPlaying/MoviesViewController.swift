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

    private var pageSize = 20

    private var totalResults = 0

    private lazy var dataSource = {
        return MoviesDataSource(size: Constants.MOVIE_CELL_SIZE())
    }()
    private lazy var prefetchingDataSource: MoviesDataSourcePrefetching = {
        let dsc = MoviesDataSourcePrefetching()
        dsc.delegate = self
        return dsc
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
        collectionView.prefetchDataSource = prefetchingDataSource
        collectionView.delegate = delegate
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()

        apiManager.nowPlaying(page: 1) { [weak self] result in
            switch(result) {
            case .success(let moviesPage):
                self?.dataSource.addMovies(moviesPage.results)
                self?.collectionView.reloadData()
                self?.pageSize = max(moviesPage.results.count, 1)
                self?.totalResults = moviesPage.totalResults
            case .failure(let error):
                // ToDo: Display on the view
                os_log("Failed to obtain error : %@", error.localizedDescription)
            }
        }
    }
}

extension MoviesViewController: MoviesDelegateSelectionDelegate {
    func didSelectItemAt(item: Int) {
        let viewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController

        guard let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first else {
            return
        }

        if let movie = self.dataSource.movie(at: selectedIndexPath.item) {
            viewController.movie = movie
        }

        show(viewController, sender: self)

        collectionView.deselectItem(at: selectedIndexPath, animated: true)
    }
}

extension MoviesViewController: MoviesDataSourcePrefetchingDelegate {
    func prefetch(page: Int, afterSuccess: @escaping () -> Void, afterFailure: @escaping () -> Void) {
        apiManager.nowPlaying(page: page) { [weak self] result in
            switch(result) {
            case .success(let moviesPage):
                self?.dataSource.addMovies(moviesPage.results)
                self?.collectionView.reloadData()
                afterSuccess()
            case .failure(let error):
                // ToDo: Display on the view
                os_log("Failed to obtain error : %@", error.localizedDescription)
                afterFailure()
            }
        }
    }

    func needsFetch(for indexPaths: [IndexPath]) -> Bool {
        os_log("Data source count : %d, total results : %d", dataSource.count, totalResults)
        guard dataSource.count < totalResults else {
            return false
        }

        return indexPaths.contains { $0.item + pageSize >= self.dataSource.count }
    }

    func nextPage(for indexPaths: [IndexPath]) -> Int {
        let max = indexPaths.map { $0.item }.max() ?? 0
        let nextItem = max + pageSize
        let nextPage = Int(nextItem / pageSize) + 1
        return nextPage
    }
}
