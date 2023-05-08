//
//  RegistrationPage1.swift
//  PetLand
//
//  Created by Никита Сигал on 12.04.2023.
//

import SwiftUI

struct RegistrationPage1: View {
    // MARK: Environment

    @EnvironmentObject var model: RegistrationView.RegistrationViewModel

    // MARK: Focus

    enum Focusable: Hashable {
        case firstName, lastName
    }

    @FocusState var currentFocus: Focusable?

    // MARK: State

    @State var firstNameIsValid: Bool = false
    @State var lastNameIsValid: Bool = false
    private var canAdvance: Bool {
        firstNameIsValid && lastNameIsValid
    }

    var body: some View {
        VStack {
            Spacer()

            VStack {
                CustomWrapper(isValid: $firstNameIsValid) {
                    CustomTextField(.firstName, text: $model.firstName) {
                        if firstNameIsValid {
                            currentFocus = .lastName
                        }
                    }
                }
                .focused($currentFocus, equals: .firstName)
                CustomWrapper(isValid: $lastNameIsValid) {
                    CustomTextField(.lastName, text: $model.lastName) {
                        if canAdvance {
                            model.nextPage()
                        }
                    }
                }
                .focused($currentFocus, equals: .lastName)
            }
            .padding(.horizontal, 40)

            Spacer()

            Button("Следующий шаг") {
                model.nextPage()
            }
            .buttonStyle(CustomButton(.primary, isEnabled: canAdvance))
            .disabled(!canAdvance)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct RegistrationPage1_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationPage1()
            .environmentObject(RegistrationView.RegistrationViewModel())
    }
}
