//  PT30ModelView.swift
//  NextEld
//  Created by priyanshi on 04/06/25.

import Foundation

struct PT30Data {
    var date: String = ""
    var speed: String = "0"
    var vehicleSpeed: String = "0"
    var rpm: String = "0"
    var coolantTemp: String = "0"
    var fuelTemp: String = "0"
    var oilTemp: String = "0"
    var odometer: String = "0"
    var macAddress: String = ""
    var firmwareVersion: String = ""
    var hardwareVersion: String = ""
}

class PT30ViewModel: ObservableObject {
    @Published var parsedData = PT30Data()
    
    func parseData(_ data: String) {
        // Parse the incoming data and update parsedData
        // This is a placeholder implementation
        parsedData.date = Date().formatted(date: .abbreviated, time: .shortened)
    }
} 