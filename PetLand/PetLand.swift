//
//  PetLand.swift
//  PetLand
//
//  Created by Никита Сигал on 17.03.2023.
//

import SwiftUI

@main
struct PetLand: App {
    let transition: AnyTransition = .asymmetric(insertion: .move(edge: .trailing),
                                                removal: .move(edge: .leading))

    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ZStack {
                if appState.rootScreen == .login {
                    LoginView()
                        .environmentObject(appState)
                        .transition(transition)
                } else if appState.rootScreen == .registration {
                    RegistrationView()
                        .environmentObject(appState)
                        .transition(transition)
                } else {
                    MainTabView()
                        .transition(transition)
                }
            }
            .animation(.default, value: appState.rootScreen)
        }
    }
}
