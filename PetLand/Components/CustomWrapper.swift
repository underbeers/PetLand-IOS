//
//  CustomWrapper.swift
//  PetLand
//
//  Created by Никита Сигал on 08.05.2023.
//

import SwiftUI

@MainActor final class CustomConfig: ObservableObject {
    @Published var error: String = ""
    @Published var isEmpty: Bool = true
    @Published var isValid: Bool = true
}

struct CustomWrapper<Content: View>: View {
    private let title: String
    private let tip: String
    private let required: Bool
    private let content: Content

    @StateObject private var config: CustomConfig = .init()
    @State private var wasInteractedWith: Bool = false
    @State private var error: String?
    @Binding var isValid: Bool

    init(title: String = "", tip: String = " ", isValid: Binding<Bool>, required: Bool = true, @ViewBuilder _ content: @escaping () -> Content) {
        self.title = title
        self.tip = tip
        self.required = required

        self.content = content()

        self._isValid = isValid
    }

    func validate() {
        if !wasInteractedWith {
            error = nil
        } else if !config.error.isEmpty {
            error = config.error
        } else if required && config.isEmpty {
            error = "Обязательное поле"
        } else {
            error = nil
        }

        isValid = error == nil
        config.isValid = isValid
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if required && !title.isEmpty {
                Text(title)
                    .foregroundColor(.cText)
                    .font(.cTitle4)
                    +
                    Text(" *")
                    .foregroundColor(.cRed)
                    .font(.cTitle4)
            } else {
                Text(title)
                    .foregroundColor(.cText)
                    .font(.cTitle4)
            }
            content
                .environmentObject(config)
            Text(error ?? tip)
                .font(.cSecondary2)
                .foregroundColor(error == nil ? .cBlue300 : .cRed)
        }
        .onTapGesture { wasInteractedWith = true }
        .onChange(of: config.error) { _ in validate() }
        .onChange(of: config.isEmpty) { _ in validate() }
        .onChange(of: wasInteractedWith) { _ in validate() }

        .animation(.default, value: error)
    }
}

private struct CustomWrapper_PreviewContainer: View {
    @State var firstName: String = ""
    @State var email: String = ""
    @State var firstNameIsValid: Bool = false
    @State var emailIsValid: Bool = false

    var body: some View {
        VStack {
            CustomWrapper(title: "Имя", tip: "Введите ваше имя", isValid: $firstNameIsValid, required: false) {
                CustomTextField(.firstName, text: $firstName)
            }

            CustomWrapper(title: "Почта", tip: "Введите адрес вашей электронной почты", isValid: $emailIsValid, required: true) {
                CustomTextField(.email, text: $email)
            }
        }
        .padding()
    }
}

struct CustomWrapper_Previews: PreviewProvider {
    static var previews: some View {
        CustomWrapper_PreviewContainer()
    }
}
