//
//  SmokeTests.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 13/10/2025.
//


import XCTest
@testable import PlanRadarWeather

final class SmokeTests: XCTestCase {
    func test_smoke_runsWithoutSimulator() {
        XCTAssertNil(ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"],
                     "Unit tests must be logic tests (no simulator).")
        XCTAssertTrue(true)
    }
}