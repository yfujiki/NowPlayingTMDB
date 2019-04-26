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

    @IBOutlet weak var titleTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var yearTitleLabel: UILabel!
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

        titleTitleLabel.font = Global.titleFont
        titleLabel.font = Global.valueFont
        yearTitleLabel.font = Global.titleFont
        yearLabel.font = Global.valueFont
        descriptionLabel.font = Global.valueFont

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
            let imageWidth = Global.posterImageWidthForSize(size: posterImageView?.bounds.size ?? .zero)
            if let imagePath = movie?.posterFullPath(for: Int(imageWidth)) {
                posterImageView?.pin_setImage(from: URL(string: imagePath), placeholderImage: UIImage(named: "placeholder"))
            } else {
                posterImageView?.image = UIImage(named: "placeholder")
            }

            titleLabel.text = movie?.title
            yearLabel.text = Global.parseYearFromYYYYMMDD(yyyymmdd: movie?.releaseDate)
            descriptionLabel.text = movie?.overview
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if (Global.isWideLayout(screenWidth: UIScreen.main.bounds.width)) {
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

