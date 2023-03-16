//
//  RegistrationRouter.swift
//  PetLand
//
//  Created by Никита Сигал on 09.03.2023.
//

import UIKit

class RegistrationRouter {
    weak var viewContoller: UIViewController?
}

extension RegistrationRouter: RegistrationRoutingLogic {
    func routeToNavigation() {
        viewContoller?.performSegue(withIdentifier: "showNavigation", sender: nil)
    }    
}
