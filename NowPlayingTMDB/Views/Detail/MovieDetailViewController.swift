//
//  MovieDetailViewController.swift
//  NowPlayingTMDB
//
//  Created by Yuichi Fujiki on 4/25/19.
//  Copyright © 2019 Yfujiki. All rights reserved.
//

import UIKit
import os

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    private var pageSize = 20

    private var totalResults = 0

    var movie: Movie? {
        didSet {
            title = movie?.title ?? "Movie Title"
        }
    }

    private lazy var dataSource = {
        MovieDetailDataSource(movie: movie, size: Constants.MOVIE_CELL_SIZE())
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

        collectionView.register(UINib(nibName: "PosterCell", bundle: nil), forCellWithReuseIdentifier: PosterCell.self.description())
        collectionView.dataSource = dataSource
        collectionView.prefetchDataSource = prefetchingDataSource
        collectionView.delegate = delegate
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        configureHeaderHeight(for: UIScreen.main.bounds.size)

        collectionView.register(UINib(nibName: "MovieDetailView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MovieDetailView.self.description())

        guard let movie = movie else {
            return
        }

        apiManager.similar(referenceMovieId: movie.id, page: 1) { [weak self] result in
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

    private func configureHeaderHeight(for size: CGSize) {
        let screenWidth = size.width
        let detailViewImageWidth = screenWidth / 3
        let detailViewImageHeight = detailViewImageWidth / 0.675 + 16 * 2
        let detailViewHeight = Constants.IS_WIDE_LAYOUT(screenWidth: screenWidth) ? detailViewImageHeight + Constants.DESCRIPTION_AREA_HEIGHT : detailViewImageHeight

        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.headerReferenceSize = CGSize(width: screenWidth, height: detailViewHeight)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        configureHeaderHeight(for: size)
    }

    func didPrefetchMovies(_ movies: [Movie]) {
        dataSource.addMovies(movies)
        collectionView.reloadData()
    }
}

extension MovieDetailViewController: MoviesDelegateSelectionDelegate {
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

extension MovieDetailViewController: MoviesDataSourcePrefetchingDelegate {
    func prefetch(page: Int, afterSuccess: @escaping () -> Void, afterFailure: @escaping () -> Void) {
        guard let referenceMovieId = movie?.id else {
            os_log("No reference video Id")
            return
        }

        apiManager.similar(referenceMovieId: referenceMovieId, page: page) { [weak self] result in
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
