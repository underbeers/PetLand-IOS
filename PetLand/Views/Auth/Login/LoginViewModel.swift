//
//  LoginViewModel.swift
//  PetLand
//
//  Created by Никита Сигал on 24.03.2023.
//

import SwiftUI

extension LoginView {
    @MainActor class LoginViewModel: ObservableObject {
        private let authManager: AuthManagerProtocol = AuthManager()
        private var appState: AppState? = nil
        
        @Published var email: String = ""
        @Published var password: String = ""
        @Published var staySignedIn: Bool = false
        
        @Published var error: String?        
        @Published var alertMessage: String = ""
        @Published var presentingAlert: Bool = false
        
        func setup(_ appState: AppState) {
            self.appState = appState
        }
        
        func login() {
            authManager.login(email: email, password: password) { [weak self] error in
                if let error {
                    switch error {
                        case APIService.Error.failedWithStatusCode(400):
                            self?.error = "Неправильный логин/пароль"
                        case APIService.Error.failedWithStatusCode(500):
                            self?.error = "Проблемы с доступом к серверу"
                        default:
                            self?.alertMessage = error.localizedDescription
                            self?.presentingAlert = true
                    }
                } else {
                    self?.appState?.setRootScreen(to: .main)
                }
            }
        }
    }
}
