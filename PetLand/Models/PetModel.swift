//
//  PetModel.swift
//  PetLand
//
//  Created by Никита Сигал on 07.05.2023.
//

import Foundation

struct Pet: Codable, Identifiable, Equatable {
    var id: Int = UUID().hashValue
    var name: String = ""
    var userID: String = ""
    var typeID: Int = 0
    var type: String = ""
    var breedID: Int = 0
    var breed: String = ""
    var photos: [SizedImage] = []
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
        case photos
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
    
    var convertedBirthday: Date {
        get {
            ISO8601DateFormatter().date(from: birthday) ?? .now
        }
        set {
            birthday = newValue.ISO8601Format()
        }
    }
    
    var formattedAge: String {
        let currentDate = Date()
        let deltaSeconds = currentDate.timeIntervalSince(convertedBirthday)
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

struct PetCard: Codable, Identifiable, Equatable {
    var id: Int = UUID().hashValue
    var name: String = ""
    var type: String = ""
    var breed: String = ""
    var gender: String = ""
    var photo: String = ""
    var birthday: String = ""
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "petName"
        case type = "petType"
        case breed
        case gender
        case photo
        case birthday = "birthDate"
    }
    
    var convertedBirthday: Date {
        get {
            ISO8601DateFormatter().date(from: birthday) ?? .now
        }
        set {
            birthday = newValue.ISO8601Format()
        }
    }
    
    var formattedAge: String {
        let currentDate = Date()
        let deltaSeconds = currentDate.timeIntervalSince(convertedBirthday)
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


struct PetType: Codable, Identifiable, Equatable {
    var id: Int = 0
    var type: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case type = "petType"
    }
}

struct PetBreed: Codable, Identifiable, Equatable {
    var id: Int = 0
    var typeID: Int = 0
    var breed: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case typeID = "petTypeID"
        case breed = "breedName"
    }
}
