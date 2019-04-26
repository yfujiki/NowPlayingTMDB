//
//  MovieDetailView.swift
//  NowPlayingTMDB
//
//  Created by Yuichi Fujiki on 4/25/19.
//  Copyright © 2019 Yfujiki. All rights reserved.
//

import UIKit
import PINRemoteImage
import os

class MovieDetailView: UICollectionReusableView {

    @IBOutlet weak var posterImageView: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var yearLabel: UILabel!

    @IBOutlet weak var descriptionLabel: UILabel!

    private lazy var descriptionLabelImageViewLeadingConstraint: NSLayoutConstraint = {
        descriptionLabel.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor)
    }()

    private lazy var descriptionLabelImageViewVerticalConstraint: NSLayoutConstraint = {
        descriptionLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 16)
    }()

    private lazy var descriptionLabelReleaseYearLeadingConstraint: NSLayoutConstraint = {
        descriptionLabel.leadingAnchor.constraint(equalTo: yearLabel.leadingAnchor)
    }()

    private lazy var descriptionLabelReleaseYearVerticalConstraint: NSLayoutConstraint = {
        descriptionLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 16)
    }()

    override func awakeFromNib() {
        super.awakeFromNib()

        self.addConstraint(descriptionLabelImageViewLeadingConstraint)
        descriptionLabelImageViewLeadingConstraint.isActive = false
        self.addConstraint(descriptionLabelImageViewVerticalConstraint)
        descriptionLabelImageViewVerticalConstraint.isActive = false
        self.addConstraint(descriptionLabelReleaseYearLeadingConstraint)
        descriptionLabelReleaseYearLeadingConstraint.isActive = false
        self.addConstraint(descriptionLabelReleaseYearVerticalConstraint)
        descriptionLabelReleaseYearVerticalConstraint.isActive = false
    }

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

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if (Constants.IS_WIDE_LAYOUT(screenWidth: UIScreen.main.bounds.width)) {
            NSLayoutConstraint.deactivate([
                descriptionLabelReleaseYearLeadingConstraint,
                descriptionLabelReleaseYearVerticalConstraint
                ])
            NSLayoutConstraint.activate([
                descriptionLabelImageViewLeadingConstraint,
                descriptionLabelImageViewVerticalConstraint
                ])
        } else {
            NSLayoutConstraint.deactivate([
                descriptionLabelImageViewLeadingConstraint,
                descriptionLabelImageViewVerticalConstraint
                ])
            NSLayoutConstraint.activate([
                descriptionLabelReleaseYearLeadingConstraint,
                descriptionLabelReleaseYearVerticalConstraint
                ])
        }
    }
}

