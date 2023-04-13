//
//  OldRegistrationPage3.swift
//  PetLand
//
//  Created by Никита Сигал on 12.02.2023.
//

import UIKit

class OldRegistrationPage3: UIViewController {
    static let id = "Registration.Page3"

    @IBOutlet var newPasswordTF: OldCustomTextField!
    @IBOutlet var confirmPasswordTF: OldCustomTextField!
    @IBOutlet var finishButton: OldCustomButton!

    private var model: RegistrationUserModel?
    private var interactor: RegistrationBusinessLogic?

    override func viewDidLoad() {
        super.viewDidLoad()

        newPasswordTF.configure(for: .newPassword, delegate: self)
        confirmPasswordTF.configure(for: .confirmPassword, delegate: self)
    }

    @IBAction func onNextButtonPress() {
        interactor?.model.password = newPasswordTF.text
        interactor?.register()
    }
}

extension OldRegistrationPage3: RegistrationPageProtocol {
    func configure(interactor: RegistrationBusinessLogic?) {
        self.interactor = interactor
    }
}

extension OldRegistrationPage3: CustomTextFieldDelegate {
    func onEditingChanged() {
        finishButton.isEnabled = newPasswordTF.isValid && confirmPasswordTF.isValid
    }
}
