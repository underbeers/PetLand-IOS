//
//  PetLandTests.swift
//  PetLandTests
//
//  Created by Никита Сигал on 23.05.2023.
//

@testable import PetLand
import XCTest

final class LocationServiceTests: XCTestCase {
    let locationService: LocationServiceProtocol = LocationService.shared

    func testAllCities() async throws {
        locationService.getCities { result in
            switch result {
                case .success(let cities):
                    XCTAssert(cities.count == 19, "The city count does not match")
                case .failure(let error):
                    XCTFail(error.localizedDescription)
            }
        }
    }

    func testCityByID() async throws {
        locationService.getCities(id: 2) { result in
            switch result {
                case .success(let cities):
                    XCTAssert(cities.count == 1, "The city count does not match")
                    XCTAssert(cities[0].name == "Санкт-Петербург", "The city name does not match")
                case .failure(let error):
                    XCTFail(error.localizedDescription)
            }
        }
    }

    func testAllDistricts() async throws {
        locationService.getDistricts { result in
            switch result {
                case .success(let districts):
                    XCTAssert(districts.count == 257, "The district count does not match")
                case .failure(let error):
                    XCTFail(error.localizedDescription)
            }
        }
    }

    func testDistrictsByCityID() async throws {
        locationService.getDistricts(cityID: 2) { result in
            switch result {
                case .success(let districts):
                    XCTAssert(districts.count == 18, "The district count does not match")
                case .failure(let error):
                    XCTFail(error.localizedDescription)
            }
        }
    }

    func testDistrictByID() async throws {
        locationService.getDistricts(id: 3) { result in
            switch result {
                case .success(let districts):
                    XCTAssert(districts.count == 1, "The district count does not match")
                    XCTAssert(districts[0].name == "Алтуфьевский", "The city name does not match")
                case .failure(let error):
                    XCTFail(error.localizedDescription)
            }
        }
    }
}
