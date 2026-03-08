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
    //MARK: - for rule/personal use API Code
    @AppStorage("personalUse") var personalUseActive: String?
    @AppStorage("yardMoves") var yardMovesActive: String?
    @AppStorage("exempt") var exempt: String?
    @AppStorage("disclaimerRead") var disclaimerRead:Int?
    @AppStorage("isDeviceConnected") var isDeviceConnected: Bool = false
    @AppStorage("odometer") var odometerValue: Double?
    @AppStorage("engineHour") var engineHours: Double?
    
    // MARK: - Warning Timer
    @AppStorage("breakTime") var breakTime: Int?
    @AppStorage("warningOnDutyTime2") var warningOnDutyTime2: Int?
    @AppStorage("warningOnDutyTime1") var warningOnDutyTime1: Int?
    @AppStorage("warningOnDriveTime1") var warningOnDriveTime1: Int?
    @AppStorage("warningOnDriveTime2") var warningOnDriveTime2: Int?
    @AppStorage("warningBreakTime1") var warningBreakTime1: Int?
    @AppStorage("warningBreakTime2") var warningBreakTime2: Int?
    
    @AppStorage("is34HourStarted") var is34HourStarted: String?
    @AppStorage("remainingBreakTime") var remainingBreakTime: Int = 0
    @AppStorage("remainingContinueDriveTime") var remainingContinueDriveTime: Int = 0
    //MARK: -  for saving a data to Add dvir
    @AppStorage("dvirLogId") var dvirLogId: String?

    func deleteAll() {
        cleanAPPStorage()
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
            UserDefaults.standard.synchronize()
            // print("All @AppStorage values for bundle ID '\(bundleID)' have been reset.")
        }
        
    }
    
    private func cleanAPPStorage() {
        driverName = nil
        driverName = nil
        UserName = nil
        driverId = nil
        authToken = nil
        vehicleId = nil
        vehicleNo = nil
        origin = nil
        loginDateTime = nil
        timeZoneOffset = nil
        timeZone = nil
        coDriverId = nil
        days = 1
        shift = 1
        clientId = nil
        cycleTime = nil
        cycleDays = nil
        cycleRestartTime = nil
        onDutyTime = nil
        onDriveTime = nil
        onSleepTime = nil
        continueDriveTime = nil
        logType = nil
        employeeId = nil
        company = nil
        personalUseActive = nil
        yardMovesActive = nil
        exempt = nil
        disclaimerRead = nil
        isDeviceConnected = false
        breakTime = nil
        warningOnDutyTime2 = nil
        warningOnDutyTime1 = nil
        warningOnDriveTime1 = nil
        warningOnDriveTime2 = nil
        warningBreakTime1 = nil
        warningBreakTime2 = nil
        dvirLogId = nil
        remainingBreakTime = 0
        remainingContinueDriveTime = 0
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


























