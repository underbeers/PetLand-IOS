//
//  ProfileViewModel.swift
//  PetLand
//
//  Created by Никита Сигал on 06.05.2023.
//

import Foundation
import SwiftUI

extension ProfileView {
    @MainActor final class ProfileViewModel: ObservableObject {
        private var appState: AppState?
        private let userService: UserServiceProtocol = UserService.shared
        private let petService: PetServiceProtocol = PetService.shared

        @Published var user: User = .init() {
            didSet {
                fetchPets()
            }
        }

        @Published var pets: [Pet] = []

        @Published var alertMessage: String = ""
        @Published var presentingAlert: Bool = false

        func setup(_ appState: AppState) {
            self.appState = appState
        }

        func signOut() {
            appState?.signOut()
        }

        func fetchUserInfo() {
            userService.getUserInfo { [weak self] result in
                switch result {
                    case .success(let value):
                        withAnimation {
                            self?.user = value
                        }
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
            petService.getPetInfoGeneral(petID: nil, userID: user.id, petTypeID: nil, breedID: nil, gender: nil) { [weak self] result in
                switch result {
                    case .success(let pets):
                        withAnimation {
                            self?.pets = pets
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
