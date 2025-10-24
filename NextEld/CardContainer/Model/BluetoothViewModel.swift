//  BluetoothViewModel.swift
//  NextEld
//  Created by priyanshi on 04/06/25.

import Foundation
import CoreBluetooth

class BluetoothViewModel: NSObject, ObservableObject {
    private var centralManager: CBCentralManager!
    @Published var discoveredDevices: [CBPeripheral] = []
    @Published var connectedDevice: CBPeripheral?
    @Published var receivedText: [String] = []
    @Published var parsedData = PT30Data()
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func startScanning() {
        guard centralManager.state == .poweredOn else { return }
        discoveredDevices.removeAll()
        centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
    }
    
    func stopScanning() {
        centralManager.stopScan()
    }
    
    func connect(to device: CBPeripheral) {
        centralManager.connect(device, options: nil)
    }
    
    func disconnect() {
        if let device = connectedDevice {
            centralManager.cancelPeripheralConnection(device)
        }
    }
}

extension BluetoothViewModel: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Bluetooth is powered on")
        case .poweredOff:
            print("Bluetooth is powered off")
        case .unauthorized:
            print("Bluetooth is unauthorized")
        case .unsupported:
            print("Bluetooth is unsupported")
        default:
            print("Unknown state")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !discoveredDevices.contains(where: { $0.identifier == peripheral.identifier }) {
            peripheral.rssi = RSSI
            discoveredDevices.append(peripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connectedDevice = peripheral
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        connectedDevice = nil
        receivedText.removeAll()
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect: \(error?.localizedDescription ?? "Unknown error")")
    }
}

extension BluetoothViewModel: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            if characteristic.properties.contains(.notify) {
                peripheral.setNotifyValue(true, for: characteristic)
            }
            if characteristic.properties.contains(.read) {
                peripheral.readValue(for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value else { return }
        
        if let string = String(data: data, encoding: .utf8) {
            receivedText.append(string)
            parseData(string)
        }
    }
    
    private func parseData(_ data: String) {
        // This is a placeholder implementation
        // You should implement proper parsing based on your device's data format
        parsedData.date = Date().formatted(date: .abbreviated, time: .shortened)
    }
}

extension CBPeripheral {
    private struct AssociatedKeys {
        static var rssi = "rssi"
    }
    
    var rssi: NSNumber? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.rssi) as? NSNumber
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.rssi, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
} 