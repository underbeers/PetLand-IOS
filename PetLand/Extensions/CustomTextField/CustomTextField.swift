//
//  CustomTextField.swift
//  PetLand
//
//  Created by Никита Сигал on 12.01.2023.
//

import UIKit

class CustomTextField: UIView {
    static let identifier = "CustomTextField"

    // MARK: Outlets

    @IBOutlet var textField: UITextField!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var visibilityToggle: UIButton!

    // MARK: Internal vars

    enum ContentType {
        case firstName,
             lastName,
             email,
             verificationCode,
             phoneNumber,
             password,
             newPassword,
             confirmPassword,
             custom(placeholder: String)
    }

    private var isRequired: Bool = false
    private var isSecure: Bool = true
    private var contentType: ContentType?
    private var validationType: ValidationType?

    private let validationManager: ValidationManagerProtocol = ValidationManager.shared

    // MARK: Setup

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        let nib = UINib(nibName: CustomTextField.identifier, bundle: nil)
        guard let view = nib.instantiate(withOwner: self).first as? UIView
        else { fatalError("Unable to convert nib") }

        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        addSubview(view)

        visibilityToggle.isHidden = true
        errorLabel.isHidden = true

        textField.layer.cornerRadius = 20

        textField.layer.shadowColor = UIColor.cGreen.cgColor
        textField.layer.shadowOffset = .zero
        textField.layer.shadowRadius = 2.5
        textField.layer.shadowOpacity = 0

        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        textField.rightViewMode = .always
    }

    // MARK: Actions

    @IBAction func onEdtingChanged() {
        guard let text = textField.text
        else { return }

        if text.isEmpty {
            if isRequired {
                displayError("Обязательное поле")
            } else {
                hideError()
            }
        } else if let error = validationManager.validate(text, as: validationType) {
            displayError(error)
        } else {
            hideError()
        }
    }

    @IBAction func onVisibilityTogglePress() {
        isSecure.toggle()
        textField.isSecureTextEntry = isSecure
        visibilityToggle.setImage(
            UIImage(named: isSecure
                ? "icons:eye-closed"
                : "icons:eye-open")!
                .withTintColor(UIColor.cText),
            for: .normal)
    }

    private func displayError(_ error: String) {
        textField.layer.shadowColor = UIColor.cRed.cgColor
        errorLabel.text = error
        errorLabel.isHidden = false
    }

    private func hideError() {
        textField.layer.shadowColor = UIColor.cGreen.cgColor
        errorLabel.isHidden = true
    }
    
    @IBAction func onEditingBegin() {
        if errorLabel.isHidden {
            textField.layer.shadowOpacity = 1
        }
    }
    
    @IBAction func onEditingEnd() {
        if errorLabel.isHidden {
            textField.layer.shadowOpacity = 0
        }
    }
}

// MARK: Configuration

extension CustomTextField {
    func configure(for type: ContentType,
                   required: Bool = false)
    {
        isRequired = required
        switch type {
            case .firstName:
                validationType = .name
                textField.placeholder = "Имя"
                textField.textContentType = .givenName
            case .lastName:
                validationType = .name
                textField.placeholder = "Фамилия"
                textField.textContentType = .familyName
            case .verificationCode:
                validationType = .verificationCode
                textField.placeholder = "Код"
                textField.textContentType = .oneTimeCode
                textField.keyboardType = .numberPad
            case .email:
                validationType = .email
                textField.placeholder = "Email"
                textField.textContentType = .emailAddress
                textField.keyboardType = .emailAddress
                textField.autocorrectionType = .no
            case .phoneNumber:
                validationType = .phoneNumber
                textField.placeholder = "Номер телефона"
                textField.textContentType = .telephoneNumber
                textField.keyboardType = .namePhonePad
            case .password:
                validationType = .password
                textField.placeholder = "Пароль"
                textField.textContentType = .password
                textField.keyboardType = .asciiCapable
                visibilityToggle.isHidden = false
                textField.isSecureTextEntry = true
            case .newPassword:
                validationType = .password
                textField.placeholder = "Пароль"
                textField.textContentType = .newPassword
                textField.keyboardType = .asciiCapable
                visibilityToggle.isHidden = false
                textField.isSecureTextEntry = true
            case .confirmPassword:
                validationType = .confirmPassword
                textField.placeholder = "Повторите пароль"
                textField.textContentType = .newPassword
                textField.keyboardType = .asciiCapable
                visibilityToggle.isHidden = false
                textField.isSecureTextEntry = true
            case .custom(placeholder: let text):
                textField.placeholder = text
                validationType = .none
        }
    }
}


extension CustomTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
