//
//  AdvertDetailView.swift
//  PetLand
//
//  Created by Никита Сигал on 17.05.2023.
//

import SwiftUI

struct AdvertDetailView: View {
    @StateObject var model: AdvertDetailViewModel = .init()
    private let card: AdvertCard
    private let mode: Mode
    
    enum Mode {
        case my, other
    }
    
    init(_ advertCard: AdvertCard, mode: Mode = .other) {
        self.card = advertCard
        self.mode = mode
    }
    
    private var advert: AdvertCommon {
        model.advert ?? card
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
                    Text(advert.name)
                        .font(.cTitle1)
                        .foregroundColor(.cText)
                    Text(asCurrency(advert.price as NSNumber))
                        .font(.cTitle3)
                        .foregroundColor(.cText)
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        CustomChip(title: advert.type)
                        CustomChip(title: advert.gender)
                        CustomChip(title: advert.breed)
                        CustomChip(title: advert.formattedAge)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Описание")
                        .font(.cTitle4)
                        .foregroundColor(.cText)
                    Text(advert.description)
                        .font(.cMain)
                        .foregroundColor(.cText)
                }
                
                Group {
                    if let color = model.advert?.color, !color.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Окрас")
                                .font(.cTitle4)
                                .foregroundColor(.cText)
                            Text(color)
                                .font(.cMain)
                                .foregroundColor(.cText)
                        }
                    }

                    if let care = model.advert?.care, !care.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Особенности ухода")
                                .font(.cTitle4)
                                .foregroundColor(.cText)
                            Text(care)
                                .font(.cMain)
                                .foregroundColor(.cText)
                        }
                    }

                    if let pedigree = model.advert?.pedigree, !pedigree.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Родословная")
                                .font(.cTitle4)
                                .foregroundColor(.cText)
                            Text(pedigree)
                                .font(.cMain)
                                .foregroundColor(.cText)
                        }
                    }

                    if let character = model.advert?.character, !character.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Черты характера")
                                .font(.cTitle4)
                                .foregroundColor(.cText)
                            Text(character)
                                .font(.cMain)
                                .foregroundColor(.cText)
                        }
                    }
                }
                
                if let type = model.advert?.type, ["Кошка", "Собака"].contains(type) {
                    HStack(spacing: 32) {
                        HStack(spacing: 8) {
                            Image(model.advert!.sterilized ? "icons:checkmark" : "icons:cross")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(model.advert!.sterilized ? .cGreen : .cRed)
                                .frame(width: 28, height: 28)
                            Text("Стерилизация")
                                .font(.cMain)
                                .foregroundColor(.cText)
                        }
                        HStack(spacing: 8) {
                            Image(model.advert!.vaccinated ? "icons:checkmark" : "icons:cross")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(model.advert!.vaccinated ? .cGreen : .cRed)
                                .frame(width: 28, height: 28)
                            Text("Вакцинация")
                                .font(.cMain)
                                .foregroundColor(.cText)
                        }
                    }
                }
                
                if mode == .other {
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
                        if let phone = model.advert?.phone, !phone.isEmpty {
                            Button {
                                if let url = URL(string: "tel://\(phone)") {
                                    UIApplication.shared.open(url)
                                }
                            } label: {
                                Label {
                                    Text("Позвонить")
                                } icon: {
                                    Image("icons:phone")
                                        .resizable()
                                        .renderingMode(.template)
                                        .frame(width: 24, height: 24)
                                }
                            }
                        }
                        if model.advert?.chat ?? false {
                            NavigationLink {
                                Text("Chat Placeholder")
                            } label: {
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
                    }
                    .buttonStyle(CustomButton(.primary))
                } else {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Контакты")
                            .font(.cTitle4)
                            .foregroundColor(.cText)
                        
                        let canCall = !(model.advert?.phone.isEmpty ?? true)
                        let canChat = model.advert?.chat ?? false
                        
                        HStack(alignment: .top, spacing: 32) {
                            HStack(spacing: 8) {
                                Image(canCall ? "icons:checkmark" : "icons:cross")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(canCall ? .cGreen : .cRed)
                                    .frame(width: 28, height: 28)
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("По телефону")
                                        .font(.cMain)
                                        .foregroundColor(.cText)
                                    if canCall {
                                        Text(model.advert?.phone ?? "")
                                            .font(.cSecondary2)
                                            .foregroundColor(.cSubtext)
                                    }
                                }
                            }
                            HStack(spacing: 8) {
                                Image(canChat ? "icons:checkmark" : "icons:cross")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(canChat ? .cGreen : .cRed)
                                    .frame(width: 28, height: 28)
                                Text("В приложении")
                                    .font(.cMain)
                                    .foregroundColor(.cText)
                            }
                        }
                    }
                }
                
                Group {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Дата публикации")
                            .font(.cTitle4)
                            .foregroundColor(.cText)
                        Text(advert.formattedPublicationDate)
                            .font(.cMain)
                            .foregroundColor(.cText)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Адрес")
                            .font(.cTitle4)
                            .foregroundColor(.cText)
                        Text(advert.city + ", " + advert.district)
                            .font(.cMain)
                            .foregroundColor(.cText)
                    }
                }
            }
            .padding(16)
            .padding(.bottom, 32)
        }
        .navigationTitle(advert.name)
        .navigationBarTitleDisplayMode(.inline)
        .animation(.spring(), value: model.advert)
        .onAppear {
            model.fetchAdvert(id: card.id)
        }
        .alert("Что-то пошло не так...", isPresented: $model.presentingAlert) {
            Text(model.alertMessage)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                NavigationLink {
                    Text("Advert Edit/Creation Placeholder")
                } label: {
                    if mode == .my {
                        Image("icons:edit")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.cOrange)
                            .frame(width: 24, height: 24)
                    }
                }
            }
        }
    }
}

struct AdvertDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AdvertDetailView(.dummy)
        AdvertDetailView(.dummy, mode: .my)
    }
}
