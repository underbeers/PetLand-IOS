//
//  CustomTextField.swift
//  PetLand
//
//  Created by Никита Сигал on 17.03.2023.
//

import SwiftUI

struct CustomTextField: View {
    // MARK: Configurtation

    @EnvironmentObject var config: CustomConfig
    private let type: TextContentType
    private let onSubmitHandler: ()->()

    // MARK: Focus

    private enum Focusable: Hashable {
        case secure
        case regular
    }

    @FocusState private var currentFocus: Focusable?

    // MARK: State

    @Binding var text: String
    @State private var isSecure: Bool = true

    init(_ type: TextContentType, text: Binding<String>, onSubmit: @escaping ()->() = {}) {
        self.type = type
        self._text = text
        self.onSubmitHandler = onSubmit
    }

    // MARK: Computed

    private var shadowColor: Color {
        if !config.isValid {
            return .cRed.opacity(0.25)
        } else if currentFocus != nil {
            return .cGreen.opacity(0.25)
        } else {
            return .black.opacity(0.25)
        }
    }

    private func validate() {
        config.isEmpty = text.isEmpty
        config.error = type.validate(text) ?? ""
    }

    // MARK: Body

    var body: some View {
        HStack {
            ZStack {
                TextField(type.placeholder, text: $text)
                    .opacity(type.shouldBeSecure && isSecure ? 0 : 1)
                    .focused($currentFocus, equals: .regular)

                SecureField(type.placeholder, text: $text)
                    .allowsHitTesting(type.shouldBeSecure && isSecure)
                    .opacity(type.shouldBeSecure && isSecure ? 1 : 0)
                    .focused($currentFocus, equals: .secure)
            }
            .onSubmit(onSubmitHandler)
            .textContentType(type.contentType)
            .keyboardType(type.keyboardType)
            .textInputAutocapitalization(type.autocapitalization)
            .autocorrectionDisabled(type.disableAutocorrection)
            .font(.cMain)
            .foregroundColor(.cText)

            if type.shouldBeSecure {
                Button(action: {
                    isSecure.toggle()
                    currentFocus = isSecure ? .secure : .regular
                }, label: {
                    Image(isSecure
                        ? "icons:eye:closed"
                        : "icons:eye:opened")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.black)
                        .frame(width: 20, height: 20)
                })
            }
        }
        .padding(12)
        .background(.white)
        .cornerRadius(12)
        .shadow(color: shadowColor, radius: 6, x: 4, y: 4)

        .onChange(of: text) { _ in validate() }
        .onChange(of: currentFocus) { _ in validate() }
        .onDisappear { currentFocus = nil }

        .animation(.default, value: config.isValid)
        .animation(.default, value: isSecure)
    }
}

private struct CustomTextField_PreviewContainer: View {
    @State var email: String = ""
    @State var password: String = ""

    @State var emailIsValid: Bool = false
    @State var passwordIsValid: Bool = false

    var body: some View {
        VStack(spacing: 16) {
            CustomWrapper(isValid: $emailIsValid) {
                CustomTextField(.email, text: $email)
            }
            CustomWrapper(title: "Пароль", tip: "Введите ваш пароль", isValid: $emailIsValid) {
                CustomTextField(.password, text: $password)
            }
        }
        .padding()
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField_PreviewContainer()
    }
}
