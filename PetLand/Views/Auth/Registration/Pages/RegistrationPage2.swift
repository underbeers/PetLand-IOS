//
//  RegistrationPage2.swift
//  PetLand
//
//  Created by Никита Сигал on 12.04.2023.
//

import SwiftUI

struct RegistrationPage2: View {
    // MARK: Environment

    @EnvironmentObject var model: RegistrationView.RegistrationViewModel
    
    // MARK: State

    @State var emailIsValid: Bool = false
    @State var codeIsValid: Bool = false
    private var canSend: Bool {
        emailIsValid && secondsLeft == 0
    }

    private var canAdvance: Bool {
        emailIsValid && codeIsValid
    }

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var secondsLeft: Int = 0
    
    var body: some View {
        VStack {
            Spacer()
                
            VStack(spacing: 0) {
                CustomTextField(.email, text: $model.email, isValid: $emailIsValid, isRequired: true) {
                    if canSend {
                        model.sendVerificationCode()
                        secondsLeft = 30
                    }
                }
                    
                VStack(spacing: 4) {
                    Button("Отправить код") {
                        model.sendVerificationCode()
                        secondsLeft = 30
                    }
                    .buttonStyle(CustomButton(.secondary, isEnabled: canSend))
                    .disabled(!canSend)
                        
                    Text("Подождите \(secondsLeft) сек.")
                        .opacity(secondsLeft != 0 ? 1 : 0)
                        .font(.cSecondary1)
                        .foregroundColor(.cBlue300)
                        .onReceive(timer) { _ in
                            if secondsLeft > 0 {
                                secondsLeft -= 1
                            }
                        }
                }
                .padding(.top, 8)
                .padding(.bottom, 12)
                    
                CustomTextField(.verificationCode, text: $model.code, isValid: $codeIsValid, isRequired: true)
                    .disabled(codeIsValid)
            }
            .padding(.horizontal, 40)
                
            Spacer()
                
            Text(model.error ?? " ")
                .opacity(model.error != nil ? 1 : 0)
                .font(.cSecondary1)
                .foregroundColor(.cRed500)
                
            Button("Следующий шаг") {
                model.nextPage()
            }
            .buttonStyle(CustomButton(.primary, isEnabled: canAdvance))
            .disabled(!canAdvance)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct RegistrationPage2_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationPage2()
            .environmentObject(RegistrationView.RegistrationViewModel())
    }
}
