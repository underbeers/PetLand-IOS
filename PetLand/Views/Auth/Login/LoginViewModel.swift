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
        
        @Published var email: String = ""
        @Published var password: String = ""
        @Published var staySignedIn: Bool = false
        
        @Published var emailIsValid: Bool = false
        @Published var passwordIsValid: Bool = false
        @Published var error: String?
        
        @Published var presentingAlert: Bool = false
        @Published var alertMessage: String = ""

        var isValid: Bool {
            emailIsValid && passwordIsValid
        } 
        
        func login(completion: @escaping () -> ()) {
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
                    completion()
                }
            }
        }
    }
}
