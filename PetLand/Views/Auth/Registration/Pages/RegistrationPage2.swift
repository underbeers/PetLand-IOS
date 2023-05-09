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

            VStack(spacing: 8) {
                CustomWrapper(isValid: $emailIsValid) {
                    CustomTextField(.email, text: $model.email) {
                        if canSend {
                            model.sendVerificationCode()
                            secondsLeft = 30
                        }
                    }
                }

                Button(secondsLeft == 0 ? "Отправить код" : "Подождите \(secondsLeft) сек.") {
                    model.sendVerificationCode()
                    secondsLeft = 30
                }
                .buttonStyle(CustomButton(.secondary, isEnabled: canSend))
                .disabled(!canSend)
                .onReceive(timer) { _ in
                    if secondsLeft > 0 {
                        secondsLeft -= 1
                    }
                }

                CustomWrapper(isValid: $codeIsValid) {
                    CustomTextField(.verificationCode, text: $model.code)
                }
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
        .animation(.default, value: emailIsValid)
        .animation(.default, value: codeIsValid)
        .animation(.default, value: secondsLeft == 0)
    }
}

struct RegistrationPage2_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationPage2()
            .environmentObject(RegistrationView.RegistrationViewModel())
    }
}
