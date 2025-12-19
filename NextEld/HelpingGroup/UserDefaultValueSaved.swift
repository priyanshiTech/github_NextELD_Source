//
//  UserDefaultValueSaved.swift
//  NextEld
//
//  Created by priyanshi  on 14/08/25.
//

import Foundation
import SwiftUI
import CoreMedia

struct AppStorageHandler {
    
    static let shared = AppStorageHandler()
    @AppStorage("driverName") var driverName: String?
    @AppStorage("username") var UserName: String?
    @AppStorage("driverId") var driverId: Int?
    @AppStorage("authToken") var authToken: String?
    @AppStorage("vehicleId") var vehicleId: Int?
    @AppStorage("vehicleNo") var vehicleNo: String?
    @AppStorage("origin") var origin: String?
    @AppStorage("loginDateTime") var loginDateTime: Int?
    @AppStorage("timezoneOffSet") var timeZoneOffset: String?
    @AppStorage("timezone") var timeZone: String?
    @AppStorage("timestamp") var timeStamp: String?
    @AppStorage("coDriverId") var coDriverId: Int?
    @AppStorage("days") var days: Int = 1
    @AppStorage("shift") var shift: Int = 1
    @AppStorage("clientId") var clientId: Int?
    @AppStorage("cycleTime") var cycleTime: Int?
    @AppStorage("cycleDays") var cycleDays: Int?
    @AppStorage("cycleRestartTime") var cycleRestartTime: Int?
    @AppStorage("onDutyTime") var onDutyTime: Double?
    @AppStorage("onDriveTime") var onDriveTime: Double?
    @AppStorage("onSleepTime") var onSleepTime: Double?
    @AppStorage("continueDriveTime") var continueDriveTime: Double?
    @AppStorage("logType") var logType: String?
    @AppStorage("employeeId") var employeeId: Int?
    @AppStorage("clientName")var company: String?
    @AppStorage("splitShiftIdentifier") var splitShiftIdentifier: Int = 0
    //MARK: - for rule/personal use API Code
    @AppStorage("personalUse") var personalUseActive: String?
    @AppStorage("yardMoves") var yardMovesActive: String?
    @AppStorage("exempt") var exempt: String?
    @AppStorage("disclaimerRead") var disclaimerRead:Int?
    @AppStorage("isDeviceConnected") var isDeviceConnected: Bool = false
    @AppStorage("trailer") var TrailerInput:String?
    
    
    // MARK: - Warning Timer
    @AppStorage("breakTime") var breakTime: Int?
    @AppStorage("warningOnDutyTime2") var warningOnDutyTime2: Int?
    @AppStorage("warningOnDutyTime1") var warningOnDutyTime1: Int?
    @AppStorage("warningOnDriveTime1") var warningOnDriveTime1: Int?
    @AppStorage("warningOnDriveTime2") var warningOnDriveTime2: Int?
    @AppStorage("warningBreakTime1") var warningBreakTime1: Int?
    @AppStorage("warningBreakTime2") var warningBreakTime2: Int?
    //MARK: -  for saving a data to Add dvir
    @AppStorage("_id") var IdShowing : Int?
    @AppStorage("dvirLogId") var dvirLogId: String?

    func deleteAll() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
            UserDefaults.standard.synchronize()
            // print("All @AppStorage values for bundle ID '\(bundleID)' have been reset.")
        }
        
    }
}

extension Notification.Name {
    static let deviceConnectionChanged = Notification.Name("deviceConnectionChanged")
}

enum DeviceConnectionNotifier {
    static func updateConnectionState(isConnected: Bool) {
        AppStorageHandler.shared.isDeviceConnected = isConnected
        NotificationCenter.default.post(name: .deviceConnectionChanged, object: nil)
    }
}


























