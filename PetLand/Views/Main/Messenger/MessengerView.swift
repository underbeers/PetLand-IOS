//
//  MessengerView.swift
//  PetLand
//
//  Created by Никита Сигал on 05.05.2023.
//

import SwiftUI

struct MessengerView: View {
    @StateObject var chatService: ChatService = .shared

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach($chatService.dialogs.sorted { $l, $r in
                        let lt = l.messages.last?.timestamp ?? .distantPast
                        let rt = r.messages.last?.timestamp ?? .distantPast
                        return l.chatID == chatService.chatID ||
                            r.chatID != chatService.chatID && lt > rt
                    }) { $dialog in
                        NavigationLink {
                            DialogView(dialog: $dialog)
                        } label: {
                            HStack(alignment: .center, spacing: 16) {
                                ZStack {
                                    if dialog.chatID == chatService.chatID {
                                        BookmarksImage(40)
                                    } else {
                                        Image("preview:person")
                                            .resizable()
                                            .scaledToFill()
                                            .clipShape(Circle())
                                            .overlay(alignment: .bottomTrailing) {
                                                if dialog.connected {
                                                    Circle()
                                                        .strokeBorder(.white, lineWidth: 2)
                                                        .background(Circle().fill(Color.cGreen))
                                                        .frame(width: 16, height: 16)
                                                }
                                            }
                                    }
                                }
                                .frame(width: 72, height: 72)

                                VStack(alignment: .leading, spacing: 4) {
                                    HStack(spacing: 0) {
                                        Text(dialog.chatID == chatService.chatID ? "Избранное" : dialog.username)
                                            .font(.cTitle3)
                                            .foregroundColor(.cText)
                                        Spacer()
                                        Text(dialog.messages.last?.timestamp.formatted(date: .omitted, time: .shortened) ?? " ")
                                            .font(.cSecondary1)
                                            .foregroundColor(.cText)
                                    }
                                    Group {
                                        Text((dialog.messages.last?.from ?? dialog.chatID) != dialog.chatID ? "Вы: " : "")
                                            .foregroundColor(.cSubtext)
                                            + Text(dialog.messages.last?.text ?? " ")
                                            .foregroundColor(.cText)
                                    }
                                    .font(.cMain)
                                    .lineLimit(2, reservesSpace: true)
                                    .multilineTextAlignment(.leading)
                                }
                            }
                        }
                    }
                }
                .padding(16)
                .padding(.bottom, 32)
            }
            .navigationTitle("Чаты")
        }
        .accentColor(.cOrange)
        .animation(.spring(), value: chatService.dialogs)
        .alert("Что-то пошло не так...", isPresented: $chatService.presentingAlert) {
            Text(chatService.alertMessage)
        }
    }
}

struct MessengerView_Previews: PreviewProvider {
    static var previews: some View {
        MessengerView()
    }
}
