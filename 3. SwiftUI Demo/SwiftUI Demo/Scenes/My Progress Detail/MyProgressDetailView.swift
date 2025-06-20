//
//  MyProgressViewDetail.swift
//  LacrosseApp
//
//  Created by Harinder Rana on 21/03/25.
//

import SwiftUI

struct MyProgressDetailView: View {
    @StateObject var viewModel: MyProgressDetailViewModel
    
    var body: some View {
        ZStack {
            CustomBackgroundView(imageName: "bgImage1")
            
            VStack(spacing: 20) {
                // Header
                HStack {
                    Button(action: {
                        viewModel.popBack()
                    }) {
                        Image("leftArrow") // Replace with your actual image name
                            .resizable()
                            .frame(width: 24, height: 24) // Adjust size as needed
                            .padding(.trailing, 10) // Space between button and title
                    }
                    
                    Text("Details")
                        .font(.custom(FontFamily.jostMedium, size: 20))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding()
                .background(.appHeader)
                
                
                HStack {
                    Image(systemName: "calendar")
                    Text(viewModel.date)
                        .font(.custom(FontFamily.jostMedium, size: 16))
                    Spacer()
                    if SharedSettingsManager.shared.isBetaModeOn{
                        HStack(spacing: 5){
                            Text("Avg. Speed :")
                                .font(.custom(FontFamily.jostMedium, size: 16))
                            Text(calculateAverageSpeed())
                                .font(.custom(FontFamily.jostSemiBold, size: 16))
                                .foregroundColor(.appGreen)
                            
                            if SharedSettingsManager.shared.speedUnit == .km{
                                Text("km/h")
                                    .font(.custom(FontFamily.jostMedium, size: 16))
                            }else {
                                Text("mph")
                                    .font(.custom(FontFamily.jostMedium, size: 16))
                            }
                            
                        }
                    }
                    
                }
                .padding(10)
                .foregroundColor(.white)
                
                
                // Scrollable Progress Cards
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(Array(viewModel.historyData.enumerated()), id: \.element.id) { index, shot in
                            let formattedTime = formatTime(from: shot.timestamp)
                            let speed = convertSpeed(shot.speed)
                            
                            ProgressDetailCardView(
                                index: index,
                                time: formattedTime,
                                speed:  String(format: "%.2f", speed),
                                selectedHand: shot.selectedHand,
                                isBetaModeOn: SharedSettingsManager.shared.isBetaModeOn,
                                speedUnit: SharedSettingsManager.shared.speedUnit
                            )
                        }
                        
                    }
                    .padding()
                }
            }
        }
        .background(Color.black.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .onAppear(){
            NotificationCenter.default.addObserver(forName: NSNotification.Name("isBetaModeToggle"), object: nil, queue: .main) { _ in
                viewModel.objectWillChange.send()
            }
        }
    }
    
    func formatTime(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss a" // lowercase hh for 12-hour format
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter.string(from: date)
    }
    
    private func convertSpeed(_ speed: Double) -> Double {
        if SharedSettingsManager.shared.speedUnit == .mph {
            return speed * 2.23694
        } else {
            return speed * 3.6
        }
    }
    
    private func calculateAverageSpeed() -> String {
        let speeds = viewModel.historyData.map { $0.speed }
        guard !speeds.isEmpty else { return "0.0" }
        
        let rawAverage = speeds.reduce(0, +) / Double(speeds.count)
        let convertedAverage = convertSpeed(rawAverage)
        
        return String(format: "%.2f", convertedAverage)
    }
}

// MARK: - Progress Card View
struct ProgressDetailCardView: View {
    let index: Int
    let time: String
    let speed: String
    let selectedHand: String
    let isBetaModeOn: Bool
    let speedUnit: SpeedUnit
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                HStack(spacing: 5){
                    Image("stick")
                    Text("\(index + 1)")
                        .font(.custom(FontFamily.jostMedium, size: 16))
                }
                
                Spacer()
                
                HStack(spacing: 5){
                    Image(systemName: "clock")
                    Text(time)
                        .font(.custom(FontFamily.jostMedium, size: 16))
                }
                
                
                Spacer()
                
                HStack(spacing: 5){
                    if isBetaModeOn{
                    Text(speed)
                        .foregroundColor(.appGreen)
                        .font(.custom(FontFamily.jostBold, size: 18))
                    
                   
                        if speedUnit == .km{
                            Text("km/h")
                                .font(.custom(FontFamily.jostMedium, size: 12))
                        }else {
                            Text("mph")
                                .font(.custom(FontFamily.jostMedium, size: 12))
                        }
                    }
                    
                 
                    Text("(\(selectedHand))")
                        .foregroundColor(.appRed)
                        .font(.custom(FontFamily.jostBold, size: 12))
                }
                
            }
            .foregroundColor(.white)
            
        }
        .padding()
        .background(.appCell)
        .cornerRadius(10)
    }
}
