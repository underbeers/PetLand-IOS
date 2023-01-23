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
    @IBOutlet var forgotPasswordButton: UIButton!
    @IBOutlet var staySignedInCheckbox: CustomCheckbox!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .cBackground
        
        loginTextField.configure(for: .email, required: true)
        passwordTextField.configure(for: .password, required: true)
        staySignedInCheckbox.configure(label: "Не выходить из аккаунта")
    }
}
