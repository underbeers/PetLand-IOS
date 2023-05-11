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

    enum ButtonColor {
        case green,
             orange
    }

    private let isEnabled: Bool
    private let foregroundColor: Color
    private var backgroundColor: Color = .clear
    private var borderColor: Color = .clear

    init(_ type: ButtonType, isEnabled: Bool = true, color: ButtonColor = .orange) {
        self.isEnabled = isEnabled
        
        let base: Color = color == .orange ? .cOrange : .cGreen

        switch type {
            case .primary:
                foregroundColor = .cBase0
                backgroundColor = isEnabled ? base : .cBase400
            case .secondary:
                foregroundColor = isEnabled ? base : .cBase400
                borderColor = isEnabled ? base : .cBase400
            case .text:
                foregroundColor = isEnabled ? base : .cBase400
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
        VStack {
            Button("Кнопка") {}
                .buttonStyle(CustomButton(.primary))
            Button("Кнопка") {}
                .buttonStyle(CustomButton(.primary, color: .green))
        }
    }
}
