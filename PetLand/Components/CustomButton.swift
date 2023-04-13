//
//  CustomButton.swift
//  PetLand
//
//  Created by Никита Сигал on 17.03.2023.
//

import SwiftUI

struct CustomButton: ButtonStyle {
    enum ButtonType {
        case primary,
             secondary,
             text
    }

    var foregroundColor: Color
    var backgroundColor: Color = .cTransparent
    var borderColor: Color = .cTransparent

    init(_ type: ButtonType, isEnabled: Bool = true) {
        switch type {
            case .primary:
                foregroundColor = .cBase0
                backgroundColor = isEnabled ? .cOrange900 : .cBase400
            case .secondary:
                foregroundColor = isEnabled ? .cOrange900 : .cBase400
                borderColor = isEnabled ? .cOrange900 : .cBase400
            case .text:
                foregroundColor = isEnabled ? .cOrange900 : .cBase400
        }
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .font(.cButton)
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: 3)
            }
            .cornerRadius(12)
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        Button("Кнопка") {}
            .buttonStyle(CustomButton(.primary))
    }
}
