//
//  ViewController.swift
//  DeviceManager
//
//  Created by Pacific Track, LLC on 12/30/19.
//  Copyright © 2020 Pacific Track, LLC. All rights reserved.
//

import UIKit
import CoreBluetooth
import PacificTrack

enum AppState {
    case idle
    case scanning
    case connected
    case reconnecting
}

class DeviceListViewController: UIViewController {
    var centralManager: CBCentralManager?
    var targetPeripheral: CBPeripheral?
    let trackerService = TrackerService.sharedInstance
    
    @IBOutlet var devicesTableView: UITableView!
    @IBOutlet var actionButton: UIButton!
    @IBOutlet var clearStoredEventsButton: UIButton!
    
    var scanTimeoutTimer: Timer?
    var reconnectTimeoutTimer: Timer?
    
    @IBOutlet var infoView: UIView!
    @IBOutlet var infoLabel: UILabel!
    
    var deviceViewController: DeviceViewController?
    
    var discoveredPeripherals: [TrackerPeripheral] = [] {
        didSet {
            devicesTableView.reloadData()
        }
    }
    
    var state: AppState = .idle {
        didSet {
            switch state {
                case .connected:
                    infoView.isHidden = false
                    infoLabel.text = "Connected"
                    
                case .idle:
                    actionButton.setTitle("Scan", for: .normal)
                    if discoveredPeripherals.count > 0 {
                        infoView.isHidden = true
                        infoLabel.text = nil
                    } else {
                        infoView.isHidden = false
                        infoLabel.text = "Press scan to discover devices"
                    }
                    
                case .reconnecting:
                    actionButton.setTitle("Cancel", for: .normal)
                    infoView.isHidden = false
                    infoLabel.text = "Attempting to reconnect"
                    
                case .scanning:
                    actionButton.setTitle("Stop", for: .normal)
                    infoView.isHidden = true
            }
            
            print("App State: \(state)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        //trackerService.apiKey = "YOUR_KEY_GOES_HERE"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func toggleScanningTapped(_ sender: UIButton) {
        actionButtonTapped()
    }
    
    func actionButtonTapped() {
        switch state {
            case .idle:
                startScanning()
            case .connected:
                () // shouldn't happen
            case .reconnecting:
                cancelReconnect()
            case .scanning:
                stopScanning()
        }
    }
    
    // stop scanning
    private func stopScanning() {
        guard state == .scanning else { return }
        
        centralManager?.stopScan()
        state = .idle
    }
    
    // start scanning
    private func startScanning() {
        guard state == .idle else { return }
        
        state = .scanning
        discoveredPeripherals.removeAll()
        centralManager?.scanForPeripherals(withServices: [CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")], options: nil)
        
        // iOS 9 support for timer
        if AppConfig.scanInterval > 0 {
            scanTimeoutTimer = Timer.scheduledTimer(timeInterval: AppConfig.scanInterval, target: self, selector: #selector(scanTimedOut), userInfo: nil, repeats: false)
        }
        
        
    }
    
    private func cancelReconnect() {
        //guard state == .reconnecting else { return }
        
        guard let peripheral = targetPeripheral else {
            return
        }
        
        centralManager?.cancelPeripheralConnection(peripheral)
        targetPeripheral = nil
        state = .idle
    }
    
    @objc func scanTimedOut(sender: Timer) {
        stopScanning()
    }
    
    @objc func reconnectTimedOut(sender: Timer) {
        cancelReconnect()
    }
    
    func resetVCs(completion: (() -> Void)? = nil) {
        if let firmwareUpdateVC = deviceViewController?.firmwareUpdateViewController {
            firmwareUpdateVC.dismiss(animated: true, completion: {
                self.deviceViewController?.dismiss(animated: true, completion: completion)
            })
        } else if let storedEventsVC = deviceViewController?.storedEventsViewController {
            storedEventsVC.dismiss(animated: true, completion: {
                self.deviceViewController?.dismiss(animated: true, completion: completion)
            })
        } else if let deviceVC = deviceViewController {
            deviceVC.dismiss(animated: true, completion: completion)
        } else {
            completion?()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier) {
            case "showBluetoothStatus":
                guard let bluetoothStatusVC = segue.destination as? BluetoothStatusViewController else {
                    return
                }
            
                bluetoothStatusVC.delegate = self
            
            case "deviceDetails":
                guard
                    let peripheral = targetPeripheral,
                    let deviceVC = segue.destination as? DeviceViewController
                else {
                    return
                }
            
                deviceVC.peripheral = peripheral
                deviceVC.delegate = self
                deviceViewController = deviceVC
            
            default: ()
        }
    }
    
    func handleDiscovered(peripheral: CBPeripheral, rssi: NSNumber) {
        for existingTrackerPeripheral in discoveredPeripherals {
            if existingTrackerPeripheral.peripheral.identifier == peripheral.identifier {
                return
            }
        }
        
        discoveredPeripherals.append(TrackerPeripheral(peripheral: peripheral, rssi: rssi))
    }
}

extension DeviceListViewController: DeviceHandlerDelegate {
    func didStopHandling(_ viewController: UIViewController, peripheral: CBPeripheral) {
        centralManager?.cancelPeripheralConnection(peripheral)
        deviceViewController = nil
    }
}
