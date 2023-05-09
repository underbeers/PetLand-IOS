//
//  ValidationManager.swift
//  PetLand
//
//  Created by Никита Сигал on 12.01.2023.
//

import Foundation

protocol ValidationManagerProtocol {
    func validate(_ input: String, as type: TextContentType) -> String?
    func generateVerificationCode() -> Int
}

class ValidationManager: ValidationManagerProtocol {
    static let shared = ValidationManager()

    private var verificationCode: Int?
    private var newPassword: String?

    func generateVerificationCode() -> Int {
        verificationCode = Int.random(in: 100_000 ... 999_999)
        return verificationCode!
    }

    func validate(_ input: String, as type: TextContentType) -> String? {
        getFunction(for: type)(input)
    }

    private func getFunction(for type: TextContentType) -> (String) -> String? {
        switch type {
            case .firstName, .lastName:
                return isValidName(_:)
            case .email:
                return isValidEmail(_:)
            case .phoneNumber:
                return isValidPhoneNumber(_:)
            case .password, .newPassword:
                return isValidPassword(_:)
            case .confirmPassword:
                return isValidConfirmPassword(_:)
            case .verificationCode:
                return isValidVerificationCode(_:)
            case .someText:
                return isValidText(_:)
            case .someInteger:
                return isValidInteger(_:)
            case .someDecimal:
                return isValidDecimal(_:)
            case .custom(_, let validator):
                return validator ?? { _ in nil }
        }
    }

    private func isValidText(_ input: String) -> String? {
        // TODO: Implement text validation
        return nil
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
        let regex = /[a-zA-Zа-яА-Я \-'‘’]*/
        return regex.check(for: input) ? nil : "Неподдерживаемый символ"
    }

    private func isValidEmail(_ input: String) -> String? {
        let regex = /[A-Za-z0-9._%+-]+@(?:[A-Za-z0-9-]+\.)+[A-Za-z]{2,}/
        return regex.check(for: input) || input.isEmpty ? nil : "Некорректный формат"
    }

    private func isValidPhoneNumber(_ input: String) -> String? {
        // TODO: Implement phone number validation
        return nil
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
        else { return "Как минимум 1 заглавная буква" }

        let digitRegex = /.*[0-9]+.*/
        guard digitRegex.check(for: input)
        else { return "Как минимум 1 цифра" }

        let specialCharacterRegex = /.*[`'‘’".,:;!?@#$%^&*()\[\]\{\}<>\-_+=\\\/]+.*/
        guard specialCharacterRegex.check(for: input)
        else { return "Как минимум 1 специальный символ" }

        newPassword = input
        return nil
    }

    private func isValidConfirmPassword(_ input: String) -> String? {
        return input == newPassword ? nil : "Пароли не совпадают"
    }
}
