//
//  Route.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 12/10/2025.
//


// CitiesView.swift (top-level or in a small file)
enum Route: Hashable {
    case detail(CityEntity)
    case history(CityEntity)
}