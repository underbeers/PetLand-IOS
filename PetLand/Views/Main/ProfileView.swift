//
//  ProfileView.swift
//  PetLand
//
//  Created by Никита Сигал on 05.05.2023.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Button("Выйти из аккаунта") {
            UserService.shared.logout()
            appState.setRootScreen(to: .login)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
