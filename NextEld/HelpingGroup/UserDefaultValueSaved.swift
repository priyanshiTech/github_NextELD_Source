//
//  UserDefaultValueSaved.swift
//  NextEld
//
//  Created by priyanshi   on 14/08/25.
//

import Foundation
struct AppStorageKeys {
    static let driverId  = "driverId"
    static let authToken = "authToken"
    static let UserName  = "driverName"
    static let vehicleid = "vehicleId"
    static let origin =   "origin"
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
}

