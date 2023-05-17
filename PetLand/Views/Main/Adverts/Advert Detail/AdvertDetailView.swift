//
//  AdvertDetailView.swift
//  PetLand
//
//  Created by Никита Сигал on 17.05.2023.
//

import SwiftUI

struct AdvertDetailView: View {
    @StateObject var model: AdvertDetailViewModel = .init()
    private let advertCard: AdvertCard
    
    init(_ advertCard: AdvertCard) {
        self.advertCard = advertCard
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
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(advertCard.name)
                        .font(.cTitle1)
                        .foregroundColor(.cText)
                    Text(asCurrency(advertCard.price as NSNumber))
                        .font(.cTitle3)
                        .foregroundColor(.cText)
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        CustomChip(title: advertCard.type)
                        CustomChip(title: advertCard.gender)
                        CustomChip(title: advertCard.breed)
                        CustomChip(title: advertCard.formattedAge)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Описание")
                        .font(.cTitle4)
                        .foregroundColor(.cText)
                    Text(advertCard.description)
                        .font(.cMain)
                        .foregroundColor(.cText)
                }
                
                Group {
                    if !model.pet.color.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Окрас")
                                .font(.cTitle4)
                                .foregroundColor(.cText)
                            Text(model.pet.color)
                                .font(.cMain)
                                .foregroundColor(.cText)
                        }
                    }
                    
                    if !model.pet.care.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Особенности ухода")
                                .font(.cTitle4)
                                .foregroundColor(.cText)
                            Text(model.pet.care)
                                .font(.cMain)
                                .foregroundColor(.cText)
                        }
                    }
                    
                    if !model.pet.pedigree.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Родословная")
                                .font(.cTitle4)
                                .foregroundColor(.cText)
                            Text(model.pet.pedigree)
                                .font(.cMain)
                                .foregroundColor(.cText)
                        }
                    }
                    
                    if !model.pet.character.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Черты характера")
                                .font(.cTitle4)
                                .foregroundColor(.cText)
                            Text(model.pet.character)
                                .font(.cMain)
                                .foregroundColor(.cText)
                        }
                    }
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
                
                HStack(alignment: .center, spacing: 16) {
                    Image("preview:person")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Иван Иванович")
                            .font(.cTitle4)
                            .foregroundColor(.cText)
                        HStack(spacing: 0) {
                            ForEach(1 ... 5, id: \.self) { _ in
                                Image("icons:star")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(.cOrange400)
                                    .frame(width: 20, height: 20)
                            }
                            Text("5,0")
                                .font(.cMain)
                                .foregroundColor(.cSubtext)
                                .padding(.leading, 4)
                        }
                        Text("2 завершенные сделки")
                            .font(.cSecondary1)
                            .foregroundColor(.cSubtext)
                    }
                }
                
                HStack(spacing: 16) {
                    Button {} label: {
                        Label {
                            Text("Позвонить")
                        } icon: {
                            Image("icons:phone")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 24, height: 24)
                        }
                    }
                    Button {} label: {
                        Label {
                            Text("Написать")
                        } icon: {
                            Image("icons:chat")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 24, height: 24)
                        }
                    }
                }
                .buttonStyle(CustomButton(.primary))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Дата публикации")
                        .font(.cTitle4)
                        .foregroundColor(.cText)
                    Text(advertCard.formattedPublicationDate)
                        .font(.cMain)
                        .foregroundColor(.cText)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Адрес")
                        .font(.cTitle4)
                        .foregroundColor(.cText)
                    Text(advertCard.city + ", " + advertCard.district)
                        .font(.cMain)
                        .foregroundColor(.cText)
                }
            }
            .padding(16)
            .padding(.bottom, 32)
        }
        .navigationTitle(advertCard.name)
        .navigationBarTitleDisplayMode(.inline)
        .animation(.spring(), value: model.pet)
        .onAppear {
            model.fetchInfoBy(id: advertCard.petID)
        }
        .alert("Что-то пошло не так...", isPresented: $model.presentingAlert) {
            Text(model.alertMessage)
        }
    }
}

struct AdvertDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AdvertDetailView(.dummy)
    }
}
