//
//  ContactsPicker.swift
//  PetLand
//
//  Created by Никита Сигал on 18.05.2023.
//

import PhoneNumberKit
import SwiftUI

struct ContactsPicker: View {
    @EnvironmentObject var config: CustomConfig

    @Binding var useMessenger: Bool
    @State var usePhone: Bool = false
    @Binding var phone: String
    @State var phoneIsValid: Bool = false

    func validate() {
        config.isEmpty = !(useMessenger || usePhone)
        config.error = !usePhone ? "" : phoneIsValid ? "" : " "
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Toggle("Внутренний чат сервиса", isOn: $useMessenger)
                .toggleStyle(CustomCheckbox())
            Toggle("Телефон", isOn: $usePhone)
                .toggleStyle(CustomCheckbox())
            if usePhone {
                CustomWrapper(isValid: $phoneIsValid) {
                    CustomTextField(.phoneNumber, text: Binding(get: {
                        phone
                    }, set: { newValue in
                        phone = PartialFormatter().formatPartial(newValue)
                    }))
                }
            }
        }
        .animation(.spring(), value: usePhone)
        .onChange(of: useMessenger) { _ in
            validate()
        }
        .onChange(of: phoneIsValid) { _ in
            validate()
        }
        .onChange(of: usePhone) { _ in
            validate()
        }
        .onChange(of: phone) { newValue in
            if !newValue.isEmpty {
                usePhone = true
            }
        }
    }
}

private struct ContactsPicker_PreviewContainer: View {
    @State var useMessenger: Bool = false
    @State var contactsAreValid: Bool = false
    @State var phone: String = ""

    var body: some View {
        VStack {
            CustomWrapper(title: "Контакты", isValid: $contactsAreValid) {
                ContactsPicker(useMessenger: $useMessenger, phone: $phone)
            }
            Text(String(contactsAreValid))
        }
        .padding()
    }
}

struct ContactsPicker_Previews: PreviewProvider {
    static var previews: some View {
        ContactsPicker_PreviewContainer()
    }
}
