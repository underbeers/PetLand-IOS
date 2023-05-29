//
//  MessengerModels.swift
//  PetLand
//
//  Created by Никита Сигал on 26.05.2023.
//

import Foundation
import SocketIO

struct Dialog: Codable, Identifiable, Equatable {
    var messages: [Message] = []
    var chatID: String = UUID().uuidString
    var username: String = ""
    var connected: Bool = false

    var id: String { chatID }

    enum CodingKeys: String, CodingKey {
        case messages
        case chatID = "userID"
        case username
        case connected
    }
}

struct Message: Codable, Identifiable, Equatable, SocketData {
    var text: String = ""
    var from: String = UUID().uuidString
    var to: String = UUID().uuidString
    var timestamp: Date = .now

    var id: String {
        text + from + to + timestamp.formatted()
    }

    enum CodingKeys: String, CodingKey {
        case text = "content"
        case from
        case to
        case timestamp = "time"
    }

    func socketRepresentation() throws -> SocketData {
        return ["content": text, "from": from, "to": to, "time": timestamp.ISO8601Format()] as [String : Any]
    }
}
