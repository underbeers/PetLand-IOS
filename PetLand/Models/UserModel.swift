//
//  UserModel.swift
//  PetLand
//
//  Created by Никита Сигал on 06.05.2023.
//

import Foundation

struct User: Codable, Identifiable {
    var id: UUID = .init()
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var chatID: UUID = .init()
    var sessionID: UUID = .init()

    enum CodingKeys: String, CodingKey {
        case id = "userID"
        case firstName
        case lastName = "surName"
        case email
        case chatID
        case sessionID
    }
}
