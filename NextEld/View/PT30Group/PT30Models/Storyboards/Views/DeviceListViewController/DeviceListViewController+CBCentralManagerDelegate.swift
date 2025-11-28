//
//  DeviceListViewController+CBCentralManagerDelegate.swift
//  DeviceManager
//
//  Created by Pacific Track, LLC on 2/13/20.
//  Copyright © 2020 Pacific Track, LLC. All rights reserved.
//

import CoreBluetooth
import SwiftUI

extension DeviceListViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state != .poweredOn {
            if state == .connected { state = .idle }
            resetVCs {
                self.performSegue(withIdentifier: "showBluetoothStatus", sender: self)
            }
        } else {
            getConnectedDevice(centralManager: central)
            actionButtonTapped()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        handleDiscovered(peripheral: peripheral, rssi: RSSI)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        targetPeripheral = nil
        discoveredPeripherals.removeAll()
        state = .idle
        DeviceConnectionNotifier.updateConnectionState(isConnected: false)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        state = .connected
        targetPeripheral = peripheral
        discoveredPeripherals.removeAll()
        DeviceConnectionNotifier.updateConnectionState(isConnected: true)
        
        performSegue(withIdentifier: "deviceDetails", sender: self)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        resetVCs()
        state = .idle
        DeviceConnectionNotifier.updateConnectionState(isConnected: false)
        if error != nil {
            if AppConfig.autoReconnect {
                reconnectTimeoutTimer?.invalidate()
                
                if centralManager?.state == .poweredOn {
                    targetPeripheral = peripheral
                    state = .reconnecting
                    centralManager?.connect(peripheral, options: nil)
                    
                    if AppConfig.autoReconnectInterval > 0 {
                        reconnectTimeoutTimer = Timer.scheduledTimer(timeInterval: AppConfig.autoReconnectInterval, target: self, selector: #selector(reconnectTimedOut), userInfo: nil, repeats: false)
                    }
                }
            }
        }
    }
    
    func getConnectedDevice(centralManager: CBCentralManager) {
        let serviceUUID = CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
            let connectedPeripherals = centralManager.retrieveConnectedPeripherals(withServices: [serviceUUID])
            for peripheral in connectedPeripherals {
                self.targetPeripheral = peripheral
                // Now you have a CBPeripheral object for the connected device
                // You can access its name, identifier, etc.
                print("Connected Peripheral Name: \(peripheral.name ?? "Unnamed")")
                print("Connected Peripheral Identifier: \(peripheral.identifier.uuidString)")

                // To get more detailed information (services, characteristics),
                // you need to set the peripheral's delegate and discover its services.
                    // Discover all services
            }
        if let targetPeripheral {
            centralManager.stopScan()
            centralManager.connect(targetPeripheral)
        }
        
    }
}
