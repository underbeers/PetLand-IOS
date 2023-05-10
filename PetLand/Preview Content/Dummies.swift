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
    static let dummy = Pet(id: 0,
                           name: "Котяра",
                           type: "Собака",
                           breed: "Овчарка",
                           birthday: "2020-04-28T00:00:00Z",
                           isMale: false,
                           gender: "Девочка",
                           color: "Красная с белыми полосками",
                           care: "Кормить только тунцом и красной икрой",
                           pedigree: "Из рода Бранденбургов",
                           character: "Любит играть в гольф и теннис, иногда взрывает ядерные боеприпасы",
                           vaccinated: true)
}
