//
//  CustomTextField.swift
//  PetLand
//
//  Created by Никита Сигал on 12.01.2023.
//

import UIKit

@IBDesignable
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

    @IBInspectable var isRequired: Bool = false
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
        let bundle = Bundle(for: Self.self)

        guard let view = bundle.loadNibNamed(Self.identifier, owner: self, options: nil)?.first as? UIView
        else { fatalError("Unable to load nib") }

        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        addSubview(view)

        configureUI()
    }

    private func configureUI() {
        visibilityToggle.isHidden = true
        errorLabel.isHidden = true

        textField.layer.cornerRadius = 20
        textField.layer.shadowOffset = .zero
        textField.delegate = self

        // align input with corner curvature
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        textField.rightViewMode = .always

        setShadowBlack()
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
        setShadowRedActive()
        errorLabel.text = error
        errorLabel.isHidden = false
    }

    private func hideError() {
        setShadowGreen()
        errorLabel.isHidden = true
    }

    @IBAction func onEditingBegin() {
        if errorLabel.isHidden {
            setShadowGreen()
        } else {
            setShadowRedActive()
        }
    }

    @IBAction func onEditingEnd() {
        if errorLabel.isHidden {
            setShadowBlack()
        } else {
            setShadowRedPassive()
        }
    }
}

// MARK: Configuration

extension CustomTextField {
    func configure(for type: ContentType) {
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

// MARK: Shadows

extension CustomTextField {
    private func setShadowBlack() {
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowRadius = 5
        textField.layer.shadowOpacity = 0.1
    }

    private func setShadowRedActive() {
        textField.layer.shadowColor = UIColor.cRed.cgColor
        textField.layer.shadowOpacity = 0.85
    }

    private func setShadowRedPassive() {
        textField.layer.shadowColor = UIColor.cRed.cgColor
        textField.layer.shadowOpacity = 0.4
    }

    private func setShadowGreen() {
        textField.layer.shadowColor = UIColor.cGreen.cgColor
        textField.layer.shadowOpacity = 0.85
    }
}

// MARK: TextField Delegate

extension CustomTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return true
    }
}
