//
//  PetModel.swift
//  PetLand
//
//  Created by Никита Сигал on 07.05.2023.
//

import Foundation

struct Pet: Codable, Identifiable {
    var id: Int = UUID().hashValue
    var name: String = ""
    var userID: String = ""
    var typeID: Int = 0
    var type: String = ""
    var breedID: Int = 0
    var breed: String = ""
    var photo: String = ""
    var birthday: String = ""
    var isMale: Bool = true
    var gender: String = ""
    var color: String = ""
    var care: String = ""
    var pedigree: String = ""
    var character: String = ""
    var sterilized: Bool = false
    var vaccinated: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "petName"
        case userID
        case typeID = "petTypeID"
        case type = "petType"
        case breedID
        case breed
        case photo
        case birthday = "birthDate"
        case isMale = "male"
        case gender
        case color
        case care
        case character = "petCharacter"
        case pedigree
        case sterilized = "sterilization"
        case vaccinated = "vaccinations"
    }
    
    private var convertedBirthDate: Date {
        ISO8601DateFormatter().date(from: birthday) ?? .now
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


struct PetType: Codable, Identifiable {
    var id: Int = 0
    var type: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case type = "petType"
    }
}

struct PetBreed: Codable, Identifiable {
    var id: Int = 0
    var typeID: Int = 0
    var breed: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case typeID = "petTypeID"
        case breed = "breedName"
    }
}
