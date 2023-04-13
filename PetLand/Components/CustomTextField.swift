//
//  CustomTextField.swift
//  PetLand
//
//  Created by Никита Сигал on 17.03.2023.
//

import SwiftUI

struct CustomTextField: View {
    // MARK: Configurtation

    private var type: TextContentType
    private var isRequired: Bool

    // MARK: State

    private enum Focus: Hashable {
        case secure
        case regular
    }

    @FocusState private var currentFocus: Focus?
    @Binding var text: String
    @Binding var isValid: Bool
    @State private var isSecure: Bool = true
    @State private var wasInteractedWith: Bool = false
    @State private var error: String?

    private var shadowColor: Color {
        if error != nil {
            return .cRed.opacity(0.25)
        } else if currentFocus != nil {
            return .cGreen.opacity(0.25)
        } else {
            return .black.opacity(0.25)
        }
    }
    
    private func validate() {
        // Update error
        if !wasInteractedWith {
            error = nil
        } else if isRequired && text.isEmpty {
            error = "Обязательное поле"
        } else {
            error = type.validate(text)
        }
        
        // Update isValid
        if error != nil || isRequired && text.isEmpty {
            isValid = false
        } else {
            isValid = true
        }
    }

    init(_ type: TextContentType, text: Binding<String>, isValid: Binding<Bool>, isRequired: Bool = false) {
        self.type = type
        self._text = text
        self._isValid = isValid
        self.isRequired = isRequired
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ZStack {
                    TextField(type.placeholder, text: $text,
                              onEditingChanged: { _ in wasInteractedWith = true })
                        .opacity(type.shouldBeSecure && isSecure ? 0 : 1)
                        .focused($currentFocus, equals: .regular)

                    SecureField(type.placeholder, text: $text)
                        .opacity(type.shouldBeSecure && isSecure ? 1 : 0)
                        .focused($currentFocus, equals: .secure)
                        .onTapGesture { wasInteractedWith = true }
                }
                .textContentType(type.contentType)
                .keyboardType(type.keyboardType)
                .textInputAutocapitalization(type.autocapitalization)
                .autocorrectionDisabled(type.disableAutocorrection)
                .font(.cMain)
                .foregroundColor(.cText)
                .frame(height: 44)

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
            .padding(.horizontal, 12)
            .background(RoundedRectangle(cornerRadius: 12)
                .fill(.white)
                .shadow(color: shadowColor, radius: 6, x: 4, y: 4))

            Text(error ?? " ")
                .opacity(error == nil ? 0 : 1)
                .font(.cSecondary2)
                .foregroundColor(.cRed)
        }
        .onChange(of: text) {_ in validate() }
        .onChange(of: currentFocus) {_ in validate() }
    }
}

private struct CustomTextField_Example: View {
    @State var email: String = ""
    @State var password: String = ""

    @State var emailIsValid: Bool = false
    @State var passwordIsValid: Bool = false

    var body: some View {
        VStack {
            CustomTextField(.email, text: $email, isValid: $emailIsValid, isRequired: true)
            CustomTextField(.password, text: $password, isValid: $passwordIsValid, isRequired: true)
        }
        .padding()
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField_Example()
    }
}
