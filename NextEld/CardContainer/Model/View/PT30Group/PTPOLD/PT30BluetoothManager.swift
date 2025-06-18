//
//  OnlyPT30ViewModel.swift
//  NextEld
//
//  Created by Priyanshi    on 17/06/25.
//
//import Foundation
//import CoreBluetooth
//import PacificTrack
//import Combine
//import CoreBluetooth

/*import SwiftUI
import CoreBluetooth
import PacificTrack


struct TrackerPeripheral: Identifiable, Equatable {
    let peripheral: CBPeripheral
    let rssi: NSNumber
    var id: UUID { peripheral.identifier }
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.peripheral.identifier == rhs.peripheral.identifier
    }
}

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, TrackerServiceDelegate {
    @Published var devices: [TrackerPeripheral] = []
    @Published var status: String = "Idle"
    @Published var connectedPeripheral: CBPeripheral?
    static let shared = BLEManager() // ← singleton instance
    // PT30 BLE Service UUID for PacificTrack
    let PT30_SERVICE_UUID = CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")

    private var central: CBCentralManager!
    private let tracker = TrackerService.sharedInstance

    override init() {
        super.init()
        central = CBCentralManager(delegate: self, queue: nil)
        tracker.delegate = self
    }

    func startScan(timeout: TimeInterval = 10) {
        devices.removeAll()
        status = "🔍 Scanning..."
        central.scanForPeripherals(withServices: [
            CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
        ], options: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + timeout) { self.stopScan() }
    }

    func stopScan() {
        central.stopScan()
        status = "Idle"
    }

    func connect(_ tp: TrackerPeripheral) {
        central.connect(tp.peripheral, options: nil)
        status = "🔗 Connecting..."
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            central.scanForPeripherals(
                withServices: [PT30_SERVICE_UUID],
                options: nil
            )
            status = "🔍 Scanning..."
        } else {
            status = "⚠️ Bluetooth unavailable"
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover p: CBPeripheral,
                        advertisementData: [String: Any], rssi: NSNumber) {
        let tp = TrackerPeripheral(peripheral: p, rssi: rssi)
        if !devices.contains(tp) {
            devices.append(tp)
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect p: CBPeripheral) {
        status = "✅ Connected to \(p.name ?? "device")"
        connectedPeripheral = p
        tracker.delegate = self
        // ✅ No explicit connect() call as TrackerService auto-detects connection
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect p: CBPeripheral, error: Error?) {
        status = "❌ Connection Failed"
    }

    // MARK: - TrackerServiceDelegate

    func trackerService(_ trackerService: PacificTrack.TrackerService, didSync trackerInfo: PacificTrack.TrackerInfo) {}
    func trackerService(_ trackerService: PacificTrack.TrackerService, didReceive event: PacificTrack.EventFrame, processed: (Bool) -> Void) {
        let type = event.eventType
        if type == .bluetoothConnected {
            status = "🎉 Tracker bluetoothConnected!"
        } else if type == .bluetoothDisconnected {
            status = "🔌 Tracker bluetoothDisconnected!"
        }
        processed(true)
    }
    func trackerService(_ trackerService: PacificTrack.TrackerService, didRetrieve event: PacificTrack.EventFrame, processed: (Bool) -> Void) { processed(true) }
    func trackerService(_ trackerService: PacificTrack.TrackerService, didReceiveSPN spnEvent: PacificTrack.SPNEventFrame, processed: (Bool) -> Void) { processed(true) }
    func trackerService(_ trackerService: PacificTrack.TrackerService, didReceieveVirtualDashboardReport virtualDashboardReport: PacificTrack.VirtualDashboardReport) {}
    func trackerService(_ trackerService: PacificTrack.TrackerService, onError error: PacificTrack.TrackerServiceError) {}
    func trackerService(_ trackerService: PacificTrack.TrackerService, onFirmwareUpgradeProgress progress: Float) {}
    func trackerService(_ trackerService: PacificTrack.TrackerService, onFirmwareUpgradeFailed error: PacificTrack.TrackerUpgradeError) {}
    func trackerService(_ trackerService: PacificTrack.TrackerService, onFirmwareUpgradeCompleted completed: Bool) {}
}*/
