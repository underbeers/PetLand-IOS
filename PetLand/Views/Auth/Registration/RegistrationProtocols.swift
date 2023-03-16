//
//  RegistrationProtocols.swift
//  PetLand
//
//  Created by Никита Сигал on 09.03.2023.
//

import Foundation

struct RegistrationUserModel {
    var firstName: String?
    var lastName: String?
    var email: String?
    var password: String?
}

protocol RegistrationBusinessLogic {
    var model: RegistrationUserModel { get set }
    func verifyEmail(email: String, code: Int)
    func register()
    func advancePage()
}

protocol RegistrationPresentationLogic {
    func presentError(_ error: Error)
    func presentNextPage()
}

protocol RegistrationDisplayLogic: AnyObject {
    func displayError(_ errorDescription: String)
    func displayNextPage()
}

protocol RegistrationRoutingLogic {
    func routeToNavigation()
}
