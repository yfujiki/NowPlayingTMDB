//
//  MovieTests.swift
//  NowPlayingTMDBTests
//
//  Created by Yuichi Fujiki on 4/24/19.
//  Copyright © 2019 Yfujiki. All rights reserved.
//

import XCTest

@testable import NowPlayingTMDB

class MovieTests: XCTestCase {

    let modelString = """
    {"vote_count":4069,"id":299537,"video":false,"vote_average":7.1,"title":"Captain Marvel","popularity":390.7,"poster_path":"/AtsgWhDnHTq68L0lLsUrCnM7TjG.jpg","original_language":"en","original_title":"Captain Marvel","genre_ids":[28,12,878],"backdrop_path":"/w2PMyoyLU22YvrGK3smVM9fW1jj.jpg","adult":false,"overview":"The story follows Carol Danvers as she becomes one of the universe’s most powerful heroes when Earth is caught in the middle of a galactic war between two alien races. Set in the 1990s, Captain Marvel is an all-new adventure from a previously unseen period in the history of the Marvel Cinematic Universe.","release_date":"2019-03-06"}
    """

    lazy var modelData: Data = {
        Data(modelString.utf8)
    }()

    override func setUp() {
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDecode() {
        do {
            let movie = try Movie(from: modelData)
            XCTAssertEqual(4069, movie.voteCount)
            XCTAssertEqual(299537, movie.id)
            XCTAssertEqual(false, movie.video)
            XCTAssertEqual(7.1, movie.voteAverage)
            XCTAssertEqual("Captain Marvel", movie.title)
            XCTAssertEqual(390.7, movie.popularity)
            XCTAssertEqual("/AtsgWhDnHTq68L0lLsUrCnM7TjG.jpg", movie.posterPath)
            XCTAssertEqual("en", movie.originalLanguage)
            XCTAssertEqual("Captain Marvel", movie.originalTitle)
            XCTAssertEqual([28,12,878], movie.genreIds)
            XCTAssertEqual("/w2PMyoyLU22YvrGK3smVM9fW1jj.jpg", movie.backdropPath)
            XCTAssertEqual(false, movie.adult)
            XCTAssertEqual("The story follows Carol Danvers as she becomes one of the universe’s most powerful heroes when Earth is caught in the middle of a galactic war between two alien races. Set in the 1990s, Captain Marvel is an all-new adventure from a previously unseen period in the history of the Marvel Cinematic Universe.", movie.overview)
            XCTAssertEqual("2019-03-06", movie.releaseDate)
        } catch let error {
            XCTAssert(false, "Failed with error : \(error) to encode and decode movie data.")
        }
    }
}
