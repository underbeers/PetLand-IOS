//
//  DialogViewModel.swift
//  PetLand
//
//  Created by Никита Сигал on 26.05.2023.
//

import Foundation
import SwiftUI

extension DialogView {
    @MainActor final class DialogViewModel: ObservableObject {
        private let chatService: ChatService = .shared

        @Published var newMessage: String = ""
        @Published var newMessageIsValid: Bool = false
        
        var chatID: String {
            chatService.chatID
        }

        var dialogBinding: Binding<Dialog> = .constant(.init())
        private var dialog: Dialog {
            get {
                dialogBinding.wrappedValue
            }
            set {
                dialogBinding.wrappedValue = newValue
            }
        }

        func sendMessage() {
            if newMessageIsValid {
                chatService.sendMessage(.init(
                    text: newMessage.trimmingCharacters(in: .whitespacesAndNewlines),
                    to: dialog.chatID)
                )
                newMessage = ""
            }
        }

        func validate() {
            newMessage = String(newMessage.trimmingPrefix(while: { $0.isWhitespace }))
            newMessageIsValid = !newMessage.isEmpty
        }
    }
}
