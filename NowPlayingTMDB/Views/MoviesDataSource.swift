//
//  MoviesDataSource.swift
//  NowPlayingTMDB
//
//  Created by Yuichi Fujiki on 4/24/19.
//  Copyright © 2019 Yfujiki. All rights reserved.
//

import Foundation
import UIKit

class MoviesDataSource: NSObject, UICollectionViewDataSource {
    private var movies: Array<Movie>

    override init() {
        movies = Array<Movie>()
    }

    func addMovies(_ additional: Array<Movie>) {
        movies.append(contentsOf: additional)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCell.self.description(), for: indexPath) as! PosterCell

        let movie = movies[indexPath.item]

        cell.setImagePath(imagePath: movie.posterFullPath(for: 500))

        return cell
    }
}
