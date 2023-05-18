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
    
    var canCommit: Bool {
        (initialAdvert != nil || cardIsValid)
            && descriptionIsValid
            && priceIsValid
            && contactsAreValid
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
