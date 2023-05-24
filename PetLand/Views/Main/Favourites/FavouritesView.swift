//
//  FavouritesView.swift
//  PetLand
//
//  Created by Никита Сигал on 05.05.2023.
//

import SwiftUI

struct FavouritesView: View {
    @StateObject var model: FavouritesViewModel = .init()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Switcher
                    HStack(spacing: 0) {
                        Button("Объявления") {
                            model.currentMode = .adverts
                        }
                        .foregroundColor(model.currentMode == .adverts ? .white : .cGreen)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(model.currentMode == .adverts ? Color.cGreen : Color.white)
                        
                        Rectangle()
                            .frame(width: 1)
                            .foregroundColor(.cGreen)
                        
                        Button("Cпециалисты") {
                            model.currentMode = .specialists
                        }
                        .foregroundColor(model.currentMode == .specialists ? .white : .cGreen)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(model.currentMode == .specialists ? Color.cGreen : Color.white)
                        
                        Rectangle()
                            .frame(width: 1)
                            .foregroundColor(.cGreen)
                        
                        Button("Организации") {
                            model.currentMode = .organizations
                        }
                        .foregroundColor(model.currentMode == .organizations ? .white : .cGreen)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(model.currentMode == .organizations ? Color.cGreen : Color.white)
                    }
                    .font(.cMain)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.cGreen, lineWidth: 3)
                    }
                    .cornerRadius(12)
                    .animation(.spring(), value: model.currentMode)

                    // Grid
                    switch model.currentMode {
                        case .adverts:
                            LazyVGrid(columns: Array(repeating: .init(spacing: 20), count: 2), spacing: 20) {
                                ForEach($model.favourites.adverts) { $advertCard in
                                    NavigationLink {
                                        AdvertDetailView(advertCard)
                                    } label: {
                                        AdvertCardView(advertCard: $advertCard)
                                    }
                                }
                            }
                        default:
                            Text("Favourite Placeholder")
                    }
                }
                .padding(16)
                .padding(.bottom, 32)
            }
            .navigationTitle("Избранное")
            .animation(.spring(), value: model.favourites)
            .animation(.spring(), value: model.currentMode)
        }
        .accentColor(.cOrange)
        .onAppear {
            model.fetchFavourites()
        }
    }
}

struct FavouritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesView()
    }
}
