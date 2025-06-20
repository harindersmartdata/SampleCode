//
//  MyProgressViewModel.swift
//  LacrosseApp
//
//  Created by Harinder Rana on 20/03/25.
//

import Foundation


class MyProgressViewModel: ObservableObject {
    
    private let router: MyProgressRouter
    
    @Published var historyData: [ShotData] = []
    @Published var groupedHistoryData: [String: [String: [ShotData]]] = [:]
    
    
    init(router: MyProgressRouter){
        self.router = router
    }
    
    func navigateToSessionPage(data : [String: [ShotData]], date: String) {
        self.router.routeToSession(data: data, date: date)
    }
    func fetchHistoryData() {
        FirebaseManager.shared.fetchShotData { shotHistory, error in
            if let error = error {
                print("Error fetching shot data: \(error)")
                return
            }
            self.historyData = shotHistory ?? []
            self.groupedHistoryData = self.groupHistoryData()
        }
    }
    
    func groupHistoryData() -> [String: [String: [ShotData]]] {
        var groupedData: [String: [String: [ShotData]]] = [:]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        for shot in historyData {
            let dateString = dateFormatter.string(from: shot.timestamp)
            
            if groupedData[dateString] == nil {
                groupedData[dateString] = [:]
            }
            
            if groupedData[dateString]?[shot.sessionID] == nil {
                groupedData[dateString]?[shot.sessionID] = []
            }
            
            groupedData[dateString]?[shot.sessionID]?.append(shot)
        }
        
        return groupedData
    }
    
}

// MARK: - HomePageViewModel mock for preview

extension MyProgressViewModel {
    static let mock: MyProgressViewModel = .init(router: MyProgressRouter.mock)
}


