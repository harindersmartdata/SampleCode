//
//  AppButton.swift
//  LacrosseApp
//
//  Created by Harinder Rana on 20/03/25.
//

import SwiftUI

struct AppButton: View {
    var buttonTitle: String = ""
    var action: () -> Void = {}
    var imageName: String = "rightArrow"
    
    private var backgroundColor: Color {
        .appRed
    }
    
    private var foregroundColor: Color {
        .white
    }

    var body: some View {
        Button(action: {
            action() // Perform the custom action
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) // Dismiss keyboard
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(backgroundColor)
                    .frame(width: UIScreen.main.bounds.width - 48, height: 56)

                HStack(spacing: 8) {
                    Text(LocalizedStringKey(buttonTitle))
                        .foregroundColor(foregroundColor)
                        .font(.custom(FontFamily.jostSemiBold, size: 18))
                    
                    Image(imageName)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(foregroundColor)
                }
            }
        }
        .padding(.bottom, 15)
    }
}

#Preview {
    AppButton(buttonTitle: "Let’s Go!", action: {
        print("Valid button tapped")
    })
}
