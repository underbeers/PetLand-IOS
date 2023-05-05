//
//  MainTabView.swift
//  PetLand
//
//  Created by Никита Сигал on 24.03.2023.
//

import SwiftUI

struct TabItem: View {
    @State var title: String
    @State var image: String
    @State var tag: Int
    @Binding var selection: Int

    var body: some View {
        Button {
            selection = tag
        } label: {
            VStack {
                Image(image)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(selection == tag ? .cOrange900 : .cBlue200)
                    .frame(width: 24, height: 24)
                Text(title)
                    .font(.cSecondary2)
                    .foregroundColor(selection == tag ? .cOrange900 : .cBlue200)
            }
            .frame(maxWidth: .infinity)
        }
//        .buttonStyle(PlainButtonStyle())
    }
}

struct MainTabView: View {
    @State var tab: Int = 1

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $tab) {
                MarketplaceView()
                    .tag(1)
                ProfileView()
                    .tag(2)
                FavouritesView()
                    .tag(3)
                MessengerView()
                    .tag(4)
                ProfileView()
                    .tag(5)
            }
            .background(.red)

            HStack(spacing: 0) {
                TabItem(title: "Объявление", image: "icons:advert", tag: 1, selection: $tab)
                TabItem(title: "Сервисы", image: "icons:services", tag: 2, selection: $tab)
                TabItem(title: "Избранное", image: "icons:heart", tag: 3, selection: $tab)
                TabItem(title: "Чаты", image: "icons:chat", tag: 4, selection: $tab)
                TabItem(title: "Профиль", image: "icons:profile", tag: 5, selection: $tab)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 4)
            .padding(.vertical, 8)
            .background(.white)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
