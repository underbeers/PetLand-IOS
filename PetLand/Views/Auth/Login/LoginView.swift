//
//  LoginView.swift
//  PetLand
//
//  Created by Никита Сигал on 23.03.2023.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.openURL) var openURL
    
    @StateObject private var model = LoginViewModel()
    
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
                    Text("Авторизация")
                        .font(.cTitle1)
                        .foregroundColor(.cText)
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 0) {
                        CustomTextField(.email, text: $model.email, isValid: $model.emailIsValid, isRequired: true)
                            .padding(.bottom, 8)
                        CustomTextField(.password, text: $model.password, isValid: $model.passwordIsValid, isRequired: true)
                        
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                openURL(URL(string: "http://petland-k8s.underbeers.space/password-recovery")!)
                            }, label: {
                                Text("Забыли пароль?")
                                    .underline()
                                    .font(.cSecondary1)
                                    .foregroundColor(.cBlue300)
                            })
                        }
                        
                        Toggle("Не выходить из аккаунта", isOn: $model.staySignedIn)
                            .toggleStyle(CustomCheckbox())
                            .padding(.top, 24)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 8) {
                        Text(model.error ?? " ")
                            .opacity(model.error != nil ? 1 : 0)
                            .font(.cSecondary1)
                            .foregroundColor(.cRed500)
                        
                        Button("Войти") {
                            model.login {
                                appState.setRootScreen(to: .main)
                            }
                        }
                        .buttonStyle(CustomButton(.primary, isEnabled: model.isValid))
                        .disabled(!model.isValid)
                        
                        Button(action: {
                            appState.setRootScreen(to: .registration)
                        }, label: {
                            Text("У вас еще нет аккаунта?")
                                .font(.cSecondary1)
                                .foregroundColor(.cBlue300)
                                + Text("Зарегистрироваться")
                                .underline()
                                .font(.cSecondary1)
                                .foregroundColor(.cBlue300)
                        })
                    }
                }
                .frame(width: 0.75 * metrics.size.width)
                .padding(.vertical, 24)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Image("petland:backdrop")
                    .resizable(resizingMode: .tile)
                    .ignoresSafeArea()
            )
            .alert("Что-то пошло не так...", isPresented: $model.presentingAlert) {} message: {
                Text(model.alertMessage)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
