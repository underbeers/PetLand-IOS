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

    @Published private(set) var rootScreen: Screen = {
        if accessTokenStorage.restore() {
            return .main
        }
        else {
            return .login
        }
    }()

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
