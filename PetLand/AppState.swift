//
//  AppState.swift
//  PetLand
//
//  Created by Никита Сигал on 24.03.2023.
//

import SwiftUI

@MainActor
final class AppState: ObservableObject {
    private static let accessTokenStorage: AccessTokenStorageProtocol = AccessTokenStorage.shared

    enum Screen {
        case login,
             registration,
             main
    }

    enum Tab: Hashable {
        case adverts,
             services,
             favourites,
             messenger,
             profile
    }

    @Published var currentTab: Tab = .adverts
    @Published private(set) var rootScreen: Screen = {
        if accessTokenStorage.restore() {
            return .main
        }
        else {
            return .login
        }
    }()

    func setCurrentTab(to tab: Tab) {
        withAnimation {
            currentTab = tab
        }
    }
    
    func setRootScreen(to screen: Screen) {
        withAnimation {
            rootScreen = screen
        }
    }

    func signOut() {
        AppState.accessTokenStorage.delete()
        setRootScreen(to: .login)
    }
}
