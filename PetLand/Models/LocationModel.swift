//
//  LocationModel.swift
//  PetLand
//
//  Created by Никита Сигал on 23.05.2023.
//

import Foundation

struct City: Codable, Identifiable {
    var id: Int = UUID().hashValue
    var name: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "city"
    }
}

struct District: Codable, Identifiable {
    var id: Int = UUID().hashValue
    var cityID: Int = 0
    var name: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case cityID
        case name = "district"
    }
}
