//
//  LoginView.swift
//  PetLand
//
//  Created by Никита Сигал on 23.03.2023.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack {
            CustomTextField(.email, isRequired: true)
            CustomTextField(.password, isRequired: true)
            
            Toggle(isOn: .constant(true)) {
                Text("Не выходить из аккаунта")
            }
            .toggleStyle(CustomCheckbox())
            
            Button(action: {}, label: {
                Text("Войти")
            })
            .buttonStyle(CustomButton(.primary, isDisabled: false))
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
