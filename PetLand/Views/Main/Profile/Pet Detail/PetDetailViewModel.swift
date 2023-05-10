//
//  PetDetailViewModel.swift
//  PetLand
//
//  Created by Никита Сигал on 10.05.2023.
//

import Foundation
import SwiftUI

extension PetDetailView {
    @MainActor final class PetDetailViewModel: ObservableObject {
        @Published var pet: Pet = .init()

        func fetchInfoBy(id: Int) {
//            pet = .dummy
        }
    }
}
