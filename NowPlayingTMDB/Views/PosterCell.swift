//
//  PosterCell.swift
//  NowPlayingTMDB
//
//  Created by Yuichi Fujiki on 4/24/19.
//  Copyright © 2019 Yfujiki. All rights reserved.
//

import UIKit
import PINRemoteImage
import SkeletonView

class PosterCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        imageView.isSkeletonable = true
    }

    func setImagePath(imagePath: String?) {
        guard let imagePath = imagePath else {
            imageView.image = UIImage(named: "placeholder")
            return
        }

        imageView.pin_setImage(from: URL(string: imagePath), placeholderImage: UIImage(named: "placeholder"))
    }
}
