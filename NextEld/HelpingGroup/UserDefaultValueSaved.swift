//
//  UserDefaultValueSaved.swift
//  NextEld
//
//  Created by priyanshi  on 14/08/25.
//

import Foundation
struct AppStorageKeys {
    
    static let driverId  = "driverId"
    static let authToken = "authToken"
    static let UserName  = "driverName"
    static let vehicleid = "vehicleId"
    static let origin =   "origin"
    static let loginDateTime = "loginDateTime"
    static let TimeZoneOffset = "timezoneOffSet"
    static let coDriverId = "coDriverId"
    static let CurrentDay = "days"
    static let shift = "shift"
    static let clientId = "clientId"
    static let cycleTime = "cycleTime"
    static let cycleDays = "cycleDays"
    static let cycleRestartTime = "cycleRestartTime"
    static let onDutyTime = "onDutyTime"
    static let onDriveTime = "onDriveTime"
    static let onSleepTime = "onSleepTime"
    static let continueDriveTime = "continueDriveTime"
    
    //MARK: -  warning timer

    static let breakTime = "breakTime"
    static let warningOnDutyTime2 = "warningOnDutyTime2"   // 13:50
    static let warningOnDutyTime1 =  "warningOnDutyTime1"
    static let warningOnDriveTime1 = "warningOnDriveTime1"
    static let warningOnDriveTime2 = "warningOnDriveTime2"
    static let warningBreakTime1 = "warningBreakTime1"
    static let warningBreakTime2 = "warningBreakTime2"
    
    //MARK: -  Current Day's
    
   
    

}

struct DriverInfo {
    
    static var driverId: Int? {
        let id = UserDefaults.standard.object(forKey: AppStorageKeys.driverId) as? Int
        return id
    }
    
    static func setDriverId(_ id: Int) {
        UserDefaults.standard.set(id, forKey: AppStorageKeys.driverId)
    }
    static var authToken: String {
          UserDefaults.standard.string(forKey: AppStorageKeys.authToken) ?? ""
      }
      static func setAuthToken(_ token: String) {
          UserDefaults.standard.set(token, forKey: AppStorageKeys.authToken)
      }
    static var UserName: String {
          UserDefaults.standard.string(forKey: AppStorageKeys.UserName) ?? ""
      }
      static func setUserName(_ name: String) {
          UserDefaults.standard.set(name, forKey: AppStorageKeys.UserName)
      }
    static var vehicleId: Int? {
        let id = UserDefaults.standard.object(forKey: AppStorageKeys.vehicleid) as? Int
        return id
    }
    static func setvehicleId(_ id: Int) {
        UserDefaults.standard.set(id, forKey: AppStorageKeys.vehicleid)
    }
     
    static var origins: String {
          UserDefaults.standard.string(forKey: AppStorageKeys.origin) ?? "Driver"
      }
      static func setOrigins(_ org: String) {
          UserDefaults.standard.set(org, forKey: AppStorageKeys.origin)
      }
    static var loginDateTime: Int64? {
            UserDefaults.standard.object(forKey: AppStorageKeys.loginDateTime) as? Int64
        }
        static func setLoginDateTime(_ value: Int64) {
            UserDefaults.standard.set(value, forKey: AppStorageKeys.loginDateTime)
        }
    // MARK: - Time Zone Offset
    static var timeZoneOffset: String {
        UserDefaults.standard.string(forKey: AppStorageKeys.TimeZoneOffset) ?? "+00:00"
    }
    static func setTimeZoneOffset(_ offset: String) {
        UserDefaults.standard.set(offset, forKey: AppStorageKeys.TimeZoneOffset)
    }
    // MARK: -  Co-Driver
    static var coDriverId: Int? {
        UserDefaults.standard.object(forKey: AppStorageKeys.coDriverId) as? Int
    }
    static func setCoDriverId(_ id: Int) {
        UserDefaults.standard.set(id, forKey: AppStorageKeys.coDriverId)
    }

    static var shift: Int? {
        UserDefaults.standard.object(forKey: AppStorageKeys.shift) as? Int
    }
    static func setShift(_ id: Int) {
        UserDefaults.standard.set(id, forKey: AppStorageKeys.shift)
    }
    
    static var CurrentDay: Int? {
        UserDefaults.standard.object(forKey: AppStorageKeys.CurrentDay) as? Int
    }
    
    static func CurrentDay(_ id: Int) {
        UserDefaults.standard.set(id, forKey: AppStorageKeys.CurrentDay)
    }
    
