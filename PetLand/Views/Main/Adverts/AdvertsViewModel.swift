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

        enum Mode {
            case sold,
                 found
        }

        @Published var currentMode: Mode = .sold {
            didSet {
                fetchAdvertCards()
            }
        }

        @Published var sorting: String = "Сначала новые" {
            didSet {
                fetchAdvertCards()
            }
        }

        @Published var advertList: AdvertCardList = .init()

        @Published var presentingFilters: Bool = false

        @Published var alertMessage: String = ""
        @Published var presentingAlert: Bool = false

        func fetchAdvertCards() {
            advertService.getAdvertCards { [weak self] result in
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
    }
}
