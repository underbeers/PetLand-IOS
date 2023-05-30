//
//  ProfileViewModel.swift
//  PetLand
//
//  Created by Никита Сигал on 06.05.2023.
//

import Foundation
import PhotosUI
import SwiftUI

extension ProfileView {
    @MainActor final class ProfileViewModel: ObservableObject {
        private var appState: AppState?
        private let userService: UserServiceProtocol = UserService.shared
        private let petService: PetServiceProtocol = PetService.shared
        private let advertService: AdvertServiceProtocol = AdvertService.shared
        private let imageService: ImageServiceProtocol = ImageService.shared

        @Published var user: User = .init() {
            didSet {
                fetchPets()
                fetchAdverts()
            }
        }

        @Published var newProfileImage: PhotosPickerItem? = nil {
            didSet {
                uploadImage()
            }
        }

        @Published var pets: [PetCard] = []
        @Published var advertCardList: AdvertCardList = .init()

        @Published var alertMessage: String = ""
        @Published var presentingAlert: Bool = false

        func setup(_ appState: AppState) {
            self.appState = appState
        }

        func signOut() {
            appState?.signOut()
        }

        func fetchUser() {
            userService.getUser { [weak self] result in
                switch result {
                    case .success(let value):
                        self?.user = value
                    case .failure(let error):
                        switch error {
                            case APIError.unauthorized:
                                self?.alertMessage = "Ошибка авторизации. Зайдите в аккаунт заново."
                            case APIError.serverDown:
                                self?.alertMessage = "Проблема с доступом к серверу"
                            default:
                                self?.alertMessage = error.localizedDescription
                        }
                        self?.presentingAlert = true
                }
            }
        }

        func fetchPets() {
            petService.getPetCards(petID: nil, userID: user.id, typeID: nil, breedID: nil, isMale: nil) { [weak self] result in
                switch result {
                    case .success(let pets):
                        self?.pets = pets
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

        func fetchAdverts() {
            advertService.getAdvertCards(userID: user.id) { [weak self] result in
                switch result {
                    case .success(let cardList):
                        self?.advertCardList = cardList
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

        func uploadImage() {
            Task {
                if let rawData = try? await newProfileImage?.loadTransferable(type: Data.self),
                   let imageData = UIImage(data: rawData)!.jpegData(compressionQuality: 0.1)
                {
                    imageService.uploadUser(imageData) { [weak self] error in
                        if let error {
                            switch error {
                                case APIError.serverDown:
                                    self?.alertMessage = "Проблема с доступом к серверу"
                                default:
                                    self?.alertMessage = error.localizedDescription
                            }
                            self?.presentingAlert = true
                        } else {
                            self?.fetchUser()
                        }
                    }
                }
            }
        }
    }
}
