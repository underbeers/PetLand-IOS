//
//  PetEditView.swift
//  PetLand
//
//  Created by Никита Сигал on 08.05.2023.
//

import SwiftUI

struct PetEditView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    private let initialPet: Pet?
    
    init(initialPet pet: Pet? = nil) {
        self.initialPet = pet
    }
    
    @StateObject var model: PetEditViewModel = .init()
    @State var nameIsValid: Bool = false
    @State var typeIsValid: Bool = false
    @State var breedIsValid: Bool = false
    @State var genderIsValid: Bool = false
    @State var birthdayIsValid: Bool = false
    @State var imagesAreValid: Bool = false
    @State var colorIsValid: Bool = false
    @State var careIsValid: Bool = false
    @State var pedigreeIsValid: Bool = false
    @State var characterIsValid: Bool = false
    
    private enum Focusable {
        case name,
             color,
             care,
             pedigree,
             charcter
    }

    @FocusState private var currentFocus: Focusable?
    
    private var canProceed: Bool {
        nameIsValid
            && typeIsValid
            && breedIsValid
            && genderIsValid
            && birthdayIsValid
            && imagesAreValid
            && colorIsValid
            && careIsValid
            && pedigreeIsValid
            && characterIsValid
    }
    
    private var isNew: Bool {
        initialPet == nil
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                CustomWrapper(title: "Кличка", isValid: $nameIsValid) {
                    CustomTextField(.someText("Введите имя питомца"), text: $model.pet.name)
                }
                .focused($currentFocus, equals: .name)
                
                Group {
                    CustomWrapper(title: "Вид", isValid: $typeIsValid) {
                        CustomDropdown(options: model.types.map { $0.type }, selection: $model.pet.type)
                    }
                    .onChange(of: model.pet.type) { _ in
                        model.fetchBreeds()
                    }
                    .onChange(of: model.breeds) { _ in
                        if !model.breeds.contains(where: { $0.breed == model.pet.breed }) {
                            model.pet.breed = ""
                        }
                    }
                    
                    CustomWrapper(title: "Порода", isValid: $breedIsValid) {
                        CustomDropdown(options: model.breeds.map { $0.breed }, selection: $model.pet.breed)
                    }
                    .disabled(!typeIsValid)
                }
                
                CustomWrapper(title: "Пол", isValid: $genderIsValid) {
                    CustomDropdown(options: ["Мальчик", "Девочка"], selection: $model.pet.gender)
                }
                
                CustomWrapper(title: "Дата рождения", tip: "Если не знаете точную дату, выбирайте примерную", isValid: $birthdayIsValid) {
                    CustomDatePicker(selection: $model.pet.birthday)
                }
                
                if isNew {
                    CustomWrapper(title: "Фотография", isValid: $imagesAreValid) {
                        PetImagePicker(images: $model.images)
                    }
                }
                
                Group {
                    CustomWrapper(title: "Окрас", isValid: $colorIsValid, required: false) {
                        CustomTextArea(placeholder: "Опишите окрас питомца", text: $model.pet.color)
                    }
                    .focused($currentFocus, equals: .color)
                    
                    CustomWrapper(title: "Особенности ухода", isValid: $careIsValid, required: false) {
                        CustomTextArea(placeholder: "Расскажите про уход", text: $model.pet.care)
                    }
                    .focused($currentFocus, equals: .care)
                }
                
                if ["Кошка", "Собака"].contains(model.pet.type) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Для кошек и собак Вы можете добавить дополнительную информацию")
                            .font(.cMain)
                            .foregroundColor(.cText)
                        HStack(spacing: 32) {
                            Toggle("Стерилизация", isOn: $model.pet.sterilized)
                            Toggle("Вакцинация", isOn: $model.pet.vaccinated)
                        }
                        .toggleStyle(CustomCheckbox())
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 16)
                }
                
                Group {
                    CustomWrapper(title: "Родословная", isValid: $pedigreeIsValid, required: false) {
                        CustomTextArea(placeholder: "Расскажите про родословную", text: $model.pet.pedigree)
                    }
                    .focused($currentFocus, equals: .pedigree)
                    
                    CustomWrapper(title: "Черты характера", isValid: $characterIsValid, required: false) {
                        CustomTextArea(placeholder: "Расскажите про черты характера", text: $model.pet.character)
                    }
                    .focused($currentFocus, equals: .charcter)
                }
                
                Button(initialPet == nil ? "Создать питомца" : "Сохранить изменения") {
                    model.commitPet(isNew: initialPet == nil) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .buttonStyle(CustomButton(.primary, isEnabled: canProceed))
                .padding(.vertical, 16)
                .disabled(!canProceed)
            }
            .padding(16)
        }
        .navigationTitle(isNew ? "Новый питомец" : "Редактирование питомца")
        .scrollDismissesKeyboard(.interactively)
        .animation(.default, value: canProceed)
        .onAppear {
            if let initialPet {
                model.pet = initialPet
            }
            model.fetchTypes()
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button("Готово") { currentFocus = nil }
                    .buttonStyle(CustomButton(.text))
            }
        }
        .alert("Что-то пошло не так...", isPresented: $model.presentingAlert) {
            Text(model.alertMessage)
        }
    }
}

struct PetEditView_Previews: PreviewProvider {
    static var previews: some View {
        PetEditView()
        PetEditView(initialPet: .dummy)
    }
}
