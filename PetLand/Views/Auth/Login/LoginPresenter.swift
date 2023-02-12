//
//  LoginPresenter.swift
//  PetLand
//
//  Created by Никита Сигал on 31.01.2023.
//

import Foundation


class LoginPresenter {
    weak var viewController: LoginDisplayLogic?
}

extension LoginPresenter: LoginPresentationLogic {
    func presentError(_ error: Error) {
        var description: String
        switch error {
            case APIService.Error.failedWithStatusCode(400):
                description = "Неправильный логин/пароль"
            case APIService.Error.failedWithStatusCode(500):
                description = "Проблемы с доступом к серверу"
            default:
                description = error.localizedDescription
        }
        viewController?.displayError(description)
    }
}
