//
//  AdvertsViewModel.swift
//  PetLand
//
//  Created by Никита Сигал on 12.05.2023.
//

import Foundation

extension AdvertsView {
    @MainActor final class AdvertsViewModel: ObservableObject {
        private let advertService: AdvertServiceProtocol = AdvertService.shared
        private let petService: PetServiceProtocol = PetService.shared
        private let locationService: LocationServiceProtocol = LocationService.shared

        enum Mode {
            case sold,
                 found
        }

        @Published var currentMode: Mode = .sold {
            didSet {
                fetchAdvertCards()
            }
        }

        enum Sorting: String, CaseIterable {
            case newer = "Сначала новые"
            case cheaper = "Сначала дешевые"
            case expensive = "Сначала дорогие"

            var requestArgument: String {
                switch self {
                    case .newer:
                        return "publication"
                    case .cheaper:
                        return "minPrice"
                    case .expensive:
                        return "maxPrice"
                }
            }
        }

        @Published var sorting: Sorting = .newer {
            didSet {
                fetchAdvertCards()
            }
        }

        @Published var advertList: AdvertCardList = .init()

        @Published var presentingFilters: Bool = false

        @Published var filterType: String = ""
        private var filterTypeID: Int? {
            types.first(where: { $0.type == filterType })?.id
        }

        @Published var filterBreed: String = ""
        private var filterBreedID: Int? {
            breeds.first(where: { $0.breed == filterBreed })?.id
        }

        @Published var filterMinPrice: Int?
        var filterMinPriceString: String {
            get {
                if let filterMinPrice {
                    return String(filterMinPrice)
                } else {
                    return ""
                }
            }
            set {
                if newValue.isEmpty {
                    filterMinPrice = nil
                } else {
                    filterMinPrice = Int(newValue) ?? filterMinPrice
                }
            }
        }

        @Published var filterMaxPrice: Int?
        var filterMaxPriceString: String {
            get {
                if let filterMaxPrice {
                    return String(filterMaxPrice)
                } else {
                    return ""
                }
            }
            set {
                if newValue.isEmpty {
                    filterMaxPrice = nil
                } else {
                    filterMaxPrice = Int(newValue) ?? filterMaxPrice
                }
            }
        }

        @Published var filterCity: String = ""
        @Published var filterDistrict: String = ""

        private var filterCityID: Int? {
            cities.first(where: { $0.name == filterCity })?.id
        }

        private var filterDistrictID: Int? {
            districts.first(where: { $0.name == filterDistrict })?.id
        }

        @Published var types: [PetType] = []
        @Published var breeds: [PetBreed] = []

        @Published var cities: [City] = []
        @Published var districts: [District] = []

        @Published var alertMessage: String = ""
        @Published var presentingAlert: Bool = false

        func fetchAdvertCards() {
            advertService.getAdvertCards(typeID: filterTypeID,
                                         breedID: filterBreedID,
                                         minPrice: filterMinPrice,
                                         maxPrice: filterMaxPrice,
                                         cityID: filterCityID,
                                         districtID: filterDistrictID,
                                         sort: sorting.requestArgument)
            { [weak self] result in
                switch result {
                    case .success(let cardList):
                        self?.advertList = cardList
                    case .failure(let error):
                        switch error {
                            case APIError.serverDown:
                                self?.alertMessage = "Проблема с доступом к серверу"
                            default:
                                self?.alertMessage = error.localizedDescription
                        }
                        self?.presentingAlert = true
                }
            }
        }

        func fetchTypes() {
            petService.getTypes(typeID: nil, type: nil) { [weak self] result in
                switch result {
                    case .success(let types):
                        self?.types = types
                    case .failure(let error):
                        switch error {
                            case APIError.serverDown:
                                self?.alertMessage = "Проблема с доступом к серверу"
                            default:
                                self?.alertMessage = error.localizedDescription
                        }
                        self?.presentingAlert = true
                }
            }
        }

        func fetchBreeds() {
            guard let filterTypeID else {
                breeds = []
                return
            }

            petService.getBreeds(typeID: filterTypeID, breedID: nil, breed: nil) { [weak self] result in
                switch result {
                    case .success(let breeds):
                        self?.breeds = breeds
                    case .failure(let error):
                        switch error {
                            case APIError.serverDown:
                                self?.alertMessage = "Проблема с доступом к серверу"
                            default:
                                self?.alertMessage = error.localizedDescription
                        }
                        self?.presentingAlert = true
                }
            }
        }

        func fetchCities() {
            locationService.getCities { [weak self] result in
                switch result {
                    case .success(let cities):
                        self?.cities = cities
                    case .failure(let error):
                        switch error {
                            case APIError.serverDown:
                                self?.alertMessage = "Проблема с доступом к серверу"
                            default:
                                self?.alertMessage = error.localizedDescription
                        }
                        self?.presentingAlert = true
                }
            }
        }

        func fetchDistricts() {
            guard let filterCityID else {
                districts = []
                debugPrint("No filterCityID")
                return
            }

            locationService.getDistricts(cityID: filterCityID) { [weak self] result in
                switch result {
                    case .success(let districts):
                        self?.districts = districts
                    case .failure(let error):
                        switch error {
                            case APIError.serverDown:
                                self?.alertMessage = "Проблема с доступом к серверу"
                            default:
                                self?.alertMessage = error.localizedDescription
                        }
                        self?.presentingAlert = true
                }
            }
        }
    }
}
