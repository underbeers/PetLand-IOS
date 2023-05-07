//
//  TextChip.swift
//  PetLand
//
//  Created by Никита Сигал on 07.05.2023.
//

import SwiftUI

struct TextChip: View {
    @State var title: String
    @State var color: Color
    
    var body: some View {
        Text(title)
            .font(.cSecondary2)
            .foregroundColor(.white)
            .padding(.vertical, 4)
            .padding(.horizontal, 12)
            .background(color)
            .cornerRadius(8)
    }
}

struct TextChip_Previews: PreviewProvider {
    static var previews: some View {
        TextChip(title: "Some text", color: .cGreen600)
    }
}
