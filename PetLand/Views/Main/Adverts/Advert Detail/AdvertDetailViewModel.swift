//
//  AdvertDetailViewModel.swift
//  PetLand
//
//  Created by Никита Сигал on 17.05.2023.
//

import Foundation

extension AdvertDetailView {
    @MainActor final class AdvertDetailViewModel: ObservableObject {
        private let advertService: AdvertServiceProtocol = AdvertService.shared

        @Published var advert: Advert?

        @Published var alertMessage: String = ""
        @Published var presentingAlert: Bool = false

        func fetchAdvert(id: Int) {
            advertService.getAdvert(id: id) { [weak self] result in
                switch result {
                    case .success(let advert):
                        self?.advert = advert
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
