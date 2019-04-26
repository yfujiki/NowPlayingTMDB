//
//  MovieDetailDataSource.swift
//  NowPlayingTMDB
//
//  Created by Yuichi Fujiki on 4/25/19.
//  Copyright © 2019 Yfujiki. All rights reserved.
//

import Foundation
import UIKit

class MovieDetailDataSource: MoviesDataSource {
    var movie: Movie?

    convenience init(movie: Movie?, size: CGSize) {
        self.init(size: size)
        self.movie = movie
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let detailView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MovieDetailView.self.description(), for: indexPath) as! MovieDetailView

        guard let movie = movie else {
            return detailView
        }

        detailView.movie = movie

        return detailView
    }
}
