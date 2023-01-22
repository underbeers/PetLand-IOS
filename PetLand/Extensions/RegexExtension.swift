//
//  RegexExtension.swift
//  PetLand
//
//  Created by Никита Сигал on 13.01.2023.
//

import Foundation

extension Regex {
    func check(for input: String) -> Bool {
        if let _ = try? wholeMatch(in: input) { return true }
        else { return false }
    }
}
