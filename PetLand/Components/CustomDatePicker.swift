//
//  CustomDatePicker.swift
//  PetLand
//
//  Created by Никита Сигал on 08.05.2023.
//

import SwiftUI

struct CustomDatePicker: View {
    @EnvironmentObject var config: CustomConfig

    @Binding var selection: Date

    var body: some View {
        HStack(spacing: 8) {
            Image("icons:calendar")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.cText)
                .frame(width: 24, height: 24)
            DatePicker(selection: $selection, in: ...Date.now, displayedComponents: .date) {
                Text("Выберите дату")
                    .font(.cMain)
                    .foregroundColor(.cText)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.25), radius: 6, x: 4, y: 4)
        .onAppear {
            config.isEmpty = false
        }
    }
}

private struct CustomDatePicker_PreviewContainer: View {
    @State private var selection: Date = .now
    @State private var isValid: Bool = false

    var body: some View {
        CustomWrapper(title: "Дата рождения", isValid: $isValid) {
            CustomDatePicker(selection: $selection)
        }
        .padding()
    }
}

struct CustomDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomDatePicker_PreviewContainer()
    }
}
