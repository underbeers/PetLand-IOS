//
//  PetsView.swift
//  PetLand
//
//  Created by Никита Сигал on 07.05.2023.
//

import SwiftUI

struct PetsView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var model: ProfileView.ProfileViewModel

    var body: some View {
        ScrollView {
            if model.pets.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("У вас пока нет питомцев")
                        .font(.cTitle2)
                        .foregroundColor(.cText)
                    Text("Если у вас уже есть питомец, добавьте его описание на PetLand")
                        .font(.cMain)
                        .foregroundColor(.cText)
                    NavigationLink {
                        NewPetView()
                    } label: {
                        HStack {
                            Text("Добавить питомца")
                                .font(.cButton)
                            Image("icons:plus")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 24, height: 24)
                        }
                        .foregroundColor(.white)
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
                    ForEach(model.pets) { pet in
                        NavigationLink {
                            PetDetailView(pet)
                        } label: {
                            HStack(spacing: 16) {
                                Image("preview:dog")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .aspectRatio(3 / 4, contentMode: .fill)
                                    .clipped()
                                    .cornerRadius(12)
                                    .shadow(color: .black.opacity(0.25), radius: 6, x: 4, y: 4)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(pet.name)
                                        .multilineTextAlignment(.leading)
                                        .font(.cTitle2)
                                        .foregroundColor(.cText)
                                    
                                    Spacer()
                                    
                                    CustomChip(title: pet.type)
                                    CustomChip(title: pet.breed)
                                    CustomChip(title: pet.isMale ? "Мальчик" : "Девочка")
                                    CustomChip(title: pet.formattedAge)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                }
                .padding(16)
                .animation(.default, value: model.pets.count)
                .onAppear { model.fetchPets() }
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
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
    static let someModel: ProfileView.ProfileViewModel = {
        let model = ProfileView.ProfileViewModel()
        model.pets = [.dummy, .dummy, .dummy]
        return model
    }()

    static let emptyModel: ProfileView.ProfileViewModel = {
        let model = ProfileView.ProfileViewModel()
        model.pets = []
        return model
    }()

    static var previews: some View {
        NavigationStack {
            PetsView()
                .environmentObject(AppState())
                .environmentObject(someModel)
        }

        NavigationStack {
            PetsView()
                .environmentObject(AppState())
                .environmentObject(emptyModel)
        }
    }
}
