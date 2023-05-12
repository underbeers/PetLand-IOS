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

extension PetGeneral {
    static let dummy = PetGeneral(name: "Коротышка",
                                  type: "Кошка",
                                  breed: "Сиамская",
                                  gender: "Девочка",
                                  birthday: "2023-01-22T00:00:00Z")
}

extension AdvertCard {
    static let dummy = AdvertCard(name: "Объявляшка",
                              price: 12999,
                              city: "Нижний Новгород",
                              district: "Советский р-н",
                              publicationDateString: "2023-02-18T16:12:28Z")
}

extension AdvertCardList {
    static let dummy = AdvertCardList(adverts: [.dummy, .init(), .init(), .init(), .init()])
}
