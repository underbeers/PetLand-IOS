//
//  PetDetailViewModel.swift
//  PetLand
//
//  Created by Никита Сигал on 10.05.2023.
//

import Foundation
import SwiftUI

extension PetDetailView {
    @MainActor final class PetDetailViewModel: ObservableObject {
        private let petService: PetServiceProtocol = PetService.shared

        @Published var pet: Pet = .init()

        @Published var alertMessage: String = ""
        @Published var presentingAlert: Bool = false

        func fetchInfoBy(id: Int) {
            petService.getPets(petID: id, userID: nil, typeID: nil, breedID: nil, isMale: nil) { [weak self] result in
                switch result {
                    case .success(let pets):
                        self?.pet = pets[0]
                    case .failure(let error):
                        switch error {
                            case APIError.serverDown:
                                self?.alertMessage = "Проблемы с доступом к серверу"
                            default:
                                self?.alertMessage = error.localizedDescription
                        }
                        self?.presentingAlert = true
                }
            }
        }

        func delete(completion: @escaping () -> ()) {
            petService.deletePet(petID: pet.id) { [weak self] error in
                if let error {
                    switch error {
                        case APIError.serverDown:
                            self?.alertMessage = "Проблемы с доступом к серверу"
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
