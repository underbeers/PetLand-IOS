//
//  CustomTextField.swift
//  PetLand
//
//  Created by Никита Сигал on 17.03.2023.
//

import SwiftUI

struct CustomTextField: View {
    private var type: TextContentType
    private var isRequired: Bool

    @State var text: String = ""
    @State var isSecure: Bool = true
    @State private var wasInteractedWith: Bool = false

    private enum Focus: Hashable {
        case secure
        case regular
    }

    @FocusState private var currentFocus: Focus?

    private var error: String? {
        if wasInteractedWith {
            if isRequired && text.isEmpty {
                return "Обязательное поле"
            } else {
                return type.validate(text)
            }
        } else {
            return nil
        }
    }

    private var shadowColor: Color {
        if error != nil {
            return .cRed.opacity(0.25)
        } else if currentFocus != nil {
            return .cGreen.opacity(0.25)
        } else {
            return .black.opacity(0.25)
        }
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
    }

    init(_ type: TextContentType, isRequired: Bool) {
        self.type = type
        self.isRequired = isRequired
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CustomTextField(.email, isRequired: true)
            CustomTextField(.password, isRequired: true)
        }
        .padding()
    }
}