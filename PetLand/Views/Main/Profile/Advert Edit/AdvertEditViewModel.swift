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
        @Published var advert: Advert = .init()
    }
}
