//
//  CustomDropdown.swift
//  PetLand
//
//  Created by Никита Сигал on 08.05.2023.
//

import SwiftUI

struct CustomDropdown: View {
    // MARK: Configuration

    @EnvironmentObject var config: CustomConfig
    let options: [String]

    // MARK: State

    @Binding var selection: String

    private var shadowColor: Color {
        if !config.isValid {
            return .cRed.opacity(0.25)
        } else {
            return .black.opacity(0.25)
        }
    }

    var body: some View {
        Menu {
            Picker(selection: $selection, label: EmptyView()) {
                ForEach(options, id: \.self) { option in
                    Text(option)
                }
            }
        } label: {
            Text(!selection.isEmpty ? selection : "Не выбрано")
                .font(.cMain)
                .foregroundColor(.cText)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(.white)
                .cornerRadius(12)
                .shadow(color: shadowColor, radius: 6, x: 4, y: 4)
        }
        .animation(.default, value: selection)
        .onChange(of: selection) { _ in
            config.isEmpty = false
        }
    }
}

struct CustomDropdown_PreviewContainer: View {
    @State var selection: String = ""
    @State var isValid: Bool = false

    var body: some View {
        CustomWrapper(isValid: $isValid) {
            CustomDropdown(options: ["Hello", "there", "General", "Kenobi"], selection: $selection)
        }
        .padding()
    }
}

struct CustomDropdown_Previews: PreviewProvider {
    static var previews: some View {
        CustomDropdown_PreviewContainer()
    }
}
