//
//  BookmarksImage.swift
//  PetLand
//
//  Created by Никита Сигал on 29.05.2023.
//

import SwiftUI

struct BookmarksImage: View {
    let size: CGFloat
    
    init(_ size: CGFloat = 24) {
        self.size = size
    }
    
    var body: some View {
        Image("icons:bookmark")
            .resizable()
            .renderingMode(.template)
            .frame(width: size, height: size)
            .foregroundColor(.cOrange50)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.cOrange400)
            .clipShape(Circle())
    }
}

struct BookmarksImage_Previews: PreviewProvider {
    static var previews: some View {
        BookmarksImage()
    }
}
