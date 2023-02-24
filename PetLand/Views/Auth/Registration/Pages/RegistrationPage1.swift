//
//  RegistrationPage1.swift
//  PetLand
//
//  Created by Никита Сигал on 12.02.2023.
//

import UIKit

class RegistrationPage1: UIViewController {
    static let id = "Registration.Page1"

    @IBOutlet var firstNameTF: CustomTextField!
    @IBOutlet var lastNameTF: CustomTextField!
    @IBOutlet var nextButton: CustomButton!

    private var completion: (() -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()

        firstNameTF.configure(for: .firstName, delegate: self)
        lastNameTF.configure(for: .lastName, delegate: self)
    }

    @IBAction func onNextButtonPress() {
        completion?()
    }
}

extension RegistrationPage1: RegistrationPageProtocol {
    func configure(_ completion: @escaping () -> ()) {
        self.completion = completion
    }
}

extension RegistrationPage1: CustomTextFieldDelegate {
    func onEditingChanged() {
        nextButton.isEnabled = firstNameTF.isValid && lastNameTF.isValid
    }
}
