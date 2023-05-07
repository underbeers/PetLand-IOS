//
//  PetModel.swift
//  PetLand
//
//  Created by Никита Сигал on 07.05.2023.
//

import Foundation

struct Pet: Codable, Identifiable {
    var id: Int
    var name: String
    var userID: String?
    var typeID: Int?
    var type: String
    var breedID: Int?
    var breed: String
    var photo: String
    var birthDate: String
    var isMale: Bool?
    var gender: String
    var color: String?
    var care: String?
    var character: String?
    var pedigree: String?
    var sterilized: Bool?
    var vaccinated: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "petName"
        case userID
        case typeID = "petTypeID"
        case type = "petType"
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
    
    private var convertedBirthDate: Date {
        ISO8601DateFormatter().date(from: birthDate)!
    }
    
    var formattedAge: String {
        let currentDate = Date()
        let deltaSeconds = currentDate.timeIntervalSince(convertedBirthDate)
        let deltaDays = deltaSeconds / 60 / 60 / 24
        let deltaMonths = deltaDays / 30
        
        if deltaDays <= 30 {
            return "\(Int(deltaDays)) ".ending(for: Int(deltaDays), with: .day)
        } else if deltaMonths <= 18 {
            return "\(Int(deltaMonths)) ".ending(for: Int(deltaMonths), with: .month)
        } else {
            return "\(Int(deltaMonths / 12)) ".ending(for: Int(deltaMonths / 12), with: .year)
        }
    }
}
