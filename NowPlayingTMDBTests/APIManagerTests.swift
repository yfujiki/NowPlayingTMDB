//
//  APIManagerTests.swift
//  NowPlayingTMDBTests
//
//  Created by Yuichi Fujiki on 4/24/19.
//  Copyright © 2019 Yfujiki. All rights reserved.
//

import XCTest
import OHHTTPStubs

@testable import NowPlayingTMDB

class APIManagerTests: XCTestCase {

    let apiManager = APIManager()

    override func setUp() {
        setUpNowPlaying()
        setUpSimilar()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    private func setUpNowPlaying() {
        stub(condition: isHost("api.themoviedb.org") && isPath("/3/movie/now_playing")) { _ in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("NowPlaying.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type":"application/json"]
            )
        }
    }

    private func setUpSimilar() {
        stub(condition: isHost("api.themoviedb.org") && isPath("/3/movie/299537/similar")) { _ in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("Similar.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type":"application/json"]
            )
        }
    }

    func testNowPlaying() {
        let page = expectation(description: "moviesPage is 2")
        let totalPage = expectation(description: "totalPage is 58")
        let totalResults = expectation(description: "totalResults is 1160")
        let resultsCount = expectation(description: "results count per page is 20")

        apiManager.nowPlaying(page: 2) { result in
            switch(result) {
            case .success(let moviesPage):
                if (moviesPage.page == 2) {
                    page.fulfill()
                }
                if (moviesPage.totalPages == 58) {
                    totalPage.fulfill()
                }
                if (moviesPage.totalResults == 1160) {
                    totalResults.fulfill()
                }
                if (moviesPage.results.count == 20) {
                    resultsCount.fulfill()
                }
            case .failure(let error):
                XCTAssert(false, "Failed to fetch now playing with error \(error)")
            }
        }

        let result = XCTWaiter.wait(for: [page, totalPage, totalResults, resultsCount], timeout: 2)
        XCTAssert(result == .completed)
    }

    func testSimilar() {
        let page = expectation(description: "moviesPage is 1")
        let totalPage = expectation(description: "totalPage is 17")
        let totalResults = expectation(description: "totalResults is 332")
        let resultsCount = expectation(description: "results count per page is 20")

        apiManager.similar(referenceMovieId: 299537, page: 1) { result in
            switch(result) {
            case .success(let moviesPage):
                if (moviesPage.page == 1) {
                    page.fulfill()
                }
                if (moviesPage.totalPages == 17) {
                    totalPage.fulfill()
                }
                if (moviesPage.totalResults == 332) {
                    totalResults.fulfill()
                }
                if (moviesPage.results.count == 20) {
                    resultsCount.fulfill()
                }
            case .failure(let error):
                XCTAssert(false, "Failed to fetch now playing with error \(error)")
            }
        }

        let result = XCTWaiter.wait(for: [page, totalPage, totalResults, resultsCount], timeout: 2)
        XCTAssert(result == .completed)
    }

    private func setUpNowPlayingBadData() {
        stub(condition: isHost("api.themoviedb.org") && isPath("/3/movie/now_playing")) { _ in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("NowPlaying_Bad.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type":"application/json"]
            )
        }
    }

    func testNowPlayingBadData() {
        setUpNowPlayingBadData()

        let decodeError = expectation(description: "Decoding Error")

        apiManager.nowPlaying(page: 2) { result in
            switch(result) {
            case .success(_):
                XCTAssert(false, "Should not succeed in this case")
            case .failure(_):
                decodeError.fulfill()
            }
        }

        let result = XCTWaiter.wait(for: [decodeError], timeout: 2)
        XCTAssert(result == .completed)
    }

    private func setUpSimilarBadData() {
        stub(condition: isHost("api.themoviedb.org") && isPath("/3/movie/299537/similar")) { _ in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("Similar_Bad.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type":"application/json"]
            )
        }
    }

    func testSimilarBadData() {
        setUpSimilarBadData()

        let decodeError = expectation(description: "Decoding Error")

        apiManager.similar(referenceMovieId: 299537, page: 1) { result in
            switch(result) {
            case .success(_):
                XCTAssert(false, "Should not succeed in this case")
            case .failure(_):
                decodeError.fulfill()
            }
        }

        let result = XCTWaiter.wait(for: [decodeError], timeout: 2)
        XCTAssert(result == .completed)
    }
}
