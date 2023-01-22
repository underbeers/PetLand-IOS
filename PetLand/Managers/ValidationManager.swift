//
//  ValidationManager.swift
//  PetLand
//
//  Created by Никита Сигал on 12.01.2023.
//

import Foundation

enum ValidationType {
    case integer,
         decimal,
         name,
         email,
         verificationCode,
         phoneNumber,
         password,
         confirmPassword
}

protocol ValidationManagerProtocol {
    func validate(_ input: String, as type: ValidationType?) -> String?
}

class ValidationManager: ValidationManagerProtocol {
    static let shared = ValidationManager()

    private var verificationCode: Int?
    private var newPassword: String?

    func validate(_ input: String, as type: ValidationType?) -> String? {
        getFunction(for: type)(input)
    }

    private func getFunction(for type: ValidationType?) -> (String) -> String? {
        switch type {
            case .integer: return isValidInteger(_:)
            case .decimal: return isValidDecimal(_:)
            case .name: return isValidName(_:)
            case .email: return isValidEmail(_:)
            case .password: return isValidPassword(_:)
            case .confirmPassword: return isValidConfirmPassword(_:)
            default: return { _ in nil }
        }
    }

    private func isValidInteger(_ input: String) -> String? {
        if let _ = Int(input) { return nil }
        else { return "Должно быть целым числом" }
    }

    private func isValidDecimal(_ input: String) -> String? {
        if let _ = Double(input) { return nil }
        else { return "Должно быть числом" }
    }
    
    private func isValidName(_ input: String) -> String? {
        let regex = /[a-zA-Zа-яА-Я \-'‘’]/
        return regex.check(for: input) ? nil : "Неподдерживаемый символ"
    }

    private func isValidEmail(_ input: String) -> String? {
        let regex = /[A-Za-z0-9._%+-]+@(?:[A-Za-z0-9-]+\.)+[A-Za-z]{2,}/
        return regex.check(for: input) ? nil : "Некорректный формат"
    }

    private func isValidVerificationCode(_ input: String) -> String? {
        if let error = isValidInteger(input) {
            return error
        }

        if let verificationCode,
           let trueCode = Int(input),
           trueCode == verificationCode
        { return nil }
        else { return "Неправильный код" }
    }

    private func isValidPassword(_ input: String) -> String? {
        let characterRegex = /[a-zA-Z0-9`'‘’".,:;!?@#$%^&*()\[\]\{\}<>\-+=_\\\/]*/
        guard characterRegex.check(for: input)
        else { return "Неподдерживаемый символ" }
        
        guard input.count >= 8
        else { return "Не меньше 8 символов" }
        
        let uppercaseRegex = /.*[A-Z]+.*/
        guard uppercaseRegex.check(for: input)
        else {return "Как минимум 1 заглавная буква"}
        
        let digitRegex = /.*[0-9]+.*/
        guard digitRegex.check(for: input)
        else {return "Как минимум 1 цифра"}
        
        let specialCharacterRegex = /.*[`'‘’".,:;!?@#$%^&*()\[\]\{\}<>\-_+=\\\/]+.*/
        guard specialCharacterRegex.check(for: input)
        else {return "Как минимум 1 специальный символ"}
        
        newPassword = input
        return nil
    }

    private func isValidConfirmPassword(_ input: String) -> String? {
        return input == newPassword ? nil : "Пароли не совпадают"
    }
}
