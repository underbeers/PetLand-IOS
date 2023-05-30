//
//  ChatService.swift
//  PetLand
//
//  Created by Никита Сигал on 29.05.2023.
//

import Foundation
import SocketIO

enum ChatServiceError: Error {
    case decodingError
}

final class ChatService: ObservableObject {
    static let shared = ChatService()
    private let userService: UserServiceProtocol = UserService.shared

    private var user: User = .init()
    private let socket: SocketIOClient
    private let manager: SocketManager = .init(socketURL: URL(string: "http://petland-chat-backend.underbeers.space")!,
                                               config: [.log(true),
                                                        .forceWebsockets(true)])

    var chatID: String { user.chatID }
    @Published var dialogs: [Dialog] = []
    @Published var alertMessage: String = ""
    @Published var presentingAlert: Bool = false

    init() {
        socket = manager.defaultSocket
        addHandlers()

        userService.getUser { [weak self] result in
            switch result {
                case .success(let user):
                    self?.user = user
                    self?.connect()
                default:
                    break
            }
        }
    }

    func sendMessage(_ message: Message) {
        var message = message
        message.from = user.chatID
        socket.emit("private message", message)
    }

    private func onError(_ error: Error) {
        switch error {
            case ChatServiceError.decodingError:
                alertMessage = "Ошибка данных сокета"
            default:
                alertMessage = error.localizedDescription
        }
        presentingAlert = true
    }

    private func connect() {
        if user.chatID.isEmpty || user.sessionID.isEmpty {
            socket.connect(withPayload: ["username": user.firstName + " " + user.lastName])
        } else {
            socket.connect(withPayload: ["chatID": user.chatID, "sessionID": user.sessionID])
        }
    }

    private func addHandlers() {
        socket.on("users") { [weak self] data, _ in
            if let jsonData = try? JSONSerialization.data(withJSONObject: data[0]),
               let dialogs = try? JSONDecoder.custom.decode([Dialog].self, from: jsonData)
            {
                self?.dialogs = dialogs
            } else {
                self?.onError(ChatServiceError.decodingError)
            }
        }

        socket.on("private message") { [weak self] data, _ in
            guard let jsonData = try? JSONSerialization.data(withJSONObject: data[0]),
                  let message = try? JSONDecoder.custom.decode(Message.self, from: jsonData)
            else {
                self?.onError(ChatServiceError.decodingError)
                return
            }

            guard let chatID = self?.chatID,
                  let dialogIndex = self?.dialogs.firstIndex(where: {
                      message.from == chatID && message.to == $0.chatID
                          || message.to == chatID && message.from == $0.chatID
                  })
            else { return }

            self?.dialogs[dialogIndex].messages.append(message)
        }

        socket.on("user connected") { [weak self] data, _ in
            guard let jsonData = try? JSONSerialization.data(withJSONObject: data[0]),
                  let dialog = try? JSONDecoder.custom.decode(Dialog.self, from: jsonData)
            else {
                self?.onError(ChatServiceError.decodingError)
                return
            }

            guard let dialogIndex = self?.dialogs.firstIndex(where: { $0.chatID == dialog.chatID })
            else {
                self?.dialogs.append(dialog)
                return
            }

            self?.dialogs[dialogIndex].connected = true
        }

        socket.on("user disconnected") { [weak self] data, _ in
            guard let chatID = data[0] as? String
            else {
                self?.onError(ChatServiceError.decodingError)
                return
            }

            guard let dialogIndex = self?.dialogs.firstIndex(where: { $0.chatID == chatID })
            else { return }

            self?.dialogs[dialogIndex].connected = false
        }

        socket.on("session") { [weak self] data, _ in
            guard let dict = data[0] as? [String: String],
                  let chatID = dict["userID"],
                  let sessionID = dict["sessionID"]
            else {
                self?.onError(ChatServiceError.decodingError)
                return
            }

            if let self, self.user.chatID.isEmpty || self.user.sessionID.isEmpty {
                self.user.chatID = chatID
                self.user.sessionID = sessionID
                self.userService.updateChatCredentials(chatID: chatID, sessionID: sessionID) { error in
                    if let error {
                        self.onError(error)
                    }
                }
            }
        }

        socket.on(clientEvent: .reconnectAttempt) { [weak self] _, _ in
            self?.manager.disconnect()
            self?.connect()
        }
    }
}
