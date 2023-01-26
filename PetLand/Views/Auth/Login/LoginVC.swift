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
    @IBOutlet var loginButton: CustomButton!
    @IBOutlet var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .cBackground
        
        loginTextField.configure(for: .email)
        passwordTextField.configure(for: .password)
        
        // must override to show both lines
        registerButton.titleLabel?.numberOfLines = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func forgorPasswordButtonPressed() {
        if let url = URL(string: "http://raezhov.fun") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func loginButtonPressed() {}
    
    @IBAction func registerButtonPressed() {}
}
