//
//  RegistrationPresenter.swift
//  PetLand
//
//  Created by Никита Сигал on 09.03.2023.
//

import Foundation

class RegistrationPresenter {
    weak var viewController: RegistrationDisplayLogic?
}

extension RegistrationPresenter: RegistrationPresentationLogic {
    func presentError(_ error: Error) {
        switch error {
            case APIService.Error.failedWithStatusCode(409):
                viewController?.displayError("Пользователь с такими данными уже существует")
            case APIService.Error.failedWithStatusCode(500):
                viewController?.displayError("Проблемы с доступом к сервису")
            default:
                viewController?.displayError(error.localizedDescription)
        }
    }
    
    func presentNextPage() {
        viewController?.displayNextPage()
    }
}
