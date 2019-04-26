//
//  MoviesDataSourcePrefetching.swift
//  NowPlayingTMDB
//
//  Created by Yuichi Fujiki on 4/26/19.
//  Copyright © 2019 Yfujiki. All rights reserved.
//

import UIKit
import os

protocol MoviesDataSourcePrefetchingDelegate: class {
    func needsFetch(for indexPath: [IndexPath]) -> Bool
    func nextPage(for indexPath: [IndexPath]) -> Int
    func didPrefetchMovies(_ movies: [Movie], for indexPath: [IndexPath])
}

class MoviesDataSourcePrefetching: NSObject, UICollectionViewDataSourcePrefetching {

    weak var delegate: MoviesDataSourcePrefetchingDelegate?

    private lazy var apiManager: APIManager = {
        return APIManager()
    }()

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        os_log("Start prefetching for indexPath : %@", indexPaths.description)

        guard delegate?.needsFetch(for: indexPaths) == true else {
            os_log("No need to fetch")
            return
        }

        guard let nextPage = delegate?.nextPage(for: indexPaths) else {
            os_log("No next page")
            return
        }

        os_log("Next page is : %d", nextPage)

        apiManager.nowPlaying(page: nextPage) { [weak self] result in
            switch(result) {
            case .success(let moviesPage):
                self?.delegate?.didPrefetchMovies(moviesPage.results, for: indexPaths)
            case .failure(let error):
                // ToDo: Display on the view
                os_log("Failed to obtain error : %@", error.localizedDescription)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        os_log("Canceling prefetching for indexPath : %@", indexPaths.description)
    }
}
