//
//  RegistrationInteractor.swift
//  PetLand
//
//  Created by Никита Сигал on 09.03.2023.
//

import Foundation

class RegistrationInteractor {
    var model: RegistrationUserModel = .init()
    var presenter: RegistrationPresentationLogic?
    var router: RegistrationRoutingLogic?
    private let authManager: AuthManagerProtocol = AuthManager.shared
}

extension RegistrationInteractor: RegistrationBusinessLogic {
    func verifyEmail(email: String) {
        authManager.verifyEmail(email: email) { [weak self] error in
            if let error {
                self?.presenter?.presentError(error)
            }
        }
    }

    func register() {
        guard let firstName = model.firstName,
              let lastName = model.lastName,
              let email = model.email,
              let password = model.password
        else { return }

        authManager.register(firstname: firstName,
                             lastname: lastName,
                             email: email,
                             password: password,
                             phoneNumber: nil)
        { [weak self] error in
            if let error {
                self?.presenter?.presentError(error)
            } else {
                self?.login(email: email, password: password)
            }
        }
    }

    func advancePage() {
        presenter?.presentNextPage()
    }

    private func login(email: String, password: String) {
        authManager.login(email: email, password: password) { [weak self] error in
            if let error {
                self?.presenter?.presentError(error)
            } else {
                self?.router?.routeToNavigation()
            }
        }
    }
}
