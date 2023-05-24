//
//  AdvertEditViewModel.swift
//  PetLand
//
//  Created by Никита Сигал on 17.05.2023.
//

import Foundation
import PhoneNumberKit

extension AdvertEditView {
    @MainActor final class AdvertEditViewModel: ObservableObject {
        private let advertService: AdvertServiceProtocol = AdvertService.shared
        private let locationService: LocationServiceProtocol = LocationService.shared

        @Published var advert: AdvertEdit = .init()
        
        @Published var cities: [City] = []
        @Published var districts: [District] = []

        @Published var alertMessage: String = ""
        @Published var presentingAlert: Bool = false

        func commitAdvert(isNew: Bool, _ completion: @escaping () -> () = {}) {
            restoreDistrictID()
            advertService.commitAdvert(advert, isNew: isNew) { [weak self] error in
                if let error {
                    switch error {
                        case APIError.serverDown:
                            self?.alertMessage = "Проблема с доступом к серверу"
                        default:
                            self?.alertMessage = error.localizedDescription
                    }
                    self?.presentingAlert = true
                } else {
                    completion()
                }
            }
        }
        
        func restoreCityID() {
            advert.cityID = cities.first(where: { $0.name == advert.city })?.id ?? advert.cityID
        }
        
        func restoreDistrictID() {
            advert.districtID = districts.first(where: { $0.name == advert.district })?.id ?? advert.districtID
        }
        
        func fetchCities() {
            locationService.getCities { [weak self] result in
                switch result {
                    case .success(let cities):
                        self?.cities = cities
                        self?.fetchDistricts()
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
            restoreCityID()
            guard advert.cityID != 0 else {
                districts = []
                return
            }
            
            locationService.getDistricts(cityID: advert.cityID) { [weak self] result in
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
