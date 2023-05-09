//
//  Dummies.swift
//  PetLand
//
//  Created by Никита Сигал on 06.05.2023.
//

import Foundation

extension User {
    static let dummy = User(firstName: "Test", lastName: "Testing", email: "test@server.domain", image: "preview:profile-photo")
}

extension Pet {
    static let dummy = Pet(id: 0, name: "Шарик", type: "Собака", breed: "Овчарка", photo: "", birthday: "2023-04-14T00:00:00Z", gender: "Мальчик")
}
