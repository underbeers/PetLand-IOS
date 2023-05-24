//
//  AdvertCardView.swift
//  PetLand
//
//  Created by Никита Сигал on 16.05.2023.
//

import SwiftUI

struct AdvertCardView: View {
    @Binding var advertCard: AdvertCard
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image("preview:dog")
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0)
                .aspectRatio(4 / 3, contentMode: .fill)
                .clipped()
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 0) {
                    Text(advertCard.name)
                        .lineLimit(1)
                        .font(.cTitle4)
                        .foregroundColor(.cText)
                    Spacer()
                    Button {
                        advertCard.favourite.toggle()
                    } label: {
                        Image(advertCard.favourite ? "icons:heart:fill" : "icons:heart")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 24, height: 24)
                            .foregroundColor(.cRed)
                    }
                }
                Text(asCurrency(advertCard.price as NSNumber))
                    .font(.cMain)
                    .foregroundColor(.cText)
                Text(advertCard.formattedPublication)
                    .font(.cSecondary2)
                    .foregroundColor(.cBlue)
                Text(advertCard.city + "\n" + advertCard.district)
                    .lineLimit(2, reservesSpace: true)
                    .multilineTextAlignment(.leading)
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


struct AdvertCardView_Previews: PreviewProvider {
    static var previews: some View {
        LazyVGrid(columns: [GridItem(), GridItem()]) {
            AdvertCardView(advertCard: .constant(.dummy))
            AdvertCardView(advertCard: .constant(.init(favourite: true)))
        }
        .padding()
    }
}
