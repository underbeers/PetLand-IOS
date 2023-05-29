//
//  DialogView.swift
//  PetLand
//
//  Created by Никита Сигал on 26.05.2023.
//

import SwiftUI

struct DialogView: View {
    @StateObject var model: DialogViewModel = .init()

    @Binding var dialog: Dialog

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(dialog.messages) { message in
                        MessageBox(message: message, incoming: message.from == dialog.chatID)
                    }
                }
                .padding(16)
                .padding(.bottom, 32)
            }
            Divider()
            HStack {
                TextField("Сообщение", text: $model.newMessage)
                    .lineLimit(1 ... 3)
                    .font(.cMain)
                    .foregroundColor(.cText)
                    .onSubmit {
                        model.sendMessage()
                    }
                    .onChange(of: model.newMessage) { _ in
                        model.validate()
                    }

                Button {
                    model.sendMessage()
                } label: {
                    Image("icons:send")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(model.newMessageIsValid ? .cOrange : .cBase400)
                        .frame(width: 24, height: 24)
                }
                .disabled(!model.newMessageIsValid)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 0) {
                    Text(dialog.username)
                        .font(.cTitle4)
                        .foregroundColor(.cText)
                    HStack {
                        Circle()
                            .fill(dialog.connected ? Color.cGreen : Color.cRed)
                            .frame(width: 8)
                        Text(dialog.connected ? "Онлайн" : "Оффлайн")
                            .font(.cSecondary1)
                            .foregroundColor(.cSubtext)
                    }
                }
            }
            ToolbarItem(placement: .primaryAction) {
                Image("preview:person")
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(height: 40)
                    .padding(.bottom, 4)
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .animation(.spring(), value: dialog)
        .animation(.spring(), value: model.newMessageIsValid)
        .onAppear {
            model.dialogBinding = $dialog
        }
    }
}

struct DialogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DialogView(dialog: .constant(.dummy))
        }
    }
}
