//
//  RootView.swift
//  SNBLA
//
//  Created by Harinder Rana on 09/01/25.
//

import SwiftUI

struct RootView: View {
    @State var selectedTab: Tabs = .home
    
    var body: some View {
        VStack {
            ZStack {
                switch selectedTab {
                case .repStation:
                    RepStationView(viewModel: .mock)
                case .myProgress:
                    CustomNavigationView(appRouter: .init())
                case .tips:
                    TipsView(viewModel: .mock)
                case .home:
                    HomeView()
                }
            }
            .background(Color.clear)
            .zIndex(1)
            
            CustomTabBar(selectedTab: $selectedTab)
            .zIndex(0)
            .padding([.leading, .trailing])
                .background(Color.clear)
        }
        .background(.black)
    }
}
struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
