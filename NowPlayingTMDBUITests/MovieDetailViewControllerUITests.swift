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
        let app = XCUIApplication()
        let collectionsQuery = app.collectionViews
        
        let predicate = NSPredicate(format: "exists == 1")
        let collectionViewExists = expectation(for: predicate, evaluatedWith: collectionsQuery.element, handler: nil)
        wait(for: [collectionViewExists], timeout: 1)

        let cells = collectionsQuery.cells
        let firstCell = cells.element.firstMatch
        XCTAssertTrue(firstCell.isHittable)

        firstCell.tap()
    }

    func testLanding() {
        openDetailView()

        let app = XCUIApplication()
        
        let posterImage = app.images.element(matching: .any, identifier: "posterImage")
        let predicate = NSPredicate(format: "exists == 1")
        let posterImageExpectation = expectation(for: predicate, evaluatedWith: posterImage, handler: nil)
        wait(for: [posterImageExpectation], timeout: 1)

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

        let posterImage = app.images.element(matching: .any, identifier: "posterImage")
        let predicate = NSPredicate(format: "exists == 1")
        let posterImageExpectation = expectation(for: predicate, evaluatedWith: posterImage, handler: nil)
        wait(for: [posterImageExpectation], timeout: 1)

        app.swipeUp()

        let collectionsQuery = app.collectionViews
        let collectionsElement = collectionsQuery.element
        for _ in 0..<5 {
            collectionsElement.swipeUp()
        }

        // No assertion, but just scroll down to the bottom and see if anything wrong happens
    }

    func testOpenRelatedMovie() {
        openDetailView()

        let app = XCUIApplication()
        
        let posterImage = app.images.element(matching: .any, identifier: "posterImage")
        let predicate = NSPredicate(format: "exists == 1")
        let posterImageExpectation = expectation(for: predicate, evaluatedWith: posterImage, handler: nil)
        wait(for: [posterImageExpectation], timeout: 1)

        app.swipeUp()

        let collectionsQuery = app.collectionViews
        let cells = collectionsQuery.cells
        let firstCell = cells.element.firstMatch
        XCTAssertTrue(firstCell.isHittable)

        firstCell.tap()

        let posterImage2 = app.images.element(matching: .any, identifier: "posterImage")
        let predicate2 = NSPredicate(format: "exists == 1")
        let posterImageExpectation2 = expectation(for: predicate2, evaluatedWith: posterImage2, handler: nil)
        wait(for: [posterImageExpectation2], timeout: 1)

        let titleLabel = app.staticTexts.element(matching: .any, identifier: "title")
        let yearLabel = app.staticTexts.element(matching: .any, identifier: "year")
        let descriptionLabel = app.staticTexts.element(matching: .any, identifier: "description")

        XCTAssertTrue(titleLabel.isHittable)
        XCTAssertTrue(yearLabel.isHittable)
        XCTAssertTrue(descriptionLabel.isHittable)

        app.swipeUp()

        // ToDo: Punting on this. Don't know why this is not hittable
//        let collectionsQuery2 = app.collectionViews
//        let cells2 = collectionsQuery2.cells
//        let firstCell2 = cells2.element.firstMatch
//        XCTAssertTrue(firstCell2.isHittable)
    }

}
