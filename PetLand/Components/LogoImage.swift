//
//  LogoImage.swift
//  PetLand
//
//  Created by Никита Сигал on 01.05.2023.
//

import SwiftUI

struct LogoImage: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            Image("petland:cutelogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
            Image("petland:titletext")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 40)
        }
        .frame(height: 200)
    }
}

struct PetlandLogo_Previews: PreviewProvider {
    static var previews: some View {
        LogoImage()
    }
}
