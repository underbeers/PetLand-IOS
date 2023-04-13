//
//  RegistrationViewModel.swift
//  PetLand
//
//  Created by Никита Сигал on 12.04.2023.
//

import SwiftUI

extension RegistrationView {
    @MainActor class RegistrationViewModel: ObservableObject {
        private let authManager: AuthManagerProtocol = AuthManager.shared
        private var appState: AppState? = nil
        
        @Published var page: Int = 0
        
        @Published var firstName: String = ""
        @Published var lastName: String = ""
        
        @Published var email: String = ""
        @Published var code: String = ""
        
        @Published var newPassword: String = ""
        @Published var confirmPassword: String = ""
        
        @Published var error: String?
        @Published var alertMessage: String = ""
        @Published var presentingAlert: Bool = false
        
        func setup(_ appState: AppState) {
            self.appState = appState
        }
        
        func nextPage() {
            withAnimation {
                page += 1
            }
        }
        
        func sendVerificationCode() {
            authManager.verifyEmail(email: email) { [weak self] error in
                if let error {
                    switch error {
                        case APIService.Error.failedWithStatusCode(500):
                            self?.error = "Проблемы с доступом к серверу. Попробуйте позже."
                        default:
                            self?.alertMessage = error.localizedDescription
                            self?.presentingAlert = true
                    }
                }
            }
        }
        
        func register() {
            authManager.register(firstname: firstName,
                                 lastname: lastName,
                                 email: email,
                                 password: newPassword,
                                 phoneNumber: nil)
            { [weak self] error in
                if let error {
                    switch error {
                        case APIService.Error.failedWithStatusCode(500):
                            self?.error = "Проблемы с доступом к серверу. Попробуйте позже."
                        case APIService.Error.failedWithStatusCode(400):
                            self?.error = "Аккаунт с этим email уже существует"
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
