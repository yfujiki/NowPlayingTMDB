//
//  MoviesDataSourcePrefetching.swift
//  SimilarTMDB
//
//  Created by Yuichi Fujiki on 4/26/19.
//  Copyright © 2019 Yfujiki. All rights reserved.
//

import UIKit
import os

class SimilarMoviesDataSourcePrefetching: NSObject, MoviesDataSourcePrefetching {
    weak var delegate: MoviesDataSourcePrefetchingDelegate?

    var referenceMovieId: Int?

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

        guard let referenceMovieId = referenceMovieId else {
            os_log("No reference video Id")
            return
        }

        apiManager.similar(referenceMovieId: referenceMovieId, page: nextPage) { [weak self] result in
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
