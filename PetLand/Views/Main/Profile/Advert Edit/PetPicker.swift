//
//  PetPicker.swift
//  PetLand
//
//  Created by Никита Сигал on 18.05.2023.
//

import SwiftUI

struct PetPicker: View {
    @EnvironmentObject var config: CustomConfig
    @EnvironmentObject var model: ProfileView.ProfileViewModel

    @Binding var petID: Int

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach(model.pets) { petCard in
                    Button {
                        petID = petCard.id
                    } label: {
                        VStack(alignment: .leading, spacing: 0) {
                            Image("preview:dog")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 120)
                            Text(petCard.name)
                                .lineLimit(2, reservesSpace: true)
                                .font(.cTitle4)
                                .foregroundColor(.cText)
                                .frame(maxWidth: 150, alignment: .leading)
                                .padding(8)
                        }
                        .background(.white)
                        .cornerRadius(12)
                        .shadow(color: (petID == petCard.id ? Color.cGreen : Color.black).opacity(0.25),
                                radius: 6, x: 4, y: 4)
                    }
                }
            }
            .padding(.vertical, 12)
        }
        .scrollIndicators(.hidden)
        .onChange(of: petID) { _ in
            config.isEmpty = false
        }
    }
}

private struct PetPicker_PreviewContainer: View {
    @State var petID: Int = 0
    @State var petIsValid: Bool = false
    @StateObject var model: ProfileView.ProfileViewModel = {
        let obj = ProfileView.ProfileViewModel()
        obj.pets = [.dummy, .init(), .dummy]
        return obj
    }()

    var body: some View {
        CustomWrapper(title: "Питомец", isValid: $petIsValid) {
            PetPicker(petID: $petID)
        }
        .environmentObject(model)
        .padding()
    }
}

struct PetPicker_Previews: PreviewProvider {
    static var previews: some View {
        PetPicker_PreviewContainer()
    }
}
