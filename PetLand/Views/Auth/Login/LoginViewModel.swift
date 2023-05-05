//
//  LoginViewModel.swift
//  PetLand
//
//  Created by Никита Сигал on 24.03.2023.
//

import SwiftUI

extension LoginView {
    @MainActor class LoginViewModel: ObservableObject {
        private let userService: UserServiceProtocol = UserService.shared
        private var appState: AppState? = nil
        
        @Published var email: String = ""
        @Published var password: String = ""
        @Published var stayLoggedIn: Bool = false
        
        @Published var error: String?
        @Published var alertMessage: String = ""
        @Published var presentingAlert: Bool = false
        
        func setup(_ appState: AppState) {
            self.appState = appState
        }
        
        func login() {
            userService.login(user: email, password: password, stayLoggedIn: stayLoggedIn) { [weak self] error in
                guard let error else {
                    self?.appState?.setRootScreen(to: .main)
                    return
                }
                
                switch error {
                    case UserServiceError.wrongCredentials:
                        self?.error = "Неправильный логин/пароль"
                    case UserServiceError.serverDown:
                        self?.error = "Проблемы с доступом к серверу. Попробуйте позже."
                    default:
                        self?.alertMessage = error.localizedDescription
                        self?.presentingAlert = true
                }
            }
        }
    }
}
