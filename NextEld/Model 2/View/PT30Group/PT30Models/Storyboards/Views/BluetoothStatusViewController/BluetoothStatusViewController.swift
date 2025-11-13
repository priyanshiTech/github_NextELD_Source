//
//  BluetoothStatusViewController.swift
//  DeviceManager
//
//  Created by Pacific Track, LLC on 12/30/19.
//  Copyright © 2020 Pacific Track, LLC. All rights reserved.
//

import UIKit
import CoreBluetooth

class BluetoothStatusViewController: UIViewController {
    var delegate: UIViewControllerEventsDelegate?
    var centralManager: CBCentralManager?
    @IBOutlet var errorMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.dismissed(self)
    }
}

extension BluetoothStatusViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
            case .poweredOff:
                errorMessageLabel.text = "Bluetooth is Powered Off. Please turn it On."
            case .resetting:
                errorMessageLabel.text = "Bluetooth is Resetting."
            case .poweredOn:
                errorMessageLabel.text = "Bluetooth is On."
                dismiss(animated: true) {
                    self.delegate?.dismissed(self)
                }
            case .unknown:
                errorMessageLabel.text = "Bluetooth state is Unknown."
            case .unsupported:
                errorMessageLabel.text = "This device does not support Bluetooth."
            case .unauthorized:
                errorMessageLabel.text = "App is not authorized to use Bluetooth. Please allow this app to use Bluetooth in settings"
            @unknown default: ()
        }
    }
}
