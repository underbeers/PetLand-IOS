//
//  PetDetailView.swift
//  PetLand
//
//  Created by Никита Сигал on 10.05.2023.
//

import SwiftUI

struct PetDetailView: View {
    @StateObject private var model: PetDetailViewModel = .init()
    private let cachedPet: PetGeneral

    init(_ pet: PetGeneral) {
        self.cachedPet = pet
    }

    private var name: String {
        model.pet.name.isEmpty ? cachedPet.name : model.pet.name
    }

    private var type: String {
        model.pet.type.isEmpty ? cachedPet.type : model.pet.type
    }

    private var breed: String {
        model.pet.breed.isEmpty ? cachedPet.breed : model.pet.breed
    }

    private var gender: String {
        model.pet.gender.isEmpty ? cachedPet.gender : model.pet.gender
    }

    private var age: String {
        model.pet.birthday.isEmpty ? cachedPet.formattedAge : model.pet.formattedAge
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Image("preview:dog")
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .aspectRatio(4 / 3, contentMode: .fill)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.25), radius: 6, x: 4, y: 4)

                Text(name)
                    .font(.cTitle1)
                    .foregroundColor(.cText)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        CustomChip(title: type)
                        CustomChip(title: gender)
                        CustomChip(title: breed)
                        CustomChip(title: age)
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Окрас")
                        .font(.cTitle4)
                        .foregroundColor(.cText)
                    Text(model.pet.color)
                        .font(.cMain)
                        .foregroundColor(.cText)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Особенности ухода")
                        .font(.cTitle4)
                        .foregroundColor(.cText)
                    Text(model.pet.care)
                        .font(.cMain)
                        .foregroundColor(.cText)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Родословная")
                        .font(.cTitle4)
                        .foregroundColor(.cText)
                    Text(model.pet.pedigree)
                        .font(.cMain)
                        .foregroundColor(.cText)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Черты характера")
                        .font(.cTitle4)
                        .foregroundColor(.cText)
                    Text(model.pet.character)
                        .font(.cMain)
                        .foregroundColor(.cText)
                }

                if ["Кошка", "Собака"].contains(model.pet.type) {
                    HStack(spacing: 32) {
                        HStack(spacing: 8) {
                            Image(model.pet.sterilized ? "icons:checkmark" : "icons:cross")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(model.pet.sterilized ? .cGreen : .cRed)
                                .frame(width: 28, height: 28)
                            Text("Стерилизация")
                                .font(.cMain)
                                .foregroundColor(.cText)
                        }
                        HStack(spacing: 8) {
                            Image(model.pet.vaccinated ? "icons:checkmark" : "icons:cross")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(model.pet.vaccinated ? .cGreen : .cRed)
                                .frame(width: 28, height: 28)
                            Text("Вакцинация")
                                .font(.cMain)
                                .foregroundColor(.cText)
                        }
                    }
                }
            }
            .padding(16)
        }
        .navigationTitle(name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            model.fetchInfoBy(id: cachedPet.id)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                NavigationLink {
                    Text("Pet Editing Placeholder")
                } label: {
                    Image("icons:edit")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.cOrange)
                        .frame(width: 24, height: 24)
                }
            }
        }
        .alert("Что-то пошло не так...", isPresented: $model.presentingAlert) {
            Text(model.alertMessage)
        }
    }
}

struct PetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PetDetailView(.dummy)
    }
}
