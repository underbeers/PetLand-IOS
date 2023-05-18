//
//  PricePicker.swift
//  PetLand
//
//  Created by Никита Сигал on 18.05.2023.
//

import SwiftUI

struct PricePicker: View {
    @EnvironmentObject var config: CustomConfig

    @Binding var price: Int
    @State var priceStringIsValid: Bool = false
    @State var priceByAgreement: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !priceByAgreement {
                CustomWrapper(isValid: $priceStringIsValid, required: false) {
                    CustomTextField(.someInteger("0", range: 0 ... 999_999), text: Binding(get: {
                        String(price)
                    }, set: { newValue in
                        price = newValue.isEmpty ? 0 : Int(newValue) ?? price
                    }))
                }
            }
            Toggle("По договоренности", isOn: $priceByAgreement)
                .toggleStyle(CustomCheckbox())
        }
        .onAppear {
            config.isEmpty = false
        }
        .animation(.spring(), value: priceByAgreement)
        .onChange(of: priceByAgreement) { newValue in
            price = newValue ? -1 : 0
        }
        .onChange(of: price) { newValue in
            priceByAgreement = newValue < 0
        }
    }
}

private struct PricePicker_PreviewContainer: View {
    @State var price: Int = 0
    @State var priceIsValid: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            CustomWrapper(title: "Цена", isValid: $priceIsValid) {
                PricePicker(price: $price)
            }
            Text(String(priceIsValid))
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

struct PricePicker_Previews: PreviewProvider {
    static var previews: some View {
        PricePicker_PreviewContainer()
    }
}
