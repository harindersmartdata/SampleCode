//
//  SplashScreenView.swift
//  LacrosseApp
//
//  Created by Harinder Rana on 20/03/25.
//

import SwiftUI
import Firebase
import HealthKit

struct SplashScreenView: View {
    @State private var isActive = false
    let healthStore = HKHealthStore()

    let typesToShare: Set = [HKObjectType.workoutType()] // if you're not writing any data
    let typesToRead: Set = [HKObjectType.workoutType()]
    
    var body: some View {
        if isActive {
            //CustomNavigationView(appRouter: .init())
            RootView()
        } else {
            ZStack {
                Image("splash")
                    .resizable()
                    .ignoresSafeArea()
                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: .infinity, height: 200)
                    .foregroundColor(.white)
                    .padding([.leading, .trailing], 50)
            }
            .onAppear {
                // Delay for 2 seconds before switching to main screen
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        isActive = true
                    }
                }
                FirebaseApp.configure()
                
                FirebaseManager.shared.ensureUserExists { error in
                    print(error?.localizedDescription as Any)
                }
                
                FirebaseManager.shared.uploadHistoryData()
                
                
                healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
                    if success {
                        print("✅ HealthKit authorized")
                    } else if let error = error {
                        print("❌ HealthKit auth error: \(error.localizedDescription)")
                    } else {
                        print("❌ HealthKit auth failed for unknown reason")
                    }
                }
            
            }
        }
    }
}

#Preview {
    SplashScreenView()
}

