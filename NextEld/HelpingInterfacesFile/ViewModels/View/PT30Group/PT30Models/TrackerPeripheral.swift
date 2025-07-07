//
//  TrackerPeripheral.swift
//  DeviceManager
//
//  Created by Pacific Track, LLC on 12/30/19.
//  Copyright © 2020 Pacific Track, LLC. All rights reserved.
//

import Foundation
import CoreBluetooth

struct TrackerPeripheral {
    let peripheral: CBPeripheral
    let rssi: NSNumber
}
