//
//  PetsView.swift
//  PetLand
//
//  Created by Никита Сигал on 07.05.2023.
//

import SwiftUI

struct PetsView: View {
    @EnvironmentObject var appState: AppState

    @State var pets: [Pet]

    var body: some View {
        ScrollView {
            if pets.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("У вас пока нет питомцев")
                        .font(.cTitle2)
                        .foregroundColor(.cText)
                    Text("Если у вас уже есть питомец, добавьте его описание на PetLand")
                        .font(.cMain)
                        .foregroundColor(.cText)
                    Button {} label: {
                        HStack {
                            Text("Добавить питомца")
                            Image("icons:plus")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 24, height: 24)
                        }
                    }
                    .buttonStyle(CustomButton(.primary, isEnabled: true))

                    Text("Или найдите друга в объявлениях PetLand")
                        .font(.cMain)
                        .foregroundColor(.cText)
                    Button {
                        appState.setCurrentTab(to: .adverts)
                    } label: {
                        HStack {
                            Text("Доска объявлений")
                            Image("icons:advert")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 24, height: 24)
                        }
                    }
                    .buttonStyle(CustomButton(.primary, isEnabled: true, color: .green))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
            } else {
                VStack(spacing: 28) {
                    ForEach(pets) { pet in
                        HStack(spacing: 16) {
                            Image("preview:dog")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150)
                                .cornerRadius(8)
                                .shadow(color: .black.opacity(0.25), radius: 6, x: 4, y: 4)
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
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            NewPetView()
                        } label: {
                            Image("icons:plus")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.cOrange)
                                .frame(width: 24, height: 24)
                        }
                    }
                }
            }
        }
        .navigationTitle("Мои питомцы")
    }
}

struct PetsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PetsView(pets: Array(repeating: .dummy, count: 5))
                .environmentObject(AppState())
        }

        NavigationStack {
            PetsView(pets: [])
                .environmentObject(AppState())
        }
    }
}
