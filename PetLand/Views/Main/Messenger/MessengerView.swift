//
//  MessengerView.swift
//  PetLand
//
//  Created by Никита Сигал on 05.05.2023.
//

import SwiftUI

struct MessengerView: View {
    @StateObject var model: MessengerViewModel = .init()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach($model.dialogs) { $dialog in
                        NavigationLink {
                            DialogView(dialog: $dialog)
                        } label: {
                            HStack(alignment: .center, spacing: 16) {
                                Image("preview:person")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 72, height: 72)
                                    .clipShape(Circle())
                                    .overlay(alignment: .bottomTrailing) {
                                        if dialog.connected {
                                            Circle()
                                                .strokeBorder(.white, lineWidth: 2)
                                                .background(Circle().fill(Color.cGreen))
                                                .frame(width: 16, height: 16)
                                        }
                                    }
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(dialog.username)
                                        .font(.cTitle3)
                                        .foregroundColor(.cText)
                                    Group {
                                        let _ = debugPrint(dialog)
                                        Text((dialog.messages.last?.from != dialog.chatID ? "Вы: " : "") ?? "")
                                            .foregroundColor(.cSubtext)
                                            + Text(dialog.messages.last?.text ?? " ")
                                            .foregroundColor(.cText)
                                    }
                                    .font(.cMain)
                                    .lineLimit(2, reservesSpace: true)
                                    .multilineTextAlignment(.leading)
                                }
                                Spacer()
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
        .animation(.spring(), value: model.dialogs)
    }
}

struct MessengerView_Previews: PreviewProvider {
    static var previews: some View {
        MessengerView()
    }
}
