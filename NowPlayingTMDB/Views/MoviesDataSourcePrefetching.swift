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
    func prefetch(page: Int, afterSuccess: @escaping () -> Void, afterFailure: @escaping () -> Void)
}

class MoviesDataSourcePrefetching: NSObject, UICollectionViewDataSourcePrefetching {
    weak var delegate: MoviesDataSourcePrefetchingDelegate?

    private var prefetchingPageSet = Set<Int>()
    private var prefetchedPageSet = Set<Int>()

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        os_log("Start prefetching for indexPath : %@", indexPaths.description)

        guard delegate?.needsFetch(for: indexPaths) == true else {
            os_log("No need to fetch because indexPaths is below the limit")
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

        prefetchingPageSet.insert(nextPage)

        delegate?.prefetch(page: nextPage, afterSuccess: { [weak self] in
            self?.prefetchingPageSet.remove(nextPage)
            self?.prefetchedPageSet.insert(nextPage)
        }, afterFailure: { [weak self] in
            self?.prefetchingPageSet.remove(nextPage)
        })
    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        os_log("Canceling prefetching for indexPath : %@", indexPaths.description)
    }
}
