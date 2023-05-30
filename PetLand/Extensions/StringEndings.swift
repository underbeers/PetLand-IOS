//
//  StringEndings.swift
//  PetLand
//
//  Created by Никита Сигал on 07.05.2023.
//

import Foundation

extension String {
    enum Ending {
        case wi,
             ec,
             oe,
             ie,
             photograph,
             day,
             month,
             year
        
        var variants: [String] {
            switch self {
                case .wi:
                    return ["ых", "ый", "ых"]
                case .ec:
                    return ["цев", "ец", "ца"]
                case .oe:
                    return ["ых", "ое", "ых"]
                case .ie:
                    return ["ий", "ие", "ия"]
                case .photograph:
                    return ["ий", "ия", "ии"]
                case .day:
                    return ["дней", "день", "дня"]
                case .month:
                    return ["месяцев", "месяц", "месяца"]
                case .year:
                    return ["лет", "год", "года"]
            }
        }
    }
    
    func ending(for number: Int, with ending: Ending) -> String {
        let tens = number / 10
        let ones = number % 10
        let variants = ending.variants
        
        var ending: String
        
        if tens == 1 || ones == 0 || 5 ... 9 ~= ones {
            ending = variants[0]
        } else if ones == 1 {
            ending = variants[1]
        } else {
            ending = variants[2]
        }
        
        return self + ending
    }
}
