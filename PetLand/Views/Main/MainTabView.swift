//
//  MainTabView.swift
//  PetLand
//
//  Created by Никита Сигал on 24.03.2023.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $appState.currentTab) {
                AdvertsView()
                    .tag(AppState.Tab.adverts)
                ServicesView()
                    .tag(AppState.Tab.services)
                FavouritesView()
                    .tag(AppState.Tab.favourites)
                MessengerView()
                    .tag(AppState.Tab.messenger)
                ProfileView()
                    .tag(AppState.Tab.profile)
            }

            HStack(spacing: 0) {
                tabItem(title: "Объявление", image: "icons:advert", tag: .adverts)
                tabItem(title: "Сервисы", image: "icons:services", tag: .services)
                tabItem(title: "Избранное", image: "icons:heart:fill", tag: .favourites)
                tabItem(title: "Чаты", image: "icons:chat", tag: .messenger)
                tabItem(title: "Профиль", image: "icons:profile", tag: .profile)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 4)
            .padding(.vertical, 8)
            .background(.white)
        }
//        .ignoresSafeArea(.keyboard)
    }
}

extension MainTabView {
    func tabItem(title: String, image: String, tag: AppState.Tab) -> some View {
        Button {
            appState.setCurrentTab(to: tag)
        } label: {
            VStack {
                Image(image)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(appState.currentTab == tag ? .cOrange900 : .cBlue200)
                    .frame(width: 24, height: 24)
                Text(title)
                    .font(.cSecondary2)
                    .foregroundColor(appState.currentTab == tag ? .cOrange900 : .cBlue200)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(AppState())
    }
}
