//
//  MessageBox.swift
//  PetLand
//
//  Created by Никита Сигал on 26.05.2023.
//

import SwiftUI

struct MessageBox: View {
    let message: Message
    let incoming: Bool

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if !incoming {
                Spacer()
                Text(message.timestamp.formatted(date: .omitted, time: .shortened))
                    .font(.cSecondary2)
                    .foregroundColor(.cText)
            }
            Text(message.text)
                .font(.cMain)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(incoming ? Color.cOrange50 : Color.cBlue50)
                .cornerRadius(16)
                .overlay(alignment: .bottom) {
                    HStack {
                        if incoming {
                            Image(systemName: "arrowtriangle.left.fill")
                                .foregroundColor(.cOrange50)
                                .offset(x: -8, y: -1)
                                .rotationEffect(Angle(degrees: -40))
                            Spacer()
                        } else {
                            Spacer()
                            Image(systemName: "arrowtriangle.right.fill")
                                .foregroundColor(.cBlue50)
                                .offset(x: 8, y: -1)
                                .rotationEffect(Angle(degrees: 40))
                        }
                    }
                }
            if incoming {
                Text(message.timestamp.formatted(date: .omitted, time: .shortened))
                    .font(.cSecondary2)
                    .foregroundColor(.cText)
                Spacer()
            }
        }
    }
}

struct MessageBox_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 12) {
            MessageBox(message: .dummy, incoming: true)
            MessageBox(message: .init(text: String.LoremIpsum.long, from: "", to: "", timestamp: .distantPast), incoming: false)
        }
    }
}
