//
//  RegistrationViewModel.swift
//  PetLand
//
//  Created by Никита Сигал on 12.04.2023.
//

import SwiftUI

extension RegistrationView {
    @MainActor class RegistrationViewModel: ObservableObject {
        private let userService: UserServiceProtocol = UserService.shared
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
            code = ""
            userService.verifyEmail(email: email) { [weak self] error in
                guard let error else { return }
                
                switch error {
                    case APIError.serverDown:
                        self?.error = "Проблемы с доступом к серверу. Попробуйте позже."
                    default:
                        self?.alertMessage = error.localizedDescription
                        self?.presentingAlert = true
                }
            }
        }
        
        func register() {
            userService.register(firstName: firstName,
                                 lastName: lastName,
                                 email: email,
                                 password: newPassword)
            { [weak self] error in
                guard let error else {
                    self?.appState?.setRootScreen(to: .main)
                    return
                }
                
                switch error {
                    case UserServiceError.userAlreadyExists:
                        self?.error = "Аккаунт с этим email уже существует"
                    case APIError.serverDown:
                        self?.error = "Проблемы с доступом к серверу. Попробуйте позже."
                    default:
                        self?.alertMessage = error.localizedDescription
                        self?.presentingAlert = true
                }
            }
        }
    }
}
