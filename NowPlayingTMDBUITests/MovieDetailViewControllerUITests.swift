//
//  MoveiDetailViewControllerUITests.swift
//  NowPlayingTMDBUITests
//
//  Created by Yuichi Fujiki on 4/26/19.
//  Copyright © 2019 Yfujiki. All rights reserved.
//

import XCTest

class MovieDetailViewControllerUITests: XCTestCase {

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

    private func openDetailView() {
        Thread.sleep(until: Date(timeIntervalSinceNow: 1))

        let app = XCUIApplication()
        let collectionsQuery = app.collectionViews
        let cells = collectionsQuery.cells
        let firstCell = cells.element.firstMatch
        XCTAssertTrue(firstCell.isHittable)

        firstCell.tap()

        Thread.sleep(until: Date(timeIntervalSinceNow: 1))
    }

    func testLanding() {
        openDetailView()

        let app = XCUIApplication()

        let titleLabel = app.staticTexts.element(matching: .any, identifier: "title")
        let yearLabel = app.staticTexts.element(matching: .any, identifier: "year")
        let descriptionLabel = app.staticTexts.element(matching: .any, identifier: "description")

        XCTAssertTrue(titleLabel.isHittable)
        XCTAssertTrue(yearLabel.isHittable)
        XCTAssertTrue(descriptionLabel.isHittable)

        app.swipeUp()

        let collectionsQuery = app.collectionViews
        let cells = collectionsQuery.cells
        let firstCell = cells.element.firstMatch
        XCTAssertTrue(firstCell.isHittable)
    }

    func testScrollDown() {
        openDetailView()

        let app = XCUIApplication()

        app.swipeUp()

        let collectionsQuery = app.collectionViews
        let collectionsElement = collectionsQuery.element
        for _ in 0..<10 {
            collectionsElement.swipeUp()
        }

        // No assertion, but just scroll down to the bottom and see if anything wrong happens
    }

    func testOpenRelatedMovie() {
        openDetailView()

        let app = XCUIApplication()

        app.swipeUp()

        let collectionsQuery = app.collectionViews
        let cells = collectionsQuery.cells
        let firstCell = cells.element.firstMatch
        XCTAssertTrue(firstCell.isHittable)

        firstCell.tap()

        Thread.sleep(until: Date(timeIntervalSinceNow: 1))

        let titleLabel = app.staticTexts.element(matching: .any, identifier: "title")
        let yearLabel = app.staticTexts.element(matching: .any, identifier: "year")
        let descriptionLabel = app.staticTexts.element(matching: .any, identifier: "description")

        XCTAssertTrue(titleLabel.isHittable)
        XCTAssertTrue(yearLabel.isHittable)
        XCTAssertTrue(descriptionLabel.isHittable)

        app.swipeUp()

        let collectionsQuery2 = app.collectionViews
        let cells2 = collectionsQuery2.cells
        let firstCell2 = cells2.element.firstMatch
        XCTAssertTrue(firstCell2.isHittable)
    }

}
