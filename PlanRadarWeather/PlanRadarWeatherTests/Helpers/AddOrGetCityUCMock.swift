//
//  AddOrGetCityUCMock.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 13/10/2025.
//

@testable import PlanRadarWeather

struct AddOrGetCityUCMock: AddOrGetCityUseCase {
    let impl: (_ name: String) throws -> CityEntity
    func run(name: String) throws -> CityEntity { try impl(name) }
}
struct ListCitiesUCMock: ListCitiesUseCase {
    let impl: () throws -> [CityEntity]
    func run() throws -> [CityEntity] { try impl() }
}
struct DeleteCitiesUCMock: DeleteCitiesUseCase {
    let impl: (_ cities: [CityEntity]) throws -> Void
    func run(_ cities: [CityEntity]) throws { try impl(cities) }
}
