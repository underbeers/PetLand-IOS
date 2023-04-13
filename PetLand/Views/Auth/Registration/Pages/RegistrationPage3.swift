//
//  RegistrationPage3.swift
//  PetLand
//
//  Created by Никита Сигал on 12.04.2023.
//

import SwiftUI

struct RegistrationPage3: View {
    @EnvironmentObject var model: RegistrationView.RegistrationViewModel
    @State var newPassworsIsValid: Bool = false
    @State var confirmPasswordIsValid: Bool = false
    @State var agreedToTOS: Bool = false

    var body: some View {
        GeometryReader { metrics in
            VStack {
                Spacer()

                VStack {
                    CustomTextField(.newPassword, text: $model.newPassword, isValid: $newPassworsIsValid, isRequired: true)
                    CustomTextField(.confirmPassword, text: $model.confirmPassword, isValid: $confirmPasswordIsValid, isRequired: true)
                    Toggle("Согласие с пользовательским соглашением", isOn: $agreedToTOS)
                        .toggleStyle(CustomCheckbox())
                }
                .frame(width: 0.75 * metrics.size.width)

                Spacer()

                Text(model.error ?? " ")
                    .opacity(model.error != nil ? 1 : 0)
                    .font(.cSecondary1)
                    .foregroundColor(.cRed500)
                
                Button("Создать аккаунт") {
                    model.register()
                }
                .buttonStyle(CustomButton(.primary, isEnabled: newPassworsIsValid && confirmPasswordIsValid && agreedToTOS))
                .disabled(!newPassworsIsValid || !confirmPasswordIsValid || !agreedToTOS)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct RegistrationPage3_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationPage3()
            .environmentObject(RegistrationView.RegistrationViewModel())
    }
}
