//
//  MoviesDataSourcePrefetching.swift
//  NowPlayingTMDB
//
//  Created by Yuichi Fujiki on 4/26/19.
//  Copyright © 2019 Yfujiki. All rights reserved.
//

import UIKit

protocol MoviesDataSourcePrefetchingDelegate: class {
    func needsFetch(for indexPath: [IndexPath]) -> Bool
    func nextPage(for indexPath: [IndexPath]) -> Int
    func didPrefetchMovies(_ movies: [Movie], for indexPath: [IndexPath])
}

protocol MoviesDataSourcePrefetching: class, UICollectionViewDataSourcePrefetching {
    var delegate: MoviesDataSourcePrefetchingDelegate? { get set }
}