    // MARK: - ClientId
        static var clientId: Int? {
            UserDefaults.standard.object(forKey: AppStorageKeys.clientId) as? Int
        }
        static func setClientId(_ id: Int) {
            UserDefaults.standard.set(id, forKey: AppStorageKeys.clientId)
        }
    //MARK: -  Save All Timer in UD
    static var cycleTime: Int? {
        UserDefaults.standard.object(forKey: AppStorageKeys.cycleTime) as? Int
    }
    static func setcycleTime(_ id: Int) {
        UserDefaults.standard.set(id, forKey: AppStorageKeys.cycleTime)
    }
    static var cycleDays: Int? {
        UserDefaults.standard.object(forKey: AppStorageKeys.cycleDays) as? Int
    }
    static func setcycleDays(_ id: Int) {
        UserDefaults.standard.set(id, forKey: AppStorageKeys.cycleDays)
    }
    static var cycleRestartTime: Int? {
        UserDefaults.standard.object(forKey: AppStorageKeys.cycleRestartTime) as? Int
    }
    static func setcycleRestartTime(_ id: Int) {
        UserDefaults.standard.set(id, forKey: AppStorageKeys.cycleRestartTime)
    }

    static var onDriveTime: Double? {
        UserDefaults.standard.object(forKey: AppStorageKeys.onDriveTime) as? Double
    }
    static func setonDriveTime(_ id: Double) {
        UserDefaults.standard.set(id, forKey: AppStorageKeys.onDriveTime)
    }
    
    static var onDutyTime: Double? {
        UserDefaults.standard.object(forKey: AppStorageKeys.onDutyTime) as? Double
    }
    static func setonDutyTime(_ id: Double) {
        UserDefaults.standard.set(id, forKey: AppStorageKeys.onDutyTime)
    }
    
    static var onSleepTime: Double? {
        UserDefaults.standard.object(forKey: AppStorageKeys.onSleepTime) as? Double
    }
    static func setonSleepTime(_ id: Double) {
        UserDefaults.standard.set(id, forKey: AppStorageKeys.onSleepTime)
    }
    static var continueDriveTime: Double? {
        UserDefaults.standard.object(forKey: AppStorageKeys.continueDriveTime) as? Double
    }
    static func setcontinueDriveTime(_ id: Double) {
        UserDefaults.standard.set(id, forKey: AppStorageKeys.continueDriveTime)
    }
    
    //MARK: -  Warning Time Saved From API
    
    static func breakTime(_ id: Int) {
        UserDefaults.standard.set(id, forKey: AppStorageKeys.breakTime)
    }
    
    static var setbreakTime: Int? {
        UserDefaults.standard.object(forKey: AppStorageKeys.breakTime) as? Int
    }
    static func warningOnDutyTime1(_ id: Int) {
        UserDefaults.standard.set(id, forKey: AppStorageKeys.warningOnDutyTime1)
    }
    
    static var setWarningOnDutyTime1: Double? {
        UserDefaults.standard.object(forKey: AppStorageKeys.warningOnDutyTime1) as? Double
    }
    static func warningOnDutyTime2(_ id: Double) {
        UserDefaults.standard.set(id, forKey: AppStorageKeys.warningOnDutyTime2)
    }
    static var setWarningOnDutyTime2: Double? {
        UserDefaults.standard.object(forKey: AppStorageKeys.warningOnDutyTime2) as? Double
    }
    static func warningOnDriveTime1(_ id: Double) {
        UserDefaults.standard.set(id, forKey: AppStorageKeys.warningOnDriveTime1)
    }
    static var setWarningOnDriveTime1 : Double? {
        UserDefaults.standard.object(forKey: AppStorageKeys.warningOnDriveTime1) as? Double
    }
 
    static func warningOnDriveTime2 (_ id: Double) {
        UserDefaults.standard.set(id, forKey: AppStorageKeys.warningOnDriveTime2)
    }
    static var setWarningOnDriveTime2 : Double? {
        UserDefaults.standard.object(forKey: AppStorageKeys.warningOnDriveTime2) as? Double
    }
    static var warningBreakTime1: Int? {
        UserDefaults.standard.object(forKey: AppStorageKeys.warningBreakTime1) as? Int
    }
    static func setWarningBreakTime1(_ id: Int) {
        UserDefaults.standard.set(id, forKey: AppStorageKeys.warningBreakTime1)
    }
    static var warningBreakTime2: Int? {
        UserDefaults.standard.object(forKey: AppStorageKeys.warningBreakTime2) as? Int
    }
    static func setWarningBreakTime2(_ id: Int) {
        UserDefaults.standard.set(id, forKey: AppStorageKeys.warningBreakTime2)
    }
    
    
}

