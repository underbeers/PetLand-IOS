//
//  AdvertCardViewModel.swift
//  PetLand
//
//  Created by Никита Сигал on 24.05.2023.
//

import Foundation
import SwiftUI

extension AdvertCardView {
    @MainActor final class AdvertCardViewModel: ObservableObject {
        private let advertService: AdvertServiceProtocol = AdvertService.shared
        private let favouriteService: FavouriteServiceProtocol = FavouriteService.shared
        
        var advertCardBinding: Binding<AdvertCard> = .constant(.init())
        private var advertCard: AdvertCard {
            get {
                advertCardBinding.wrappedValue
            }
            set {
                advertCardBinding.wrappedValue = newValue
            }
        }
        
        @Published var alertMessage: String = ""
        @Published var presentingAlert: Bool = false
        
        func toggleFavourite() {
            if advertCard.favouriteID != 0{
                removeFromFavourites()
            } else {
                addToFavourites()
            }
        }
        
        func fetchInfo() {
            advertService.getAdvertCards(id: advertCard.id, userID: nil, petID: nil, typeID: nil, breedID: nil, gender: nil, minPrice: nil, maxPrice: nil, cityID: nil, districtID: nil, status: nil, sort: nil, page: nil, perPage: nil) { [weak self] result in
                switch result {
                    case .success(let list):
                        self?.advertCard = list.adverts[0]
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
        
        private func addToFavourites() {
            favouriteService.addFavourite(.advert, id: advertCard.id) { [weak self] error in
                if let error {
                    switch error {
                        case APIError.serverDown:
                            self?.alertMessage = "Проблема с доступом к серверу"
                        default:
                            self?.alertMessage = error.localizedDescription
                    }
                    self?.presentingAlert = true
                } else {
                    self?.fetchInfo()
                }
            }
        }
        
        private func removeFromFavourites() {
            guard advertCard.favouriteID != 0
            else { return }
            
            favouriteService.removeFavourite(id: advertCard.favouriteID) { [weak self] error in
                if let error {
                    switch error {
                        case APIError.serverDown:
                            self?.alertMessage = "Проблема с доступом к серверу"
                        default:
                            self?.alertMessage = error.localizedDescription
                    }
                    self?.presentingAlert = true
                } else {
                    self?.fetchInfo()
                }
            }
        }
    }
}
