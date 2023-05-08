//
//  RegistrationPage3.swift
//  PetLand
//
//  Created by Никита Сигал on 12.04.2023.
//

import SwiftUI

struct RegistrationPage3: View {
    @EnvironmentObject var model: RegistrationView.RegistrationViewModel
    
    private enum Focusable: Hashable {
        case newPassword, confirmPassword
    }
    @FocusState private var currentFocus: Focusable?
    
    @State private var newPassworsIsValid: Bool = false
    @State private var confirmPasswordIsValid: Bool = false
    @State private var agreedToTOS: Bool = false
    
    private var canRegister: Bool {
        newPassworsIsValid && confirmPasswordIsValid && agreedToTOS
    }

    var body: some View {
        VStack {
            Spacer()

            VStack(alignment: .leading) {
                CustomWrapper(isValid: $newPassworsIsValid) {
                    CustomTextField(.newPassword, text: $model.newPassword) {
                        if newPassworsIsValid {
                            currentFocus = .confirmPassword
                        }
                    }
                }
                .focused($currentFocus, equals: .newPassword)
                CustomWrapper(isValid: $confirmPasswordIsValid )  {
                    CustomTextField(.confirmPassword, text: $model.confirmPassword)
                }
                    .focused($currentFocus, equals: .confirmPassword)
                Toggle("Согласие с пользовательским соглашением", isOn: $agreedToTOS)
                    .toggleStyle(CustomCheckbox())
            }
            .padding(.horizontal, 40)

            Spacer()

            Text(model.error ?? " ")
                .opacity(model.error != nil ? 1 : 0)
                .font(.cSecondary1)
                .foregroundColor(.cRed500)

            Button("Создать аккаунт") {
                model.register()
            }
            .buttonStyle(CustomButton(.primary, isEnabled: canRegister))
            .disabled(!canRegister)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onDisappear {
            currentFocus = nil
        }
    }
}

struct RegistrationPage3_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationPage3()
            .environmentObject(RegistrationView.RegistrationViewModel())
    }
}
