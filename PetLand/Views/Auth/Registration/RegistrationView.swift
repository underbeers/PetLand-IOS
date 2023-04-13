//
//  RegistrationView.swift
//  PetLand
//
//  Created by Никита Сигал on 12.04.2023.
//

import SwiftUI

struct RegistrationView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var model = RegistrationViewModel()

    var body: some View {
        GeometryReader { metrics in
            VStack {
                ZStack(alignment: .bottom) {
                    Image("petland:cutelogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 0.3 * metrics.size.height)
                    Image("petland:titletext")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 0.065 * metrics.size.height)
                }

                VStack {
                    Text("Регистрация")
                        .font(.cTitle1)
                        .foregroundColor(.cText)

                    TabView(selection: $model.page) {
                        RegistrationPage1()
                            .environmentObject(model)
                            .tag(0)
                            .contentShape(Rectangle()).gesture(DragGesture())
                        RegistrationPage2()
                            .environmentObject(model)
                            .tag(1)
                            .contentShape(Rectangle()).gesture(DragGesture())
                        RegistrationPage3()
                            .environmentObject(model)
                            .tag(2)
                            .contentShape(Rectangle()).gesture(DragGesture())
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))

                    Button(action: {
                        appState.setRootScreen(to: .login)
                    }, label: {
                        Text("У вас уже есть аккаунт?\n")
                            .font(.cSecondary1)
                            .foregroundColor(.cBlue300)
                            + Text("Войти")
                            .underline()
                            .font(.cSecondary1)
                            .foregroundColor(.cBlue300)
                    })
                }
                .padding(.vertical, 24)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Image("petland:backdrop")
                    .resizable(resizingMode: .tile)
                    .ignoresSafeArea()
            )
        }
        .alert("Что-то пошло не так...", isPresented: $model.presentingAlert) {} message: {
            Text(model.alertMessage)
        }
        .onAppear {
            model.setup(appState)
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
