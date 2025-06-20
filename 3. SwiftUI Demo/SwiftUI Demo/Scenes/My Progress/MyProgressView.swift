//
//  MyProgressView.swift
//  LacrosseApp
//
//  Created by Harinder Rana on 20/03/25.
//

import SwiftUI

struct MyProgressView: View {
    @StateObject var viewModel: MyProgressViewModel
    
    var body: some View {
        ZStack {
            CustomBackgroundView(imageName: "bgImage1")
            
            VStack(spacing: 20) {
                // Header
                HStack {
                    Text("My Progress")
                        .font(.custom(FontFamily.jostMedium, size: 20))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                .background(.appHeader)
                
                // Scrollable Progress Cards
                ScrollView {
                    if viewModel.groupedHistoryData.isEmpty {
                        Text("No history available")
                            .foregroundColor(.gray)
                            .font(.headline)
                            .padding()
                    } else {
                        VStack(spacing: 15) {
                            ForEach(Array(viewModel.groupedHistoryData.keys.sorted(by: >)), id: \.self) { date in
                                let totalThrows = viewModel.groupedHistoryData[date]?.values.flatMap { $0 }.count ?? 0
                                let allSpeeds = viewModel.groupedHistoryData[date]?.values.flatMap { $0 }.map { $0.speed } ?? []
                                let rawAverage = allSpeeds.isEmpty ? 0.0 : allSpeeds.reduce(0, +) / Double(allSpeeds.count)
                                let convertedAverage = convertSpeed(rawAverage)
                                let avgSpeed = String(format: "%.2f", convertedAverage)
                                
                                ProgressCardView(date: date, numberOfThrows: totalThrows, avgSpeed: avgSpeed)
                                    .onTapGesture {
                                        if let index = viewModel.groupedHistoryData.keys.sorted(by: >).firstIndex(of: date) {
                                            didTap(index: index)
                                        }
                                    }
                                
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .background(Color.black.ignoresSafeArea())
        .onAppear {
            viewModel.fetchHistoryData()
            NotificationCenter.default.addObserver(forName: NSNotification.Name("RefreshProgressData"), object: nil, queue: .main) { _ in
                viewModel.fetchHistoryData()
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name("RefreshProgressData"), object: nil)
        }
    }
    
    private func didTap(index: Int) {
        // Handle tap, use the index to get the data
        print("Tapped on item at index: \(index)")
        let selectedDate = viewModel.groupedHistoryData.keys.sorted(by: >)[index]
        let data = viewModel.groupedHistoryData[selectedDate]
        viewModel.navigateToSessionPage(data: data ?? [:], date: selectedDate)
    }
    
    private func convertSpeed(_ speed: Double) -> Double {
        if SharedSettingsManager.shared.speedUnit == .mph {
            return speed * 2.23694
        } else {
            return speed * 3.6
        }
    }
    
}

// MARK: - Progress Card View
struct ProgressCardView: View {
    var date: String
    var numberOfThrows: Int
    var avgSpeed: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image(systemName: "calendar")
                Text(date)
                    .font(.custom(FontFamily.jostMedium, size: 16))
                Spacer()
                Text("Number of Throws: \(numberOfThrows)")
                    .font(.custom(FontFamily.jostMedium, size: 16))
            }
            .foregroundColor(.white)
            
            HStack {
                Spacer()
                
                if SharedSettingsManager.shared.isBetaModeOn{
                    if SharedSettingsManager.shared.speedUnit == .km{
                        Text("Average Speed (km/h)")
                            .font(.custom(FontFamily.jostMedium, size: 16))
                    }else {
                        Text("Average Speed (mph)")
                            .font(.custom(FontFamily.jostMedium, size: 16))
                    }
                }
            }
            .foregroundColor(.white)
            if SharedSettingsManager.shared.isBetaModeOn{
            HStack {
                Spacer()
                Text(avgSpeed)
                    .foregroundColor(.appGreen)
                    .font(.custom(FontFamily.jostBold, size: 18))
            }
            .foregroundColor(.white)
        }
        }
        .padding()
        .background(.appCell)
        .cornerRadius(10)
    }
    
    // Helper function to format date
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, HH:mm"
        return formatter.string(from: date)
    }
}



#Preview {
    MyProgressView(viewModel: MyProgressViewModel(router: .mock))
}
