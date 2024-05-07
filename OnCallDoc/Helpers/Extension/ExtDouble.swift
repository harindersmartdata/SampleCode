//
//  ExtDouble.swift
//  TNC360
//
//  Created by Shiwani Thakur on 19/04/21.
//

import Foundation


extension Double {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
    
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func finalCalculatedBMIValue(_ weightInLbs: Double?, _ heightInInches : Double?)-> Double{
        
        let heightInSquare = Float(heightInInches!) * Float(heightInInches!)
        let bmivalue = (703 * Float(weightInLbs!)) / heightInSquare
        return Double(bmivalue)
    }
}
