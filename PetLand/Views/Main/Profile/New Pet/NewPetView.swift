//
//  NewPetView.swift
//  PetLand
//
//  Created by Никита Сигал on 08.05.2023.
//

import SwiftUI

struct NewPetView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var model: NewPetViewModel = .init()
    @State var nameIsValid: Bool = false
    @State var typeIsValid: Bool = false
    @State var breedIsValid: Bool = false
    @State var genderIsValid: Bool = false
    @State var birthdayIsValid: Bool = false
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
    
    private var canCreatePet: Bool {
        nameIsValid
            && typeIsValid
            && breedIsValid
            && genderIsValid
            && birthdayIsValid
            && colorIsValid
            && careIsValid
            && pedigreeIsValid
            && characterIsValid
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
                        model.restoreTypeID()
                        model.fetchBreeds()
                    }
                    
                    CustomWrapper(title: "Порода", isValid: $breedIsValid) {
                        CustomDropdown(options: model.breeds.map { $0.breed }, selection: $model.pet.breed)
                    }
                    .disabled(!typeIsValid)
                    .onChange(of: model.pet.breed) { _ in
                        model.restoreBreedID()
                    }
                }
                
                CustomWrapper(title: "Пол", isValid: $genderIsValid) {
                    CustomDropdown(options: ["Мальчик", "Девочка"], selection: $model.pet.gender)
                }
                
                CustomWrapper(title: "Дата рождения", tip: "Если не знаете точную дату, выбирайте примерную", isValid: $birthdayIsValid) {
                    CustomDatePicker(selection: $model.birthday)
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
                

                Button("Создать питомца") {
                    model.createPet()
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(CustomButton(.primary, isEnabled: canCreatePet))
                .padding(.vertical, 16)
                .disabled(!canCreatePet)
            }
            .padding(16)
        }
        .navigationTitle("Новый питомец")
        .scrollDismissesKeyboard(.interactively)
        .animation(.default, value: canCreatePet)
        .onAppear {
            model.fetchTypes()
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button("Готово") { currentFocus = nil }
                    .buttonStyle(CustomButton(.text))
            }
        }
    }
}

struct NewPetView_Previews: PreviewProvider {
    static var previews: some View {
        NewPetView()
    }
}
