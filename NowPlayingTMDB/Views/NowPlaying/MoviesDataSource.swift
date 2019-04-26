//
//  MoviesDataSource.swift
//  NowPlayingTMDB
//
//  Created by Yuichi Fujiki on 4/24/19.
//  Copyright © 2019 Yfujiki. All rights reserved.
//

import Foundation
import UIKit
import SkeletonView

class MoviesDataSource: NSObject, SkeletonCollectionViewDataSource {
    private var movies: Array<Movie>

    private var cellSize: CGSize = .zero

    var count: Int {
        return movies.count
    }

    override init() {
        movies = Array<Movie>()
        super.init()
    }

    convenience init(size: CGSize) {
        self.init()
        cellSize = size
    }

    func addMovies(_ additional: Array<Movie>) {
        movies.append(contentsOf: additional)
    }

    func movie(at index: Int) -> Movie? {
        guard index >= 0 && index < movies.count else {
            return nil
        }

        return movies[index]
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCell.self.description(), for: indexPath) as! PosterCell

        let movie = movies[indexPath.item]

        let imageWidth = Constants.POSTER_IMAGE_WIDTH_FOR_SIZE(size: cellSize)
        cell.setImagePath(imagePath: movie.posterFullPath(for: Int(imageWidth)))

        return cell
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return PosterCell.self.description()
    }    
}
