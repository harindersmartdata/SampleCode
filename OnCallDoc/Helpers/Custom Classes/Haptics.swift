//
//  Haptics.swift
//  OnCallDoc
//
//  Created by Harinder Rana on 16/02/22.
//

import UIKit

enum HapticType{
    case error,success,warning,light,medium,heavy
}

class Haptics{
    
    static let manager = Haptics()
    
    private init(){ }
    
    func trigger(type: HapticType){
        switch type{
        case .error:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            
        case .success:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
        case .warning:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
            
        case .light:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            
        case .medium:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
        case .heavy:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            
        }
    }
    
}
