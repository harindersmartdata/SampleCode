//
//  MyProgressRouter.swift
//  LacrosseApp
//
//  Created by Harinder Rana on 20/03/25.
//

import SwiftUI


class MyProgressRouter {
    
    private let rootCoordinator: NavigationCoordinator

    init(rootCoordinator: NavigationCoordinator){
        self.rootCoordinator = rootCoordinator
    }
 
    func routeToSession(data : [String: [ShotData]], date: String) {
        let router = MyProgressSessionRouter(rootCoordinator: self.rootCoordinator, data: data, date: date)
        rootCoordinator.push(router)
    }
}

// MARK: - ViewFactory implementation

extension MyProgressRouter: Routable {
    
    func makeView() -> AnyView {
        let viewModel = MyProgressViewModel(router: self)/
        let view = MyProgressView(viewModel: viewModel)
        return AnyView(view)
    }
}

// MARK: - Hashable implementation

extension MyProgressRouter {
    static func == (lhs: MyProgressRouter, rhs: MyProgressRouter) -> Bool {
        //lhs.user.uid == rhs.user.uid
        true
    }
    
    func hash(into hasher: inout Hasher) {
      //  hasher.combine(self.user.uid)
    }
}

// MARK: - Router mock for preview
//
extension MyProgressRouter {
    static let mock: MyProgressRouter = .init(rootCoordinator: AppRouter())
}
