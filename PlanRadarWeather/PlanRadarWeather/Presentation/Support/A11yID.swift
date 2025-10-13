//
//  A11yID.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 13/10/2025.
//


// A11yID.swift (app target)
enum A11yID {
    static let citiesTitle = "Cities.Title"
    static let addPill     = "Cities.AddPill"
    static func cityRow(_ name: String) -> String { "Cities.Row.\(name)" }
    static func rowArrow(_ name: String) -> String { "Cities.RowArrow.\(name)" }

    static let addTextField = "AddCity.TextField"
    static let addSubmit    = "AddCity.Submit"

    static let detailsCard  = "Details.Card"
    static let modalClose   = "Modal.Close"
    static let backPill     = "Back.Pill"
    static let historyTitle = "History.Title"
}