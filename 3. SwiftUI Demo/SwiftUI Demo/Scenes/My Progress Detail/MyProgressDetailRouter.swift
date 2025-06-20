//
//  MyProgressDetailRouter.swift
//  LacrosseApp
//
//  Created by Harinder Rana on 21/03/25.
//

import SwiftUI


class MyProgressDetailRouter {
    
    private let rootCoordinator: NavigationCoordinator

    let historyData: [ShotData]
    let date: String

    init(rootCoordinator: NavigationCoordinator, data: [ShotData], date: String){
        self.rootCoordinator = rootCoordinator
        self.historyData = data
        self.date = date
    }
    
    func routeToPopBack() {
        rootCoordinator.popLast()
    }
    
    
}

// MARK: - ViewFactory implementation

extension MyProgressDetailRouter: Routable {
    
    func makeView() -> AnyView {
        let viewModel = MyProgressDetailViewModel(router: self, data: historyData, date: date)
        let view = MyProgressDetailView(viewModel: viewModel)
        return AnyView(view)
    }
}

// MARK: - Hashable implementation

extension MyProgressDetailRouter {
    static func == (lhs: MyProgressDetailRouter, rhs: MyProgressDetailRouter) -> Bool {
        true
    }
    
    func hash(into hasher: inout Hasher) {
      //  hasher.combine(self.user.uid)
    }
}

// MARK: - Router mock for preview
//
extension MyProgressDetailRouter {
    static let mock: MyProgressDetailRouter = .init(rootCoordinator: AppRouter(), data: [ShotData.init(speed: 50.0, timestamp: Date(), sessionID: "1", selectedHand: SharedSettingsManager.shared.throwingHand == .left ? "L" : "R")], date: "")
}
