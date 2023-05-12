//
//  AdvertsViewModel.swift
//  PetLand
//
//  Created by Никита Сигал on 12.05.2023.
//

import Foundation

extension AdvertsView {
    @MainActor final class AdvertsViewModel: ObservableObject {
        enum Mode {
            case sold,
                 found
        }

        @Published var currentMode: Mode = .sold
        @Published var sorting: String = "Сначала новые"
        @Published var advertList: AdvertCardList = .dummy
        
        @Published var presentingFilters: Bool = false
        
        @Published var alertMessage: String = ""
        @Published var presentingAlert: Bool = false
    }
}
