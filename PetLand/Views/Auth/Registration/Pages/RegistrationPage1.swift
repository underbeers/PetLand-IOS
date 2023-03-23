//
//  RegistrationPage1.swift
//  PetLand
//
//  Created by Никита Сигал on 12.02.2023.
//

import UIKit

class RegistrationPage1: UIViewController {
    static let id = "Registration.Page1"

    @IBOutlet var firstNameTF: OldCustomTextField!
    @IBOutlet var lastNameTF: OldCustomTextField!
    @IBOutlet var nextButton: OldCustomButton!

    private var model: RegistrationUserModel?
    private var interactor: RegistrationBusinessLogic?

    override func viewDidLoad() {
        super.viewDidLoad()

        firstNameTF.configure(for: .firstName, delegate: self)
        lastNameTF.configure(for: .lastName, delegate: self)
    }

    @IBAction func onNextButtonPress() {
        interactor?.model.firstName = firstNameTF.text
        interactor?.model.lastName = lastNameTF.text
        interactor?.advancePage()
    }
}

extension RegistrationPage1: RegistrationPageProtocol {
    func configure(interactor: RegistrationBusinessLogic?) {
        self.interactor = interactor
    }
}

extension RegistrationPage1: CustomTextFieldDelegate {
    func onEditingChanged() {
        nextButton.isEnabled = firstNameTF.isValid && lastNameTF.isValid
    }
}
