//
//  CustomImage.swift
//  PetLand
//
//  Created by Никита Сигал on 30.05.2023.
//

import CachedAsyncImage
import SwiftUI

struct CustomImage<Content: View>: View {
    let url: URL?
    let content: (Image) -> Content

    init(_ urlString: String, @ViewBuilder _ content: @escaping (Image) -> Content) {
        self.url = URL(string: urlString)
        self.content = content
    }

    var body: some View {
        if let url {
            CachedAsyncImage(url: url) { image in
                content(image)
            } placeholder: {
                ZStack {
                    Color.cBase200
                    ProgressView()
                }
            }
        } else {
            Color.cBase200
        }
    }
}

struct CustomImage_Previews: PreviewProvider {
    static let url = "http://res.cloudinary.com/dojhrhddc/image/upload/v1685471710/go-cloudinary/ot1rzel5e2z4bavb5u8j.jpg"
    static var previews: some View {
        CustomImage(url) { image in
            image
                .resizable()
                .scaledToFit()
        }
    }
}
