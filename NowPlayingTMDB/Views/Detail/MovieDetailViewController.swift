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

    var movie: Movie? {
        didSet {
            title = movie?.title ?? "Movie Title"
        }
    }

    private lazy var dataSource = {
        MovieDetailDataSource(movie: movie, size: Constants.MOVIE_CELL_SIZE())
    }()

    private lazy var delegate = {
        MoviesDelegate(size: Constants.MOVIE_CELL_SIZE())
    }()

    private lazy var layout: UICollectionViewFlowLayout = {
        let collectionLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        let height = CGFloat(336)
        collectionLayout.headerReferenceSize = CGSize(width: Constants.PORTRAIT_SCREEN_WIDTH(), height: height)
        return collectionLayout
    }()

    private lazy var apiManager = {
        APIManager()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib(nibName: "PosterCell", bundle: nil), forCellWithReuseIdentifier: PosterCell.self.description())
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        collectionView.collectionViewLayout = layout

        collectionView.register(UINib(nibName: "MovieDetailView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MovieDetailView.self.description())

        guard let movie = movie else {
            return
        }

        apiManager.similar(referenceMovieId: movie.id, page: 1) { [weak self] result in
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

}
