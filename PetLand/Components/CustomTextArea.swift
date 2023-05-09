//
//  CustomTextArea.swift
//  PetLand
//
//  Created by Никита Сигал on 08.05.2023.
//

import SwiftUI

struct CustomTextArea: View {
    @EnvironmentObject var config: CustomConfig
    private let placeholder: String
    private let onSubmitHandler: () -> ()

    @Binding var text: String
    @FocusState var isFocused: Bool

    init(placeholder: String, text: Binding<String>, onSubmit: @escaping () -> () = {}) {
        self.placeholder = placeholder
        self._text = text
        self.onSubmitHandler = onSubmit
    }

    private var shadowColor: Color {
        if !config.isValid {
            return .cRed.opacity(0.25)
        } else if isFocused {
            return .cGreen.opacity(0.25)
        } else {
            return .black.opacity(0.25)
        }
    }

    private func validate() {
        config.isEmpty = text.isEmpty
        config.error = TextContentType.someText("").validate(text) ?? ""
    }

    var body: some View {
        Text(!text.isEmpty ? text : " ")
            .lineLimit(5 ... 10)
            .font(.cMain)
            .foregroundColor(.cText)
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .overlay {
                TextEditor(text: $text)
                    .onSubmit { onSubmitHandler() }
                    .focused($isFocused)
                    .font(.cMain)
                    .foregroundColor(.cText)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(.white)
                    .cornerRadius(12)
                    .shadow(color: shadowColor, radius: 6, x: 4, y: 4)
                    .overlay(alignment: .topLeading) {
                        Text(text.isEmpty ? placeholder : "")
                            .font(.cMain)
                            .foregroundColor(.cSubtext)
                            .allowsHitTesting(false)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                    }
            }
            .onChange(of: text) { _ in validate() }
            .onChange(of: isFocused) { _ in validate() }
            .animation(.default, value: shadowColor)
    }
}

private struct CustomTextArea_PreviewContainer: View {
    @State var text: String = ""
    @State var isValid: Bool = false

    var body: some View {
        CustomWrapper(title: "Окрас", isValid: $isValid) {
            CustomTextArea(placeholder: "Опишите окрас питомца", text: $text)
        }
        .padding()
    }
}

struct CustomTextArea_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextArea_PreviewContainer()
    }
}
