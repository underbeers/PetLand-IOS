//
//  NewPetViewModel.swift
//  PetLand
//
//  Created by Никита Сигал on 08.05.2023.
//

import Foundation
import SwiftUI

extension NewPetView {
    @MainActor final class NewPetViewModel: ObservableObject {
        private let petService: PetServiceProtocol = PetService.shared
        
        @Published var pet: Pet = .init()
        @Published var birthday: Date = .now
        
        @Published var types: [PetType] = []
        @Published var breeds: [PetBreed] = []
        
        @Published var alertMessage: String? = ""
        @Published var presentingAlert: Bool = false
        
        func createPet() {
            petService.createPet(pet: pet) { [weak self] error in
                if let error {
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
        
        func restoreTypeID() {
            pet.typeID = types.first(where: { $0.type == pet.type })?.id ?? 0
        }
        
        func restoreBreedID() {
            pet.breedID = breeds.first(where: { $0.breed == pet.breed })?.id ?? 0
        }
        
        func restoreGender() {
            pet.isMale = pet.gender == "Мальчик"
        }
        
        func restoreBirthday() {
            pet.birthday = birthday.ISO8601Format()
        }
        
        func fetchTypes() {
            restoreGender()
            restoreBirthday()
            petService.getTypes(typeID: nil, type: nil) { [weak self] result in
                switch result {
                    case .success(let types):
                        withAnimation {
                            self?.types = types
                        }
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
            petService.getBreeds(typeID: pet.typeID, breedID: nil, breed: nil) { [weak self] result in
                switch result {
                    case .success(let breeds):
                        withAnimation {
                            self?.breeds = breeds
                        }
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
