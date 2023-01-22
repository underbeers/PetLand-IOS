//
//  LoginVC.swift
//  PetLand
//
//  Created by Никита Сигал on 15.01.2023.
//

import UIKit

class LoginVC: UIViewController {
    static let identifier = "Auth.Login"
    
    @IBOutlet var loginTextField: CustomTextField!
    @IBOutlet var passwordTextField: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginTextField.configure(for: .email, required: true)
        passwordTextField.configure(for: .password, required: true)
    }
}
