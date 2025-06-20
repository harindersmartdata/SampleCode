//
//  MyProgressDetailViewModel.swift
//  LacrosseApp
//
//  Created by Harinder Rana on 21/03/25.
//

import Foundation


class MyProgressDetailViewModel: ObservableObject {
    
    private let router: MyProgressDetailRouter
    @Published var historyData: [ShotData]
    @Published var date: String

    init(router: MyProgressDetailRouter, data: [ShotData], date: String){
        self.router = router
        self.historyData = data
        self.date = date
    }
    
    func popBack() {
        self.router.routeToPopBack()
    }
    
}

// MARK: - HomePageViewModel mock for preview

extension MyProgressDetailViewModel {
    static let mock: MyProgressDetailViewModel = .init(router: MyProgressDetailRouter.mock, data: [], date: "")
}


