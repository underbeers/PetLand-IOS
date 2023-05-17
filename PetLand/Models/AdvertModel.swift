//
//  AdvertModel.swift
//  PetLand
//
//  Created by Никита Сигал on 12.05.2023.
//

import Foundation

protocol AdvertCommon {
    var name: String {get}
    var type: String {get}
    var breed: String {get}
    var gender: String {get}
    var formattedAge: String {get}
    
    var price: Int {get}
    var description: String {get}
    var city: String {get}
    var district: String {get}
    var formattedPublicationDate: String {get}
}

struct Advert: Codable, Identifiable, Equatable, AdvertCommon {
    var id: Int = UUID().hashValue
    var userID: String = ""
    
    var petID: Int = 0
    var photos: [SizedImage] = []
    var name: String = ""
    var type: String = ""
    var breed: String = ""
    var gender: String = ""
    var birthday: String = ""
    var color: String = ""
    var care: String = ""
    var pedigree: String = ""
    var character: String = ""
    var sterilized: Bool = false
    var vaccinated: Bool = false
    
    var price: Int = 0
    var description: String = ""
    var status: String = ""
    var chat: Bool = false
    var phone: String = ""
    var city: String = ""
    var district: String = ""
    var publicationDateString: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID
        
//        case petID = "petCardID"
        case name = "petName"
        case type = "petType"
        case breed
        case photos
        case gender
        case birthday = "birthDate"
        case color
        case care
        case pedigree
        case character = "petCharacter"
        case sterilized = "sterilization"
        case vaccinated = "vaccinations"
        
        case price
        case description
        case status
        case chat
        case phone
        case city
        case district
        case publicationDateString = "publication"
    }
    
    var convertedPublicationDate: Date {
        ISO8601DateFormatter().date(from: publicationDateString) ?? .now
    }
    
    var formattedPublicationDate: String {
        convertedPublicationDate.formatted(date: .abbreviated, time: .omitted)
    }
    
    private var convertedBirthday: Date {
        ISO8601DateFormatter().date(from: birthday) ?? .now
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

struct AdvertCard: Codable, Identifiable, Equatable, AdvertCommon {
    var id: Int = UUID().hashValue
    var userID: String = ""
    
    var petID: Int = 0
    var name: String = ""
    var type: String = ""
    var breed: String = ""
    var photo: String = ""
    var gender: String = ""
    var birthday: String = ""
    
    var price: Int = 0
    var description: String = ""
    var city: String = ""
    var district: String = ""
    var publicationDateString: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID
        
        case petID = "petCardID"
        case name = "petName"
        case photo = "mainPhoto"
        case gender
        case birthday = "birthDate"
        case type = "petType"
        case breed
        
        case price
        case description
        case city
        case district
        case publicationDateString = "publication"
    }
    
    var convertedPublicationDate: Date {
        ISO8601DateFormatter().date(from: publicationDateString) ?? .now
    }
    
    var formattedPublicationDate: String {
        convertedPublicationDate.formatted(date: .abbreviated, time: .omitted)
    }
    
    private var convertedBirthday: Date {
        ISO8601DateFormatter().date(from: birthday) ?? .now
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

struct AdvertCardList: Codable, Equatable {
    var nextPage: String = ""
    var page: Int = 0
    var total: Int = 0
    var adverts: [AdvertCard] = []
    
    enum CodingKeys: String, CodingKey {
        case nextPage
        case page = "totalPage"
        case total = "totalCount"
        case adverts = "records"
    }
}
