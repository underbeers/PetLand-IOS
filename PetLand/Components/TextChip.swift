//
//  TextChip.swift
//  PetLand
//
//  Created by Никита Сигал on 07.05.2023.
//

import SwiftUI

struct TextChip: View {
    enum ChipColor {
        case green
        case orange
        case blue
    }
    
    var title: String
    var color: ChipColor = .green
    
    private var bgColor: Color {
        switch color {
            case .green:
                return .cGreen
            case .orange:
                return .cOrange
            case .blue:
                return .cBlue
        }
    }
    
    var body: some View {
        Text(title)
            .font(.cSecondary1)
            .foregroundColor(.white)
            .padding(.vertical, 4)
            .padding(.horizontal, 12)
            .background(bgColor)
            .cornerRadius(8)
    }
}

struct TextChip_Previews: PreviewProvider {
    static var previews: some View {
        TextChip(title: "Some text")
    }
}
