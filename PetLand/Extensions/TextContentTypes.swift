//
//  TextContentTypes.swift
//  PetLand
//
//  Created by Никита Сигал on 17.03.2023.
//

import SwiftUI

enum TextContentType {
    case firstName,
         lastName,
         email,
         phoneNumber,
         password,
         newPassword,
         confirmPassword,
         verificationCode,
         someText(_ placeholder: String),
         someInteger(_ placeholder: String),
         someDecimal(_ placeholder: String),
         custom(_ placeholder: String, validator: ((String) -> String?)?)

    var placeholder: String {
        switch self {
            case .firstName:
                return "Имя"
            case .lastName:
                return "Фамилия"
            case .email:
                return "Email"
            case .phoneNumber:
                return "Номер телефона"
            case .password:
                return "Пароль"
            case .newPassword:
                return "Пароль"
            case .confirmPassword:
                return "Повторите пароль"
            case .verificationCode:
                return "Код"
            case .someText(let placeholder):
                return placeholder
            case .someInteger(let placeholder):
                return placeholder
            case .someDecimal(let placeholder):
                return placeholder
            case .custom(let placeholder, validator: _):
                return placeholder
        }
    }

    var keyboardType: UIKeyboardType {
        switch self {
            case .firstName, .lastName:
                return .namePhonePad
            case .email:
                return .emailAddress
            case .phoneNumber:
                return .phonePad
            case .password, .newPassword, .confirmPassword:
                return .asciiCapable
            case .verificationCode:
                return .numberPad
            case .someText:
                return .default
            case .someInteger:
                return .numberPad
            case .someDecimal:
                return .numbersAndPunctuation
            case .custom:
                return .default
        }
    }

    var contentType: UITextContentType? {
        switch self {
            case .firstName:
                return .givenName
            case .lastName:
                return .familyName
            case .email:
                return .emailAddress
            case .phoneNumber:
                return .telephoneNumber
            case .password:
                return .password
            case .newPassword, .confirmPassword:
                return .newPassword
            case .verificationCode:
                return .oneTimeCode
            default:
                return nil
        }
    }

    var autocapitalization: TextInputAutocapitalization {
        switch self {
            case .email, .password, .newPassword, .confirmPassword:
                return .never
            default:
                return .words
        }
    }

    var shouldBeSecure: Bool {
        switch self {
            case .password, .newPassword, .confirmPassword:
                return true
            default:
                return false
        }
    }
    
    var disableAutocorrection: Bool {
        switch self {
            case .email, .password, .newPassword, .confirmPassword:
                return true
            default:
                return false
        }
    }

    func validate(_ input: String) -> String? {
        ValidationManager.shared.validate(input, as: self)
    }
}
