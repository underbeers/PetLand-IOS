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
                            Button("Объявления") {}
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.cGreen)
                            Button("Потеряшки") {}
                                .foregroundColor(.cGreen)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(.white)
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

                    LazyVGrid(columns: Array(repeating: .init(spacing: 20), count: 2), spacing: 20)
                        {
                            ForEach(model.advertList.adverts) { advert in
                                VStack(alignment: .leading, spacing: 0) {
                                    Image("preview:dog")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(minWidth: 0)
                                        .aspectRatio(4 / 3, contentMode: .fill)
                                        .clipped()
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(advert.name)
                                            .font(.cTitle4)
                                            .foregroundColor(.cText)
                                        Text(asCurrency(advert.price as NSNumber))
                                            .font(.cMain)
                                            .foregroundColor(.cText)
                                        Text(advert.formattedPublicationDate)
                                            .font(.cSecondary2)
                                            .foregroundColor(.cBlue)
                                        Text(advert.district)
                                            .font(.cSecondary2)
                                            .foregroundColor(.cBlue)
                                    }
                                    .padding(8)
                                }
                                .background(.white)
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.25), radius: 6, x: 4, y: 4)
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
        .alert("Что-то пошло не так...",isPresented: $model.presentingAlert) {
            Text(model.alertMessage)
        }
    }
}

struct AdvertsView_Previews: PreviewProvider {
    static var previews: some View {
        AdvertsView()
    }
}
