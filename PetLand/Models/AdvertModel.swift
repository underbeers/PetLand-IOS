//
//  AdvertModel.swift
//  PetLand
//
//  Created by Никита Сигал on 12.05.2023.
//

import Foundation

struct AdvertCard: Codable, Identifiable, Equatable {
    var id: Int = UUID().hashValue
    var petID: Int = 0
    var name: String = ""
    var photo: String = ""
    var price: Int = 0
    var city: String = ""
    var district: String = ""
    var publicationDateString: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case petID
        case name = "petName"
        case photo = "mainPhoto"
        case price
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
