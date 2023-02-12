//
//  LoginRouter.swift
//  PetLand
//
//  Created by Никита Сигал on 31.01.2023.
//

import UIKit

class LoginRouter {
    weak var viewController: UIViewController?
}

extension LoginRouter: LoginRoutingLogic {
    func routeToMarketplace() {
        viewController?.performSegue(withIdentifier: "showNavigation", sender: nil)
    }
}
