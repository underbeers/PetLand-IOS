//
//  ProfileViewModel.swift
//  PetLand
//
//  Created by Никита Сигал on 06.05.2023.
//

import Foundation

extension ProfileView {
    @MainActor final class ProfileViewModel: ObservableObject {
        private var appState: AppState? = nil
        private let userService: UserServiceProtocol = UserService.shared

        @Published var user: User = .init()
        @Published var image: String = "icons:profile"

        func setup(_ appState: AppState) {
            self.appState = appState
        }

        func fetchUserInfo() {
            user = .dummy
            image = User.dummyImage
        }
    }
}
