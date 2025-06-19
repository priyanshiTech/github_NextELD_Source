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
}
