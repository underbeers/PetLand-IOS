//
//  PetModel.swift
//  PetLand
//
//  Created by Никита Сигал on 07.05.2023.
//

import Foundation

struct Pet: Codable, Identifiable {
    var id: Int?
    var petTypeID: Int?
    var petType: String?
    var userID: String?
    var breedID: Int?
    var breed: String?
    var photo: String?
    var birthDate: String?
    var isMale: Bool?
    var gender: String?
    var color: String?
    var care: String?
    var character: String?
    var pedigree: String?
    var sterilized: Bool?
    var vaccinated: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case petTypeID
        case petType
        case userID
        case breedID
        case breed
        case photo
        case birthDate
        case isMale = "male"
        case gender
        case color
        case care
        case character = "petCharacter"
        case pedigree
        case sterilized = "sterilization"
        case vaccinated = "vaccination"
    }
}
