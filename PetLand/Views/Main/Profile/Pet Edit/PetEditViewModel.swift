//
//  PetEditViewModel.swift
//  PetLand
//
//  Created by Никита Сигал on 08.05.2023.
//

import Foundation
import PhotosUI
import SwiftUI

extension PetEditView {
    @MainActor final class PetEditViewModel: ObservableObject {
        private let petService: PetServiceProtocol = PetService.shared
        private let imageService: ImageService = .shared
        
        @Published var pet: Pet = .init()
        
        @Published var images: [PhotosPickerItem] = []
        
        @Published var types: [PetType] = []
        @Published var breeds: [PetBreed] = []
        
        @Published var alertMessage: String = ""
        @Published var presentingAlert: Bool = false
        
        func commitPet(isNew: Bool, _ completion: @escaping () -> ()) {
            restoreBreedID()
            restoreGender()
            petService.commitPet(pet: pet, isNew: isNew) { [weak self] error in
                if let error {
                    switch error {
                        case APIError.serverDown:
                            self?.alertMessage = "Проблема с доступом к серверу"
                        default:
                            self?.alertMessage = error.localizedDescription
                    }
                    self?.presentingAlert = true
                } else {
                    if isNew {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self?.getPet()
                        }
                    }
                    completion()
                }
            }
        }
        
        func restoreTypeID() {
            pet.typeID = types.first(where: { $0.type == pet.type })?.id ?? pet.typeID
        }
        
        func restoreBreedID() {
            pet.breedID = breeds.first(where: { $0.breed == pet.breed })?.id ?? pet.breedID
        }
        
        func restoreGender() {
            pet.isMale = pet.gender == "Мальчик"
        }
        
        func fetchTypes() {
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
            restoreTypeID()
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
        
        func getPet() {
            petService.getPets(petID: nil, userID: nil, typeID: nil, breedID: nil, isMale: nil) { [self] result in
                switch result {
                    case .success(let pets):
                        if let id = pets.sorted(by: { $0.id < $1.id }).last?.id {
                            self.pet.id = id
                            self.uploadImages()
                        }
                    case .failure:
                        break
                }
            }
        }
        
        func uploadImages() {
            images.forEach { image in
                Task {
                    if let rawData = try? await image.loadTransferable(type: Data.self),
                       let imageData = UIImage(data: rawData)!.jpegData(compressionQuality: 0.1)
                    {
                        imageService.uploadPet(imageData, id: pet.id) { _ in }
                    }
                }
            }
        }
    }
}
