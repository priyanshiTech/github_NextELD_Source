//
//  StoredEventsViewController+UITableView.swift
//  DeviceManager
//
//  Created by Pacific Track, LLC on 2/13/20.
//  Copyright © 2020 Pacific Track, LLC. All rights reserved.
//

import UIKit

extension StoredEventsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 336
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storedEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let eventCell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell
        
        guard indexPath.row < storedEvents.count else {
            return eventCell
        }
        
        let event = storedEvents[indexPath.row]
        
        let eventType: String
        switch event.eventType {
            case .powerOn:
                eventType = "Power ON"
            case .powerOff:
                eventType = "Power OFF"
            case .ignitionOn:
                eventType = "Ignition ON"
            case .ignitionOff:
                eventType = "Ignition OFF"
            case .engineOn:
                eventType = "Engine ON"
            case .engineOff:
                eventType = "Engine OFF"
            case .tripStart:
                eventType = "Trip START"
            case .tripStop:
                eventType = "Trip STOP"
            case .periodic:
                eventType = "Periodic"
            case .bluetoothConnected:
                eventType = "Bluetooth Connected"
            case .bluetoothDisconnected:
                eventType = "Bluetooth Disconnected"
            case .busConnected:
                eventType = "BUS Connected"
            case .busDisconnected:
                eventType = "BUS Disconnected"
            case .harshAccelerating:
                eventType = "Harsh Accelerating"
            case .harshBraking:
                eventType = "Harsh Braking"
            case .harshCornering:
                eventType = "Harsh Cornering/Swerving"
        }
        
        eventCell.eventLabel.text = eventType
        eventCell.deviceInfoView.eventLabel.text = "#\(event.sequenceNumber)"
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MM-dd-yyyy HH:mm:ss"
        dateFormater.timeZone = TimeZone(abbreviation: "UTC")
        dateFormater.locale = Locale(identifier: "en_US_POSIX")
        eventCell.deviceInfoView.dateTimeLabel.text = dateFormater.string(from: event.datetime)
        
        eventCell.deviceInfoView.latLongLabel.text = "\(event.geolocation.latitude) / \(event.geolocation.longitude)"
        eventCell.deviceInfoView.headingLabel.text = "\(event.geolocation.heading)"
        eventCell.deviceInfoView.sateliteStatusLabel.text = "\(event.geolocation.isLocked ? "Locked" : "Not Locked") (Sat. Count: \(event.geolocation.sateliteCount))"
        eventCell.deviceInfoView.odometerLabel.text = "\(event.odometer) km"
        eventCell.deviceInfoView.velocityLabel.text = "\(event.velocity) km/h"
        eventCell.deviceInfoView.engineHoursLabel.text = "\(event.engineHours)"
        eventCell.deviceInfoView.rpmLabel.text = "\(event.rpm)"
        
        return eventCell
    }
}
