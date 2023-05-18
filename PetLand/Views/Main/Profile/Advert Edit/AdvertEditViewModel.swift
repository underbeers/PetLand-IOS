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

        @Published var advert: AdvertEdit = .init()

        @Published var alertMessage: String = ""
        @Published var presentingAlert: Bool = false

        func commitAdvert(isNew: Bool, _ completion: @escaping () -> () = {}) {
            advert.cityID = 1
            advert.districtID = 1
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
    }
}
