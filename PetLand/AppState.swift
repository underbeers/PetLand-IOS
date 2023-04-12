//
//  AppState.swift
//  PetLand
//
//  Created by Никита Сигал on 24.03.2023.
//

import SwiftUI

@MainActor
class AppState: ObservableObject {
     enum Screen {
        case login,
             registration,
             main
    }

    @Published private(set) var rootScreen: Screen = .login
    
    func setRootScreen(to screen: Screen) {
        withAnimation {
            rootScreen = screen
        }
    }
}
