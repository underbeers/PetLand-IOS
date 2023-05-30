//
//  AdvertCardView.swift
//  PetLand
//
//  Created by Никита Сигал on 16.05.2023.
//

import SwiftUI

struct AdvertCardView: View {
    @StateObject var model: AdvertCardViewModel = .init()
    @Binding var advertCard: AdvertCard

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            CustomImage(advertCard.photo) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity,
                           minHeight: 0, maxHeight: .infinity)
                    .allowsHitTesting(false)
            }
            .aspectRatio(4 / 3, contentMode: .fit)
            .clipped()

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 0) {
                    Text(advertCard.name)
                        .lineLimit(1)
                        .font(.cTitle4)
                        .foregroundColor(.cText)
                    Spacer()
                    Button {
                        model.toggleFavourite()
                    } label: {
                        Image(advertCard.favouriteID != 0 ?"icons:heart:fill" : "icons:heart")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 24, height: 24)
                            .foregroundColor(.cRed)
                    }
                }
                Group {
                    if advertCard.price < 0 {
                        Text("Цена договорная")
                    } else if advertCard.price == 0 {
                        Text("Бесплатно")
                    } else {
                        Text(asCurrency(advertCard.price as NSNumber))
                    }
                }
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
        .animation(.spring(), value: advertCard)
        .onAppear {
            model.advertCardBinding = $advertCard
        }
    }
}

struct AdvertCardView_Previews: PreviewProvider {
    static var previews: some View {
        LazyVGrid(columns: [GridItem(), GridItem()]) {
            AdvertCardView(advertCard: .constant(.dummy))
        }
        .padding()
    }
}
