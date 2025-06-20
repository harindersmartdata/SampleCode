//
//  TabBarButton.swift
//  SNBLA
//
//  Created by Harinder Rana on 08/01/25.
//

import SwiftUI

struct TabBarButton: View {
    var iconName: String
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack {
                Image(iconName)
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 20, height: 20)
                    .foregroundColor(!isSelected ? .appCell : .white)
                
                Text(LocalizedStringKey(title))
                    .font(.caption)
                    .foregroundColor(!isSelected ? .appCell : .white)
            }
        }
    }
}
