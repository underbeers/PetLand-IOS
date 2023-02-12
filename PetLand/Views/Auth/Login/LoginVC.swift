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
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var loginButton: CustomButton!
    @IBOutlet var registerButton: UIButton!
    
    private var interactor: LoginBusinessLogic?
    private var router: LoginRoutingLogic?
    
    private func setup() {
        let viewController = self
        let interactor = LoginInteractor()
        let presenter = LoginPresenter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        
        let router = LoginRouter()
        interactor.router = router
        viewController.router = router
        router.viewController = viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        view.backgroundColor = .cBackground
        
        loginTextField.configure(for: .email, delegate: self)
        passwordTextField.configure(for: .password, delegate: self)
        
        // must override to show both lines
        registerButton.titleLabel?.numberOfLines = 0
        errorLabel.numberOfLines = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @IBAction func forgotPasswordButtonPressed() {
        if let url = URL(string: "http://raezhov.fun") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func loginButtonPressed() {
        interactor?.login(email: loginTextField.text, password: passwordTextField.text)
    }
    
    @IBAction func registerButtonPressed() {}
}

extension LoginVC: LoginDisplayLogic {
    func displayError(_ errorDescription: String) {
        errorLabel.text = errorDescription
        errorLabel.isHidden = false
    }
}

extension LoginVC: CustomTextFieldDelegate {
    internal func onEditingChanged() {
        errorLabel.isHidden = true
        
        if loginTextField.isValid,
           passwordTextField.isValid
        {
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
        }
    }
}
