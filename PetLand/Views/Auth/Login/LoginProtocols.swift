//
//  LoginProtocols.swift
//  PetLand
//
//  Created by Никита Сигал on 31.01.2023.
//

protocol LoginBusinessLogic {
    func login(email: String, password: String)
}

protocol LoginPresentationLogic {
    func presentError(_ error: Error)
}

protocol LoginDisplayLogic: AnyObject {
    func displayError(_ errorDescription: String)
}

protocol LoginRoutingLogic {
    func routeToMarketplace()
}
