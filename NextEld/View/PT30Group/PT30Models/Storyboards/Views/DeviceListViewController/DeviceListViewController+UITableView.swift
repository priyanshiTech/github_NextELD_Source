//
//  DeviceListViewController+UITableView.swift
//  DeviceManager
//
//  Created by Pacific Track, LLC on 2/13/20.
//  Copyright © 2020 Pacific Track, LLC. All rights reserved.
//

import UIKit

extension DeviceListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discoveredPeripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "deviceCell") as? DeviceTableViewCell else {
            return UITableViewCell()
        }
        
        guard discoveredPeripherals.count > indexPath.row else {
            return cell
        }
        
        cell.deviceNameLabel.text = discoveredPeripherals[indexPath.row].peripheral.name
        cell.deviceDescriptionLabel.text = discoveredPeripherals[indexPath.row].peripheral.identifier.uuidString
        cell.deviceInfoLabel.text = nil
        cell.deviceDescriptionLabel.text = "\(discoveredPeripherals[indexPath.row].rssi) dBm"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard discoveredPeripherals.count > indexPath.row else {
            return
        }
        
        centralManager?.stopScan()
        state = .idle
        
        centralManager?.connect(discoveredPeripherals[indexPath.row].peripheral, options: nil)
    }
}
