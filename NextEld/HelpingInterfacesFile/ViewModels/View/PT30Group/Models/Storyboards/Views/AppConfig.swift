//
//  AppConfig.swift
//  DeviceManager
//
//  Created by Pacific Track, LLC on 2/18/20.
//  Copyright © 2020 Pacific Track, LLC. All rights reserved.
//

import Foundation

struct AppConfig {
    // auto reconnect for unexpected disconnects
    static var autoReconnect = true
    
    // time in which the app tries to reconnect to device (in seconds, 0 means infinite)
    static var autoReconnectInterval: TimeInterval = 60
    
    // scan interval (in seconds, 0 means infinite)
    static var scanInterval: TimeInterval = 10
}
