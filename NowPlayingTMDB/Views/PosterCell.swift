//
//  PosterCell.swift
//  NowPlayingTMDB
//
//  Created by Yuichi Fujiki on 4/24/19.
//  Copyright © 2019 Yfujiki. All rights reserved.
//

import UIKit
import PINRemoteImage

class PosterCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setImagePath(imagePath: String?) {
        guard let imagePath = imagePath else {
            return
        }

        imageView.pin_setImage(from: URL(string: imagePath))
    }
}
