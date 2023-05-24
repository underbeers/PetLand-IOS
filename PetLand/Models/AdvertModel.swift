//
//  AdvertModel.swift
//  PetLand
//
//  Created by Никита Сигал on 12.05.2023.
//

import Foundation

struct Advert: Codable, Identifiable, Equatable {
    var id: Int = UUID().hashValue
    var userID: String = ""
    
    var petID: Int = 0
    var photos: [SizedImage] = []
    var name: String = ""
    var type: String = ""
    var breed: String = ""
    var gender: String = ""
    var birthday: Date = .now
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
    var publication: Date = .now
    
    var favourite: Bool = false
    var favouriteID: Int = 0
    
    var formattedPublication: String {
        publication.formatted(date: .abbreviated, time: .omitted)
    }
    
    var age: String {
        let currentDate = Date()
        let deltaSeconds = currentDate.timeIntervalSince(birthday)
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
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID
        
        case petID = "petCardID"
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
        case publication
        
        case favourite = "inFavorites"
        case favouriteID = "favoritesID"
    }
}

struct AdvertCard: Codable, Identifiable, Equatable {
    var id: Int = UUID().hashValue
    var userID: String = ""
    
    var name: String = ""
    var type: String = ""
    var breed: String = ""
    var photo: String = ""
    var gender: String = ""
    var birthday: Date = .now
    
    var price: Int = 0
    var description: String = ""
    var city: String = ""
    var district: String = ""
    var publication: Date = .now
    
    var favourite: Bool = false
    var favouriteID: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID
        
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
        case publication
        
        case favourite = "inFavorites"
        case favouriteID = "favoritesID"
    }
    
    var formattedPublication: String {
        publication.formatted(date: .abbreviated, time: .omitted)
    }
    
    var age: String {
        let currentDate = Date()
        let deltaSeconds = currentDate.timeIntervalSince(birthday)
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

struct AdvertEdit: Codable, Identifiable, Equatable {
    var id: Int = UUID().hashValue
    var petID: Int = 0
    var price: Int = 0
    var description: String = ""
    var city: String = ""
    var cityID: Int = 0
    var district: String = ""
    var districtID: Int = 0
    var chat: Bool = false
    var phone: String = ""
    
    init(_ advert: Advert = .init()) {
        id = advert.id
        petID = advert.petID
        price = advert.price
        description = advert.description
        city = advert.city
        district = advert.district
        chat = advert.chat
        phone = advert.phone
    }
    
    enum CodingKeys: String, CodingKey {
        case petID = "petCardID"
        case price
        case description
        case cityID
        case districtID
        case chat
        case phone
    }
}

protocol AdvertShared {
    var id: Int { get }
    var userID: String { get }
    
    var name: String { get }
    var type: String { get }
    var breed: String { get }
    var gender: String { get }
    var age: String { get }
    
    var price: Int { get }
    var description: String { get }
    var city: String { get }
    var district: String { get }
    var formattedPublication: String { get }
    
    var favourite: Bool { get }
    var favouriteID: Int { get }
}

extension Advert: AdvertShared {}
extension AdvertCard: AdvertShared {}
