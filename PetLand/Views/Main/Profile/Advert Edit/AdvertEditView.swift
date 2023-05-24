//
//  AdvertEditView.swift
//  PetLand
//
//  Created by Никита Сигал on 17.05.2023.
//

import SwiftUI

struct AdvertEditView: View {
    @Environment(\.dismiss) var dismiss
    
    private let initialAdvert: Advert?
    
    init(_ initialAdvert: Advert? = nil) {
        self.initialAdvert = initialAdvert
    }
    
    @StateObject var model: AdvertEditViewModel = .init()
    @State var cardIsValid: Bool = false
    @State var descriptionIsValid: Bool = false
    @State var priceIsValid: Bool = false
    @State var contactsAreValid: Bool = false
    @State var cityIsValid: Bool = false
    @State var districtIsValid: Bool = false
    
    var canCommit: Bool {
        (initialAdvert != nil || cardIsValid)
            && descriptionIsValid
            && priceIsValid
            && contactsAreValid
            && cityIsValid
            && districtIsValid
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if initialAdvert == nil {
                    CustomWrapper(title: "Питомец", isValid: $cardIsValid) {
                        PetPicker(petID: $model.advert.petID)
                    }
                }
                
                CustomWrapper(title: "Цена", isValid: $priceIsValid) {
                    PricePicker(price: $model.advert.price)
                }
                    
                CustomWrapper(title: "Описание", isValid: $descriptionIsValid) {
                    CustomTextArea(placeholder: "Добавьте описание объявления", text: $model.advert.description)
                }
                
                CustomWrapper(title: "Контакты", isValid: $contactsAreValid) {
                    ContactsPicker(useMessenger: $model.advert.chat, phone: $model.advert.phone)
                }
                
                CustomWrapper(title: "Город", isValid: $cityIsValid) {
                    CustomDropdown(options: model.cities.map { $0.name }, selection: $model.advert.city)
                }
                .onChange(of: model.advert.city) { _ in
                    model.fetchDistricts()
                }
                .onChange(of: model.districts) { _ in
                    if !model.districts.contains(where: { $0.name == model.advert.district }) {
                        model.advert.district = ""
                    }
                }
                
                CustomWrapper(title: "Район", isValid: $districtIsValid) {
                    CustomDropdown(options: model.districts.map { $0.name }, selection: $model.advert.district)
                }
                .disabled(!cityIsValid)
                
                Button(initialAdvert == nil ? "Опубликовать объявление" : "Сохранить изменения") {
                    model.commitAdvert(isNew: initialAdvert == nil) {
                        dismiss()
                    }
                }
                .buttonStyle(CustomButton(.primary, isEnabled: canCommit))
                .disabled(!canCommit)
            }
            .padding(16)
            .padding(.bottom, 32)
        }
        .navigationTitle(initialAdvert == nil ? "Создание объявления" : "Редактирование объявления")
        .animation(.spring(), value: model.advert)
        .animation(.spring(), value: canCommit)
        .onAppear {
            if let initialAdvert {
                model.advert = .init(initialAdvert)
            }
            model.fetchCities()
        }
        .alert("Что-то пошло не так...", isPresented: $model.presentingAlert) {
            Text(model.alertMessage)
        }
    }
}

struct AdvertEditView_Previews: PreviewProvider {
    static var previews: some View {
        AdvertEditView()
        AdvertEditView(.dummy)
        AdvertEditView(.init(price: -1))
    }
}
