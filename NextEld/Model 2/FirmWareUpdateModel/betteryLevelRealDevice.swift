//
//  betteryLevelRealDevice.swift
//  NextEld
//
//  Created by priyanshi  on 30/08/25.
//

import Foundation
import CoreBluetooth
import SwiftUI


class PhoneBatteryViewModel: ObservableObject {
    
    @Published var batteryLevel: Int = 0
    init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        batteryLevel = Int(UIDevice.current.batteryLevel * 100)
        
        // Observe changes
        NotificationCenter.default.addObserver(
            forName: UIDevice.batteryLevelDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.batteryLevel = Int(UIDevice.current.batteryLevel * 100)
        }
    }
}

















/*class BetteryViewModel: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    @Published var batteryLevel: Int? = nil
    
    private var centralManager: CBCentralManager!
    private var connectedPeripheral: CBPeripheral?
    
    // UUIDs
    private let batteryServiceUUID = CBUUID(string: "180F")
    private let batteryLevelCharacteristicUUID = CBUUID(string: "2A19")
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            // Instead of filtering, scan for all and later discover services
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        
        // Filter by device name if you only want PT30
        if let name = peripheral.name, name.contains("PT30") {
            connectedPeripheral = peripheral
            centralManager.stopScan()
            centralManager.connect(peripheral, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices([batteryServiceUUID])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services where service.uuid == batteryServiceUUID {
            peripheral.discoverCharacteristics([batteryLevelCharacteristicUUID], for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics where characteristic.uuid == batteryLevelCharacteristicUUID {
            // Read and also subscribe for updates
            peripheral.readValue(for: characteristic)
            peripheral.setNotifyValue(true, for: characteristic)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                    didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        if characteristic.uuid == batteryLevelCharacteristicUUID,
           let value = characteristic.value {
            let batteryPercent = value.first ?? 0
            DispatchQueue.main.async {
                self.batteryLevel = Int(batteryPercent)
                print("Battery Level: \(batteryPercent)%")
            }
        }
    }
}*/
