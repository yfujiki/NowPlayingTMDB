//
//  MoviesViewControllerUITests.swift
//  NowPlayingTMDBUITests
//
//  Created by Yuichi Fujiki on 4/26/19.
//  Copyright © 2019 Yfujiki. All rights reserved.
//

import XCTest
import OHHTTPStubs

@testable import NowPlayingTMDB

class MoviesViewControllerUITests: XCTestCase {
    override func setUp() {        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        app.launchEnvironment = ["UITEST": "true"]
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLanding() {
        Thread.sleep(until: Date(timeIntervalSinceNow: 1))

        let app = XCUIApplication()
        let collectionsQuery = app.collectionViews
        let cells = collectionsQuery.cells

        NSLog("Amount of cells \(cells.count)")
        XCTAssertLessThanOrEqual(8, cells.count, "") // Smallest case is iPad landscape. Only 8 shots in a single view.
        XCTAssertGreaterThanOrEqual(20, cells.count, "")
    }

    func testScrollDown() {
        Thread.sleep(until: Date(timeIntervalSinceNow: 1))

        let app = XCUIApplication()
        let collectionsQuery = app.collectionViews
        let collectionsElement = collectionsQuery.element

        for _ in 0..<10 {
            collectionsElement.swipeUp()
        }

        // No assertion, but just scroll down to the bottom and see if anything wrong happens
    }
}
