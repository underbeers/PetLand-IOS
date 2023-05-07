//
//  ProfileView.swift
//  PetLand
//
//  Created by Никита Сигал on 05.05.2023.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @StateObject var model: ProfileViewModel = .init()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    VStack(spacing: 8) {
                        HStack(spacing: 24) {
                            if let image = model.image {
                                Image(image)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            }
                            else {
                                Image("icons:profile")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(.cBlue200)
                                    .frame(width: 100, height: 100)
                            }
                            VStack(alignment: .leading, spacing: 0) {
                                Text(model.user.firstName + " " + model.user.lastName)
                                    .font(.cTitle4)
                                    .foregroundColor(.cBase800)
                                Text(model.user.email)
                                    .font(.cMain)
                                    .foregroundColor(.cBase600)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        Text("На PetLand с ноября 2022")
                            .font(.cMain)
                            .foregroundColor(.cBlue300)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Rectangle()
                            .frame(height: 1)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.cBase200)
                    }
                    .padding(.bottom, 16)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Описание")
                            .font(.cTitle4)
                            .foregroundColor(.cBase800)
                        Text(String.LoremIpsum.long)
                            .font(.cMain)
                            .foregroundColor(.cBase800)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    
                    NavigationLink {
                        Text("My Pets View Placeholder")
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Питомцы")
                                    .font(.cTitle4)
                                    .foregroundColor(.cBase800)
                                Text("3 добавленных питомца")
                                    .font(.cSecondary1)
                                    .foregroundColor(.cBase600)
                            }
                            Spacer()
                            rightChevron
                        }
                    }
                
                    NavigationLink {
                        Text("My Ratings View Placeholder")
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Рейтинг")
                                    .font(.cTitle4)
                                    .foregroundColor(.cBase800)
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
                                        .foregroundColor(.cBase600)
                                        .padding(.leading, 4)
                                }
                            }
                            Spacer()
                            rightChevron
                        }
                    }
                
                    NavigationLink {
                        Text("My Adverts View Placeholder")
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Объявления")
                                    .font(.cTitle4)
                                    .foregroundColor(.cBase800)
                                Text("1 активное объявление")
                                    .font(.cSecondary1)
                                    .foregroundColor(.cBase600)
                            }
                            Spacer()
                            rightChevron
                        }
                    }
                
                    NavigationLink {
                        Text("My Specializations View Placeholder")
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Являюсь специалистом")
                                    .font(.cTitle4)
                                    .foregroundColor(.cBase800)
                                Text("Кинолог, ветеринар")
                                    .font(.cSecondary1)
                                    .foregroundColor(.cBase600)
                            }
                            Spacer()
                            rightChevron
                        }
                    }
                }
                .padding(.horizontal, 18)
            }
            .navigationTitle("Профиль")
        }
        .alert("Что-то пошло не так...", isPresented: $model.presentingAlert) {
            Text(model.alertMessage)
        }
        .onAppear {
            model.setup(appState)
            model.fetchUserInfo()
        }
    }
}

extension ProfileView {
    private var rightChevron: some View {
        Image("icons:chevron:right")
            .resizable()
            .renderingMode(.template)
            .foregroundColor(.cBase800)
            .frame(width: 24, height: 24)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AppState())
    }
}
