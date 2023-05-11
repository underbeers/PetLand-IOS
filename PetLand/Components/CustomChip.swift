//
//  CustomChip.swift
//  PetLand
//
//  Created by Никита Сигал on 07.05.2023.
//

import SwiftUI

struct CustomChip: View {
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
            .lineLimit(1)
            .font(.cSecondary1)
            .foregroundColor(.white)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(bgColor)
            .cornerRadius(.infinity)
    }
}

struct CustomChip_Previews: PreviewProvider {
    static var previews: some View {
        CustomChip(title: "Some text")
    }
}
