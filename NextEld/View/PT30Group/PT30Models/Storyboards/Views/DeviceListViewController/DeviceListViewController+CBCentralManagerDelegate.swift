//
//  DeviceListViewController+CBCentralManagerDelegate.swift
//  DeviceManager
//
//  Created by Pacific Track, LLC on 2/13/20.
//  Copyright © 2020 Pacific Track, LLC. All rights reserved.
//

import CoreBluetooth

extension DeviceListViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state != .poweredOn {
            if state == .connected { state = .idle }
            resetVCs {
                self.performSegue(withIdentifier: "showBluetoothStatus", sender: self)
            }
        } else {
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
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        state = .connected
        targetPeripheral = peripheral
        discoveredPeripherals.removeAll()
        
        performSegue(withIdentifier: "deviceDetails", sender: self)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        resetVCs()
        state = .idle
        
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
}
