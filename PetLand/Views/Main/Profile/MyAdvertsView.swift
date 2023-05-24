//
//  MyAdvertsView.swift
//  PetLand
//
//  Created by Никита Сигал on 17.05.2023.
//

import SwiftUI

struct MyAdvertsView: View {
    @EnvironmentObject var model: ProfileView.ProfileViewModel

    var body: some View {
        ScrollView {
            if model.advertCardList.total == 0 {
                VStack(alignment: .leading, spacing: 12) {
                    Text("У вас пока нет объявлений")
                        .font(.cTitle2)
                        .foregroundColor(.cText)
                    Text("Если у вас уже есть питомец, создайте для него объявление на PetLand")
                        .font(.cMain)
                        .foregroundColor(.cText)
                    NavigationLink {
                        Text("Advert Edit/Creation View")
                    } label: {
                        HStack {
                            Text("Создать объявление")
                                .font(.cButton)
                            Image("icons:plus")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 24, height: 24)
                        }
                        .foregroundColor(.white)
                    }
                    .buttonStyle(CustomButton(.primary, isEnabled: true))
                }
                .padding(16)
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2), spacing: 20) {
                    ForEach($model.advertCardList.adverts) { $advertCard in
                        NavigationLink {
                            AdvertDetailView(advertCard, mode: .my)
                        } label: {
                            AdvertCardView(advertCard: $advertCard)
                        }
                    }
                }
                .padding(16)
            }
        }
        .animation(.default, value: model.advertCardList)
        .onAppear { model.fetchAdverts() }
        .navigationTitle("Мои объявления")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                NavigationLink {
                    AdvertEditView()
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

struct MyAdvertsView_Previews: PreviewProvider {
    static let someModel: ProfileView.ProfileViewModel = {
        let model = ProfileView.ProfileViewModel()
        model.advertCardList.total = 3
        model.advertCardList.adverts = [.dummy, .init(), .init()]
        return model
    }()

    static let emptyModel: ProfileView.ProfileViewModel = {
        let model = ProfileView.ProfileViewModel()
        model.advertCardList.adverts = []
        return model
    }()

    static var previews: some View {
        MyAdvertsView()
            .environmentObject(someModel)
    }
}
