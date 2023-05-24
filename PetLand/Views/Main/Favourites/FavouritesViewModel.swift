//
//  FavouritesViewModel.swift
//  PetLand
//
//  Created by Никита Сигал on 24.05.2023.
//

import Foundation

extension FavouritesView {
    @MainActor final class FavouritesViewModel: ObservableObject {
        private let favouritesService: FavouriteServiceProtocol = FavouriteService.shared
        
        @Published var favourites: Favourites = .init()
        
        enum Mode {
            case adverts,
            specialists,
            organizations
        }
        @Published var currentMode: Mode = .adverts
        
        @Published var alertMessage: String = ""
        @Published var presentingAlert: Bool = false
        
        func fetchFavourites() {
            favouritesService.getFavourites { [weak self] result in
                switch result {
                    case let .success(favourites):
                        self?.favourites = favourites
                    case let .failure(error):
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
