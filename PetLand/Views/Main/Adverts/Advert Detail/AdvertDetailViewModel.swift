//
//  AdvertDetailViewModel.swift
//  PetLand
//
//  Created by Никита Сигал on 17.05.2023.
//

import Foundation

extension AdvertDetailView {
    @MainActor final class AdvertDetailViewModel: ObservableObject {
        private let petService: PetServiceProtocol = PetService.shared

        @Published var pet: Pet = .init()

        @Published var alertMessage: String = ""
        @Published var presentingAlert: Bool = false

        func fetchInfoBy(id: Int) {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                self.pet = .dummy
//            }
            
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
    }
}
