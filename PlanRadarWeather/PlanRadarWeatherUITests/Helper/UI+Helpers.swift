//
//  UI+Helpers.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 13/10/2025.
//


import XCTest

extension XCUIApplication {
    @discardableResult
    func launchForUITests(dark: Bool = false) -> XCUIApplication {
        launchArguments += ["-uiTesting", "1"]   // lets the app know “this is UI testing”
        if dark { launchArguments += ["-AppleInterfaceStyle", "Dark"] }
        launch()
        return self
    }
}

extension XCUIElement {
    func waitExists(_ timeout: TimeInterval = 3) -> Bool {
        waitForExistence(timeout: timeout)
    }
}
