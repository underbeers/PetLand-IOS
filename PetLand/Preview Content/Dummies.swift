//
//  Dummies.swift
//  PetLand
//
//  Created by Никита Сигал on 06.05.2023.
//

import Foundation

extension User {
    static let dummy = User(firstName: "Test",
                            lastName: "Testing",
                            email: "test@server.domain",
                            image: "preview:profile-photo")
}

extension Pet {
    static let dummy = Pet(name: "Котяра",
                           typeID: 1,
                           type: "Собака",
                           breedID: 2,
                           breed: "Австралийская овчарка (аусси)",
                           birthday: "2020-04-28T00:00:00Z",
                           isMale: false,
                           gender: "Девочка",
                           color: "Красная с белыми полосками",
                           care: "Кормить только тунцом и красной икрой",
                           pedigree: "Из рода Бранденбургов",
                           character: "Любит играть в гольф и теннис, иногда взрывает ядерные боеприпасы",
                           vaccinated: true)
}

extension PetCard {
    static let dummy = PetCard(name: "Коротышка",
                                  type: "Кошка",
                                  breed: "Сиамская",
                                  gender: "Девочка",
                                  birthday: "2023-01-22T00:00:00Z")
}
