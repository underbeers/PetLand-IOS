//
//  CurrencyFormatter.swift
//  PetLand
//
//  Created by Никита Сигал on 12.05.2023.
//

import Foundation

func asCurrency(_ number: NSNumber) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.maximumFractionDigits = 0
    formatter.locale = Locale(identifier: "ru_RU")

    return formatter.string(from: number) ?? "Ошибка"
}
