//
//  LoginView.swift
//  PetLand
//
//  Created by Никита Сигал on 23.03.2023.
//

import SwiftUI

struct LoginView: View {
    // MARK: Environment
    
    @EnvironmentObject var appState: AppState
    @Environment(\.openURL) var openURL
    
    // MARK: Focus
    
    private enum Focusable: Hashable {
        case email, password
    }

    @FocusState private var currentFocus: Focusable?
    
    // MARK: State
    
    @StateObject private var model = LoginViewModel()
    @State private var emailIsValid: Bool = false
    @State private var passwordIsValid: Bool = false
    
    private var canLogin: Bool {
        emailIsValid && passwordIsValid
    }
    
    @State private var isKeyboardPresented: Bool = false
    
    var body: some View {
        VStack {
            if !isKeyboardPresented {
                LogoImage()
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
                    
            Text("Авторизация")
                .font(.cTitle1)
                .foregroundColor(.cText)
                    
            Spacer()
                            
            VStack(alignment: .leading, spacing: 0) {
                CustomTextField(.email, text: $model.email, isValid: $emailIsValid, isRequired: true) {
                    if emailIsValid {
                        currentFocus = .password
                    }
                }
                .focused($currentFocus, equals: .email)
                .padding(.bottom, 8)
                CustomTextField(.password, text: $model.password, isValid: $passwordIsValid, isRequired: true) {
                    if canLogin {
                        model.login()
                    }
                }
                    .focused($currentFocus, equals: .password)
                                
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
            .padding(.horizontal, 40)
                            
            Spacer()
                            
            VStack(spacing: 8) {
                Text(model.error ?? " ")
                    .opacity(model.error != nil ? 1 : 0)
                    .font(.cSecondary1)
                    .foregroundColor(.cRed500)
                                
                Button("Войти") {
                    model.login()
                }
                .buttonStyle(CustomButton(.primary, isEnabled: canLogin))
                .disabled(!canLogin)
                                
                Button(action: {
                    appState.setRootScreen(to: .registration)
                }, label: {
                    Text("У вас еще нет аккаунта?")
                        .font(.cSecondary1)
                        .foregroundColor(.cBlue300)
                        + Text("\nЗарегистрироваться")
                        .underline()
                        .font(.cSecondary1)
                        .foregroundColor(.cBlue300)
                })
            }
        }
        .padding(.vertical, 16)
        .background(
            Image("petland:backdrop")
                .resizable(resizingMode: .tile)
                .ignoresSafeArea()
        )
        .alert("Что-то пошло не так...", isPresented: $model.presentingAlert) {} message: {
            Text(model.alertMessage)
        }
        .onAppear {
            model.setup(appState)
        }
        .keyboardAware(isPresented: $isKeyboardPresented)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AppState())
    }
}
