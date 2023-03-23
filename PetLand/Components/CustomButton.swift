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
    
    private var type: ButtonType
    private var isDisabled: Bool
    
    init(_ type: ButtonType, isDisabled: Bool) {
        self.type = type
        self.isDisabled = isDisabled
    }
    
    var foregroundColor: Color {
        type == .primary ? .white : (isDisabled ? .cGray : .cOrange)
    }
    
    var backgroundColor: Color {
        type != .primary ? .cTransparent : (isDisabled ? .cGray : .cOrange)
    }
    
    var strokeColor: Color {
        type != .secondary ? .cTransparent : (isDisabled ? .cGray : .cOrange)
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .font(.cButton)
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .overlay(RoundedRectangle(cornerRadius: 12)
                .stroke(strokeColor))
            .cornerRadius(12)
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: {}, label: {
            Text("Кнопка")
        })
        .buttonStyle(CustomButton(.primary, isDisabled: false))
    }
}
