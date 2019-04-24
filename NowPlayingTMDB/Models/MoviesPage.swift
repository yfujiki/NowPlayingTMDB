//
//  MoviesPage.swift
//  NowPlayingTMDB
//
//  Created by Yuichi Fujiki on 4/24/19.
//  Copyright © 2019 Yfujiki. All rights reserved.
//

import Foundation

struct MoviesPage: JSONCodable {
    let page: Int
    let totalPages: Int
    let totalResults: Int
    let results: [Movie]
}
