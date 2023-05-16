//
//  AdvertsView.swift
//  PetLand
//
//  Created by Никита Сигал on 05.05.2023.
//

import SwiftUI

struct AdvertsView: View {
    @EnvironmentObject var appState: AppState

    @StateObject private var model: AdvertsViewModel = .init()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    VStack(spacing: 16) {
                        // Switcher
                        HStack(spacing: 0) {
                            Button("Объявления") {
                                model.currentMode = .sold
                            }
                            .foregroundColor(model.currentMode == .sold ? .white : .cGreen)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(model.currentMode == .sold ? Color.cGreen : Color.white)
                            Button("Потеряшки") {
                                model.currentMode = .found
                            }
                            .foregroundColor(model.currentMode == .found ? .white : .cGreen)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(model.currentMode == .found ? Color.cGreen : Color.white)
                        }
                        .font(.cMain)
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.cGreen, lineWidth: 3)
                        }
                        .cornerRadius(12)

                        // Filters and Sorting
                        HStack(spacing: 16) {
                            Button {
                                model.presentingFilters = true
                            } label: {
                                Label {
                                    Text("Фильтры")
                                } icon: {
                                    Image("icons:filter")
                                }
                            }

                            Menu {
                                Picker(selection: $model.sorting, label: EmptyView()) {
                                    ForEach(["Сначала новые", "Сначала дешевые", "Сначала дорогие"], id: \.self) { option in
                                        Text(option)
                                    }
                                }
                            } label: {
                                Label {
                                    Text(model.sorting)
                                } icon: {
                                    Image("icons:sort")
                                }
                            }

                            Spacer()
                        }
                        .font(.cButton)
                        .foregroundColor(.cText)
                    }

                    LazyVGrid(columns: Array(repeating: .init(spacing: 20), count: 2), spacing: 20) {
                        ForEach(model.advertList.adverts) { advertCard in
                            NavigationLink {
                                Text("Advert Detail Placeholder for '\(advertCard.name)'")
                            } label: {
                                AdvertCardView(advertCard: advertCard)
                            }
                        }
                    }
                }
                .padding(16)
            }
            .navigationTitle("Доска объявлений")
        }
        .sheet(isPresented: $model.presentingFilters) {
            NavigationStack {
                VStack {
                    Text("Filters Placeholder")
                }
                .navigationTitle("Фильтры")
            }
            .presentationDragIndicator(.visible)
        }
        .alert("Что-то пошло не так...", isPresented: $model.presentingAlert) {
            Text(model.alertMessage)
        }
        .onAppear {
            model.fetchAdvertCards()
        }
    }
}

struct AdvertsView_Previews: PreviewProvider {
    static var previews: some View {
        AdvertsView()
    }
}
