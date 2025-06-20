//
//  CustomBackgroundView.swift
//  LacrosseApp
//
//  Created by Harinder Rana on 20/03/25.
//

import SwiftUI

struct CustomBackgroundView: View {
    let imageName: String

    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: 350)
                .clipped()
            
            Spacer() // Pushes the rest of the content down
        }
        .ignoresSafeArea(edges: .top)
    }
}
