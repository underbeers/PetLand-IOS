//
//  MessengerViewModel.swift
//  PetLand
//
//  Created by Никита Сигал on 26.05.2023.
//

import Foundation

extension MessengerView {
    @MainActor final class MessengerViewModel: ObservableObject {
        @Published var dialogs: [Dialog] = [.dummy, .init(messages: [], chatID: "0", username: "Alfred Hops", connected: true)]
    }
}
