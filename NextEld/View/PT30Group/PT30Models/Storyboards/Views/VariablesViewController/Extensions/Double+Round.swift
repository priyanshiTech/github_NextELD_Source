//
//  Double+Round.swift
//  DeviceManager
//
//  Created by Pacific Track, LLC on 8/16/22.
//  Copyright © 2022 Pacific Track, LLC. All rights reserved.
//

import Foundation

extension Float {
    /// Round to specified decimal places
    func roundTo(numberOfDecimals decimals:Int) -> Double {
        let divisor = pow(10, Double(decimals))
        return (Double(self) * divisor).rounded() / divisor
    }
}

extension Double {
    /// Round to specified decimal places
    func roundTo(numberOfDecimals decimals:Int) -> Double {
        let divisor = pow(10, Double(decimals))
        return (self * divisor).rounded() / divisor
    }
    
    var timeString: String {
        // Always show 00:00:00 in UI when time is up
        if self <= 0 {
            return "00:00:00"
        }
        
        let hours = Int(self) / 3600
        let minutes = (Int(self) % 3600) / 60
        let seconds = Int(self) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
