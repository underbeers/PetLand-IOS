//
//  RegistrationContainerVC.swift
//  PetLand
//
//  Created by Никита Сигал on 12.02.2023.
//

import UIKit

class RegistrationContainerVC: UIViewController {
    @IBOutlet var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .purple
        
        loginButton.titleLabel?.numberOfLines = 0
    }
}
