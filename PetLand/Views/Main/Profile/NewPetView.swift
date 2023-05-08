//
//  NewPetView.swift
//  PetLand
//
//  Created by Никита Сигал on 08.05.2023.
//

import SwiftUI

struct NewPetView: View {
    @State var text: String = ""
    @State var isValid: Bool = false

    var body: some View {
        ScrollView {
            CustomWrapper(title: "Окрас", tip: "Опишите окрас вашего питомца", isValid: $isValid) {
                CustomTextArea(placeholder: "Введите окрас", text: $text)
            }
        }
        .navigationTitle("Новый питомец")
        .padding()
    }
}

struct NewPetView_Previews: PreviewProvider {
    static var previews: some View {
        NewPetView()
    }
}
