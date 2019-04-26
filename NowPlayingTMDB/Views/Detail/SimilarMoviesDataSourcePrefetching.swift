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

    private var prefetchingPageSet = Set<Int>()
    private var prefetchedPageSet = Set<Int>()

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

        if prefetchingPageSet.contains(nextPage) {
            os_log("The page is being fetched already")
            return
        }

        if (prefetchedPageSet.contains(nextPage)) {
            os_log("The page was fetched successfully already")
            return
        }

        guard let referenceMovieId = referenceMovieId else {
            os_log("No reference video Id")
            return
        }

        prefetchingPageSet.insert(referenceMovieId)
        apiManager.similar(referenceMovieId: referenceMovieId, page: nextPage) { [weak self] result in
            switch(result) {
            case .success(let moviesPage):
                self?.delegate?.didPrefetchMovies(moviesPage.results, for: indexPaths)
                self?.prefetchingPageSet.remove(nextPage)
                self?.prefetchedPageSet.insert(nextPage)
            case .failure(let error):
                self?.prefetchingPageSet.remove(nextPage)
                // ToDo: Display on the view
                os_log("Failed to obtain error : %@", error.localizedDescription)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        os_log("Canceling prefetching for indexPath : %@", indexPaths.description)
    }
}
