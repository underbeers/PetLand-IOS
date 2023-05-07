//
//  MyPetsView.swift
//  PetLand
//
//  Created by Никита Сигал on 07.05.2023.
//

import SwiftUI

struct MyPetsView: View {
    @State var pets: [Pet]

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                ForEach(pets) { pet in
                    HStack(spacing: 16) {
                        Image("preview:dog")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150)
                            .cornerRadius(8)
                            .shadow(color: .black.opacity(0.25),radius: 6, x:4, y:4)
                        VStack(alignment: .leading, spacing: 8) {
                            Text(pet.name)
                                .font(.cTitle2)
                                .foregroundColor(.cText)
                            Spacer()
                            TextChip(title: pet.type, color: .cGreen)
                            TextChip(title: pet.breed, color: .cGreen)
                            TextChip(title: pet.gender, color: .cGreen)
                            TextChip(title: pet.formattedAge, color: .cGreen)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(height: 180)
                }
            }
            .padding(16)
        }
        .navigationTitle("Мои питомцы")
    }
}

struct MyPetsView_Previews: PreviewProvider {
    static var previews: some View {
        MyPetsView(pets: Array(repeating: .dummy, count: 10))
    }
}
