//
//  LoginInteractor.swift
//  PetLand
//
//  Created by Никита Сигал on 31.01.2023.
//

import Foundation

class LoginInteractor {
    var presenter: LoginPresentationLogic?
    var router: LoginRoutingLogic?
    private let authManager: AuthManagerProtocol = AuthManager.shared
}

extension LoginInteractor: LoginBusinessLogic {
    func login(email: String, password: String) {
        authManager.login(email: email, password: password) { [weak self] error in
            if let error {
                self?.presenter?.presentError(error)
            } else {
                self?.router?.routeToMarketplace()
            }
        }
    }
}
