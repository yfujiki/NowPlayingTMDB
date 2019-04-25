//
//  MovieDetailView.swift
//  NowPlayingTMDB
//
//  Created by Yuichi Fujiki on 4/25/19.
//  Copyright © 2019 Yfujiki. All rights reserved.
//

import UIKit
import PINRemoteImage

class MovieDetailView: UICollectionReusableView {

    @IBOutlet weak var posterImageView: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var yearLabel: UILabel!

    @IBOutlet weak var descriptionLabel: UILabel!

    var movie: Movie? {
        didSet {
            let imageWidth = Constants.POSTER_IMAGE_WIDTH_FOR_SIZE(size: posterImageView?.bounds.size ?? .zero)
            if let imagePath = movie?.posterFullPath(for: Int(imageWidth)) {
                // ToDo : Placeholder
                posterImageView?.pin_setImage(from: URL(string: imagePath))
            } else {
                // ToDo : Placeholder
            }

            titleLabel.text = movie?.title
            yearLabel.text = Constants.PARSE_YEAR_FROM_YYYYMMDD(yyyymmdd: movie?.releaseDate)
            descriptionLabel.text = movie?.overview
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
