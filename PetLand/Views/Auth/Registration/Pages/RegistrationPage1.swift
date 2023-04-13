//
//  RegistrationPage1.swift
//  PetLand
//
//  Created by Никита Сигал on 12.04.2023.
//

import SwiftUI

struct RegistrationPage1: View {
    @EnvironmentObject var model: RegistrationView.RegistrationViewModel
    @State var firstNameIsValid: Bool = false
    @State var lastNameIsValid: Bool = false

    var body: some View {
        GeometryReader { metrics in
            VStack {
                Spacer()

                VStack {
                    CustomTextField(.firstName, text: $model.firstName, isValid: $firstNameIsValid, isRequired: true)
                    CustomTextField(.lastName, text: $model.lastName, isValid: $lastNameIsValid, isRequired: true)
                }
                .frame(width: 0.75 * metrics.size.width)

                Spacer()

                Button("Следующий шаг") {
                    model.nextPage()
                }
                .buttonStyle(CustomButton(.primary, isEnabled: firstNameIsValid && lastNameIsValid))
                .disabled(!firstNameIsValid || !lastNameIsValid)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct RegistrationPage1_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationPage1()
            .environmentObject(RegistrationView.RegistrationViewModel())
    }
}
