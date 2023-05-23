//
//  FiltersView.swift
//  PetLand
//
//  Created by Никита Сигал on 16.05.2023.
//

import SwiftUI

struct FiltersView: View {
    @EnvironmentObject var model: AdvertsView.AdvertsViewModel
    @Environment(\.dismiss) var dismiss

    @State var typeIsValid: Bool = false
    @State var breedIsValid: Bool = false
    @State var minPriceIsValid: Bool = false
    @State var maxPriceIsValid: Bool = false
    @State var cityIsValid: Bool = false
    @State var districtIsValid: Bool = false

    var canApply: Bool {
        typeIsValid
            && breedIsValid
            && minPriceIsValid
            && maxPriceIsValid
            && cityIsValid
            && districtIsValid
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                CustomWrapper(title: "Вид", isValid: $typeIsValid, required: false) {
                    CustomDropdown(options: ["Не выбрано"] + model.types.map { $0.type }, selection: $model.filterType)
                }
                .onChange(of: model.filterType) { _ in
                    model.fetchBreeds()
                }
                .onChange(of: model.breeds) { _ in
                    if !model.breeds.contains(where: { $0.breed == model.filterBreed }) {
                        model.filterBreed = ""
                    }
                }

                CustomWrapper(title: "Порода", isValid: $breedIsValid, required: false) {
                    CustomDropdown(options: ["Не выбрано"] + model.breeds.map { $0.breed }, selection: $model.filterBreed)
                }
                .disabled(!typeIsValid)

                HStack(alignment: .bottom, spacing: 16) {
                    CustomWrapper(title: "Цена", isValid: $minPriceIsValid, required: false) {
                        CustomTextField(.someInteger(String(0), range: 0 ... 999_999), text: $model.filterMinPriceString)
                    }
                    CustomWrapper(isValid: $maxPriceIsValid, required: false) {
                        CustomTextField(.someInteger(String(999_999), range: 0 ... 999_999), text: $model.filterMaxPriceString)
                    }
                }

                CustomWrapper(title: "Город", isValid: $cityIsValid, required: false) {
                    CustomDropdown(options: ["Не выбрано"] + model.cities.map { $0.name }, selection: $model.filterCity)
                }
                .onChange(of: model.filterCity) { _ in
                    model.fetchDistricts()
                }
                .onChange(of: model.districts) { _ in
                    if !model.districts.contains(where: { $0.name == model.filterDistrict }) {
                        model.filterDistrict = ""
                    }
                }

                CustomWrapper(title: "Район", isValid: $districtIsValid, required: false) {
                    CustomDropdown(options: ["Не выбрано"] + model.districts.map { $0.name }, selection: $model.filterDistrict)
                }
                .disabled(!cityIsValid)
                
                Spacer()

                Button("Применить") {
                    dismiss()
                }
                .buttonStyle(CustomButton(.primary, isEnabled: canApply))
                .disabled(!canApply)
            }
            .padding(16)
            .navigationTitle("Фильтры")
            .navigationBarTitleDisplayMode(.inline)
        }
        .interactiveDismissDisabled(!canApply)
        .presentationDragIndicator(.visible)
        .animation(.default, value: canApply)
        .onAppear {
            model.fetchTypes()
            model.fetchCities()
        }
        .onDisappear {
            model.fetchAdvertCards()
        }
    }
}

struct FiltersView_Previews: PreviewProvider {
    static var previews: some View {
        FiltersView()
            .environmentObject(AdvertsView.AdvertsViewModel())
    }
}
