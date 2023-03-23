//
//  CustomCheckbox.swift
//  PetLand
//
//  Created by Никита Сигал on 17.03.2023.
//

import SwiftUI

struct CustomCheckbox: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }, label: {
            HStack {
                Image(configuration.isOn
                    ? "icons:checkbox:on"
                    : "icons:checkbox:off")
                    .resizable()
                    .frame(width: 24, height: 24)
                configuration.label
                    .font(.cMain)
                    .foregroundColor(.cText)
            }
        })
    }
}

struct CustomCheckbox_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Toggle(isOn: .constant(true)) {
                Text("Не выходить из аккаунта")
            }
            .toggleStyle(CustomCheckbox())
            Toggle(isOn: .constant(false)) {
                Text("Не выходить из аккаунта")
            }
            .toggleStyle(CustomCheckbox())
        }
    }
}
