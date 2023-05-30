//
//  PetImagePicker.swift
//  PetLand
//
//  Created by Никита Сигал on 18.05.2023.
//

import PhotosUI
import SwiftUI

struct PetImagePicker: View {
    @EnvironmentObject var config: CustomConfig

    @Binding var images: [PhotosPickerItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Первая фотография будет на аватарке питомца")
                .font(.cSecondary1)
                .foregroundColor(.cSubtext)
            HStack(spacing: 12) {
                PhotosPicker(selection: $images,
                             maxSelectionCount: 5,
                             selectionBehavior: .ordered,
                             matching: .images,
                             photoLibrary: .shared())
                {
                    Text("Выбрать")
                        .font(.cButton)
                        .foregroundColor(.cGreen)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.cGreen, lineWidth: 1))
                }
                Text(images.isEmpty ? "Не выбрано" : "\(images.count) фотограф".ending(for: images.count, with: .photograph))
                    .font(.cSecondary1)
                    .foregroundColor(.cText)
                Spacer()
            }
        }
        .onChange(of: images) { newValue in
            config.isEmpty = images.isEmpty
        }
    }
}

private struct PetImagePicker_PreviewContainer: View {
    @State var isImageValid: Bool = false
    @State var images: [PhotosPickerItem] = []

    var body: some View {
        CustomWrapper(title: "Фотография", isValid: $isImageValid) {
            PetImagePicker(images: $images)
        }
        .padding()
    }
}

struct PetImagePicker_Previews: PreviewProvider {
    static var previews: some View {
        PetImagePicker_PreviewContainer()
    }
}
