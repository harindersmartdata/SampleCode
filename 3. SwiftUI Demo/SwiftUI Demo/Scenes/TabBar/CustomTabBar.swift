//
//  CustomTabBar.swift
//  SNBLA
//
//  Created by Harinder Rana on 08/01/25.
//

import SwiftUI


enum Tabs: Int {
    case repStation = 0
    case myProgress = 1
    case tips = 2
    case home = 3
}

struct CustomTabBar: View {
    @Binding var selectedTab: Tabs
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(.appHeader)
                .shadow(radius: 2)
            
            HStack {
                Spacer()
                
                TabBarButton(
                    iconName: "home",
                    title: "Home",
                    isSelected: selectedTab == .home,
                    action: { selectedTab = .home }
                )
                Spacer()
                
                TabBarButton(
                    iconName: "tips",
                    title: "Trackr Tips",
                    isSelected: selectedTab == .tips,
                    action: { selectedTab = .tips }
                )
                Spacer()
                
                TabBarButton(
                    iconName: "myProgress",
                    title: "My Progress",
                    isSelected: selectedTab == .myProgress,
                    action: { selectedTab = .myProgress }
                )
                
                Spacer()
            }
        }
        .frame(height: 60)
    }
}



struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar(selectedTab: .constant(.myProgress))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
