//  BluetoothViewModel.swift
//  NextEld
//  Created by priyanshi on 04/06/25.

import Foundation
import CoreBluetooth

class BluetoothViewModel: NSObject, ObservableObject {
    private var centralManager: CBCentralManager!
    @Published var discoveredDevices: [CBPeripheral] = []
    var isShubhamActive : Bool = false
    @Published var connectedDevice: CBPeripheral?
    @Published var receivedText: [String] = []
    @Published var parsedData = ParsedVehicleData()
    
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
    private func parseReceivedLine(_ line: String) {
        let components = line.split(separator: ":", maxSplits: 1).map { String($0) }
        guard components.count == 2 else { return }

        let key = components[0]
        let value = components[1]

        switch key {
        case "Ct": parsedData.coolantTemp = value
        case "Ft": parsedData.fuelTemp = value
        case "Ot": parsedData.oilTemp = value
        case "RPM": parsedData.rpm = value
        case "Vs": parsedData.vehicleSpeed = value
        case "ODM": parsedData.odometer = value
        case "MLG": parsedData.mileage = value
        case "Ma": parsedData.macAddress = value
        case "FWv": parsedData.firmwareVersion = value
        case "HWv": parsedData.hardwareVersion = value
        case "T": parsedData.time = value
        case "D": parsedData.date = value
        case "La": parsedData.latitude = value
        case "Lo": parsedData.longitude = value
        case "Sp": parsedData.speed = value
        case "Mod": parsedData.model = value
        case "Sno": parsedData.serialNo = value
        case "VIN": parsedData.vin = value
        case "EngHr": parsedData.engineHours = value
        default: break
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
        guard let value = characteristic.value else { return }
        let stringData = String(decoding: value, as: UTF8.self)
        print("Received Data: \(stringData)")
        parseReceivedLine(stringData)
    }

    private func parseDataLine(_ stringData: String) {
        DispatchQueue.main.async {
            if stringData == "--Kamlesh--" {
                self.isShubhamActive = false
            } else if stringData == "-Shubham-" {
                self.isShubhamActive = true
                self.receivedText.removeAll() // Optional: clear old data when Shubham starts
            } else if self.isShubhamActive {
                self.receivedText.append(stringData)
            }
            print("Shubham Mode: \(self.isShubhamActive)")
            print("Received Raw String: \(stringData)")
        }
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
