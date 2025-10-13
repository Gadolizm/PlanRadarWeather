//
//  CitiesUITests.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 13/10/2025.
//


// CitiesUITests.swift  (UITests target)
import XCTest


final class CitiesUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication().launchForUITests() // light mode
    }

    func test_cities_screen_shows_title_and_any_row() {
        XCTAssertTrue(app.staticTexts[A11yID.citiesTitle].waitExists())

        // Your VM shows UI-fallback rows when empty; assert any exists
        let anyRow = app.staticTexts.matching(NSPredicate(format: "identifier BEGINSWITH %@", "Cities.Row.")).firstMatch
        XCTAssertTrue(anyRow.waitExists(), "Expected at least one row")
    }

    func test_add_city_via_sheet() {
        let add = app.otherElements[A11yID.addPill]
        XCTAssertTrue(add.waitExists())
        add.tap()

        let tf = app.textFields[A11yID.addTextField]
        XCTAssertTrue(tf.waitExists())
        tf.tap(); tf.typeText("Rome, IT")

        let submit = app.buttons[A11yID.addSubmit]
        if submit.waitExists() { submit.tap() } else { app.keyboards.buttons["return"].tap() }

        // New row appears
        let rome = app.staticTexts[A11yID.cityRow("Rome, IT")]
        XCTAssertTrue(rome.waitExists(), "New city should appear in list")
    }

    func test_open_details_and_close() {
        // Tap the first row title to open details (if your nav does that)
        let anyRow = app.staticTexts.matching(NSPredicate(format: "identifier BEGINSWITH %@", "Cities.Row.")).firstMatch
        XCTAssertTrue(anyRow.waitExists())
        anyRow.tap()

        // A details container should appear
        let card = app.otherElements[A11yID.detailsCard]
        XCTAssertTrue(card.waitExists(), "Details card should be visible")

        // Close via modal pill or swipe-down
        let close = app.otherElements[A11yID.modalClose]
        if close.waitExists() { close.tap() } else { app.swipeDown() }

        XCTAssertTrue(app.staticTexts[A11yID.citiesTitle].waitExists())
    }

    func test_open_history_and_back() {
        // Tap the arrow button on the first row to open history
        let arrow = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", "Cities.RowArrow.")).firstMatch
        XCTAssertTrue(arrow.waitExists(), "Row arrow must exist")
        arrow.tap()

        XCTAssertTrue(app.staticTexts[A11yID.historyTitle].waitExists())

        // Custom back pill (or system back)
        let back = app.otherElements[A11yID.backPill]
        if back.waitExists() { back.tap() } else { app.buttons["Back"].tap() }

        XCTAssertTrue(app.staticTexts[A11yID.citiesTitle].waitExists())
    }

    func test_dark_mode_smoke() {
        app.terminate()
        _ = XCUIApplication().launchForUITests(dark: true)
        XCTAssertTrue(app.staticTexts[A11yID.citiesTitle].waitExists())
    }
}
