//
//  Snapshot.swift
//  NowPlayingTMDBUITests
//
//  Created by Yuichi Fujiki on 4/26/19.
//  Copyright © 2019 Yfujiki. All rights reserved.
//

import XCTest

class FastlaneSnapshot: XCTestCase {

    override func setUp() {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launchEnvironment = ["UITEST": "true"]
        app.launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNowPlaying() {
        // Wait for all the images to load
        Thread.sleep(until: Date(timeIntervalSinceNow: 2))
        
        snapshot("1NowPlaying")
    }

    func testDetail() {
        let app = XCUIApplication()

        let collectionsQuery = app.collectionViews
        
        XCTAssertTrue(collectionsQuery.element.waitForExistence(timeout: 3))
        
        let cells = collectionsQuery.cells
        let firstCell = cells.element.firstMatch
        XCTAssertTrue(firstCell.isHittable)
        
        firstCell.tap()

        // Wait for all the images to load
        Thread.sleep(until: Date(timeIntervalSinceNow: 2))

        snapshot("2Detail")
    }
}
