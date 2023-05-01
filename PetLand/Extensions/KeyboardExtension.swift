//
//  KeyboardExtension.swift
//  PetLand
//
//  Created by Никита Сигал on 01.05.2023.
//
// https://stackoverflow.com/a/72482394/12695853

import Combine
import SwiftUI

extension View {
    private var keyboardPublisher: AnyPublisher<Bool, Never> {
        Publishers
            .Merge(
                NotificationCenter
                    .default
                    .publisher(for: UIResponder.keyboardWillShowNotification)
                    .map { _ in true },
                NotificationCenter
                    .default
                    .publisher(for: UIResponder.keyboardWillHideNotification)
                    .map { _ in false })
//            .debounce(for: .seconds(0.1), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    func keyboardAware(isPresented: Binding<Bool>) -> some View {
        onReceive(keyboardPublisher) { value in
            withAnimation(.spring()) {
                isPresented.wrappedValue = value
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .gesture(DragGesture().onChanged { _ in hideKeyboard() })
    }
}
