//
//  FavouriteModel.swift
//  PetLand
//
//  Created by Никита Сигал on 24.05.2023.
//

import Foundation

struct Favourites: Codable, Equatable {
    var adverts: [AdvertCard] = []
}
