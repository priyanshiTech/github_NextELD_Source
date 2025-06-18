//
//  DeviceViewController+TrackerServiceDelegate.swift
//  DeviceManager
//
//  Created by Pacific Track, LLC on 2/13/20.
//  Copyright © 2020 Pacific Track, LLC. All rights reserved.
//

import PacificTrack

extension DeviceViewController: TrackerServiceDelegate {
    func trackerService(_ trackerService: TrackerService, didReceieveVirtualDashboardReport virtualDashboardReport: VirtualDashboardReport) {
        let virtualDashboardData = trackerService.virtualDashboardData
        
        var busString = "-"
        if let busValue = virtualDashboardData.busType {
            switch busValue {
            case 1:
                busString = "OBD-II"
            case 2:
                busString = "J1708"
            case 3:
                busString = "J1708/OBD-II"
            case 4:
                busString = "J1939"
            case 5:
                busString = "J1939/OBD-II"
            case 6:
                busString = "J1939/J1708"
            case 7:
                busString = "J1939/J1708/OBD-II"
            default: ()
            }
        }
        
        dashboardReportView.busLabel.text = busString
        dashboardReportView.gearLabel.text = virtualDashboardData.currentGear != nil ? "\(virtualDashboardData.currentGear!)" : "-"
        dashboardReportView.seatBeltLabel.text = virtualDashboardData.seatbeltOn != nil ? (virtualDashboardData.seatbeltOn! ? "Yes" : "No") : "-"
        dashboardReportView.speedLabel.text = virtualDashboardData.speed != nil ? "\(virtualDashboardData.speed!)" : "-"
        dashboardReportView.rpmLabel.text = virtualDashboardData.rpm != nil ? "\(virtualDashboardData.rpm!)" : "-"
        dashboardReportView.numberOfDtcLabel.text = virtualDashboardData.numberOfDTCPending != nil ? "\(virtualDashboardData.numberOfDTCPending!)" : "-"
        dashboardReportView.oilPressureLabel.text = virtualDashboardData.oilPressure != nil ? "\(virtualDashboardData.oilPressure!)" : "-"
        dashboardReportView.oilLevelLabel.text = virtualDashboardData.oilLevel != nil ? "\(virtualDashboardData.oilLevel!)" : "-"
        dashboardReportView.oilTempLabel.text = virtualDashboardData.oilTemperature != nil ? "\(virtualDashboardData.oilTemperature!)" : "-"
        dashboardReportView.coolantLevelLabel.text = virtualDashboardData.coolantLevel != nil ? "\(virtualDashboardData.coolantLevel!)" : "-"
        dashboardReportView.coolantTempLabel.text = virtualDashboardData.coolantTemperature != nil ? "\(virtualDashboardData.coolantTemperature!)" : "-"
        dashboardReportView.fuelLevelLabel.text = virtualDashboardData.fuelLevel != nil ? "\(virtualDashboardData.fuelLevel!)" : "-"
        dashboardReportView.fuelLevelTank2Label.text = virtualDashboardData.fuelLevel2 != nil ? "\(virtualDashboardData.fuelLevel2!)" : "-"
        dashboardReportView.DEFLevelLabel.text = virtualDashboardData.DEFlevel != nil ? "\(virtualDashboardData.DEFlevel!)" : "-"
        dashboardReportView.loadLabel.text = virtualDashboardData.engineLoad != nil ? "\(virtualDashboardData.engineLoad!)" : "-"
        dashboardReportView.ambientPressureLabel.text = virtualDashboardData.barometer != nil ? "\(virtualDashboardData.barometer!)" : "-"
        dashboardReportView.intakeTemperatureLabel.text = virtualDashboardData.intakeManifoldTemperature != nil ? "\(virtualDashboardData.intakeManifoldTemperature!)" : "-"
        dashboardReportView.fuelTankTemperatureLabel.text = virtualDashboardData.engineFuelTankTemperature != nil ? "\(virtualDashboardData.engineFuelTankTemperature!)" : "-"
        dashboardReportView.intercoolerTemperatureLabel.text = virtualDashboardData.engineIntercoolerTemperature != nil ? "\(virtualDashboardData.engineIntercoolerTemperature!)" : "-"
        dashboardReportView.turboOilTemperatureLabel.text = virtualDashboardData.engineTurboOilTemperature != nil ? "\(virtualDashboardData.engineTurboOilTemperature!)" : "-"
        dashboardReportView.transmisionOilTemperatureLabel.text = virtualDashboardData.transmisionOilTemperature != nil ? "\(virtualDashboardData.transmisionOilTemperature!)" : "-"
        dashboardReportView.fuelRateLabel.text = virtualDashboardData.fuelRate != nil ? "\(virtualDashboardData.fuelRate!)" : "-"
        dashboardReportView.fuelEconomyLabel.text = virtualDashboardData.averageFuelEconomy != nil ? "\(virtualDashboardData.averageFuelEconomy!.roundTo(numberOfDecimals: 2))" : "-"
        dashboardReportView.ambientTemperatureLabel.text = virtualDashboardData.ambientAirTemperature != nil ? "\(virtualDashboardData.ambientAirTemperature!.roundTo(numberOfDecimals: 2))" : "-"
        dashboardReportView.odometerLabel.text = virtualDashboardData.odometer != nil ? "\(virtualDashboardData.odometer!)" : "-"
        dashboardReportView.engineHoursLabel.text = virtualDashboardData.engineHours != nil ? "\(virtualDashboardData.engineHours!)" : "-"
        dashboardReportView.idleHoursLabel.text = virtualDashboardData.idleHours != nil ? "\(virtualDashboardData.speed!)" : "-"
        dashboardReportView.PTOLabel.text = virtualDashboardData.PTOHours != nil ? "\(virtualDashboardData.PTOHours!)" : "-"
        dashboardReportView.totalFuelIdleLabel.text = virtualDashboardData.totalIdleFuel != nil ? "\(virtualDashboardData.totalIdleFuel!)" : "-"
        dashboardReportView.totalFuelUsedLabel.text = virtualDashboardData.totalFuelUsed != nil ? "\(virtualDashboardData.totalFuelUsed!)" : "-"
    }
    
    func trackerService(_ trackerService: TrackerService, didSync trackerInfo: TrackerInfo) {
        showStoredEventsUI(true)
        fetchStoredEventsCount()
        refreshDeviceInfo(withTrackerInfo: trackerInfo)
        firmwareUpdateViewController?.close()
    }
    
    func trackerService(_ trackerService: TrackerService, didRetrieve event: EventFrame, processed: ((Bool) -> Void)) {
        processed(storedEventsViewController?.addStoredEvent(event) == true)
    }
    
    func trackerService(_ trackerService: TrackerService, didReceive event: EventFrame, processed: ((Bool) -> Void)) {
        
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
        let eventTag = event.getValue(forTag: "E") ?? ""
        deviceInfoView.eventLabel.text = "#\(event.sequenceNumber) \(eventTag) (\(eventType))"
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MM-dd-yyyy HH:mm:ss"
        dateFormater.timeZone = TimeZone(abbreviation: "UTC")
        dateFormater.locale = Locale(identifier: "en_US_POSIX")
        deviceInfoView.dateTimeLabel.text = dateFormater.string(from: event.datetime)
        
        deviceInfoView.latLongLabel.text = "\(event.geolocation.latitude) / \(event.geolocation.longitude)"
        deviceInfoView.headingLabel.text = "\(event.geolocation.heading)"
        deviceInfoView.sateliteStatusLabel.text = "\(event.geolocation.isLocked ? "Locked" : "Not Locked") (Sat. Count: \(event.geolocation.sateliteCount))"
        deviceInfoView.odometerLabel.text = "\(event.odometer) km"
        deviceInfoView.velocityLabel.text = "\(event.velocity) km/h"
        deviceInfoView.engineHoursLabel.text = "\(event.engineHours)"
        deviceInfoView.rpmLabel.text = "\(event.rpm)"
        
        // returning true tell tracker that the event was processed so that it
        // doesn't need to store it trakcer's memory
        processed(true)
    }
    
    func trackerService(_ trackerService: TrackerService, didReceiveSPN spnEvent: SPNEventFrame, processed: ((Bool) -> Void)) {
        
    }
    
    func trackerService(_ trackerService: TrackerService, onError error: TrackerServiceError) {
        
    }
    
    func trackerService(_ trackerService: TrackerService, onFirmwareUpgradeProgress progress: Float) {
        firmwareUpdateViewController?.progressBar.progress = progress
        
        guard progress > 0 else {
            updateStartTime = DispatchTime.now()
            return
        }
        
        if let updateStart = updateStartTime {
            let currentTime = DispatchTime.now()
            let currentDuration = Double(currentTime.uptimeNanoseconds - updateStart.uptimeNanoseconds) / (1000 * 1000 * 1000) // nanoseconds -> seconds
            let estimateSeconds = (1 / Double(progress)) * currentDuration
            let estimateRemainingSeconds = Int(estimateSeconds - currentDuration)
            let minutes = estimateRemainingSeconds / 60
            let seconds = estimateRemainingSeconds - minutes * 60
            firmwareUpdateViewController?.estimateLabel.text = "Estimated time remaining: \(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
            //firmwareUpdateViewController?.estimateLabel.text = "\(1 / progress) - \(currentDuration) - \(estimateRemainingSeconds)"
        }
    }
    
    func trackerService(_ trackerService: TrackerService, onFirmwareUpgradeFailed error: TrackerUpgradeError) {
        switch error {
            case .canceled:
                firmwareUpdateViewController?.infoLabel.text = "Upgrade was canceled"
                
            case .checksumError:
                firmwareUpdateViewController?.infoLabel.text = "Checksum error"
                
            case .deviceInfoFailed:
                firmwareUpdateViewController?.infoLabel.text = "Error obtaining device info"
                
            case .deviceStatusFailed:
                firmwareUpdateViewController?.infoLabel.text = "Error obtaining device status"
                
            case .fileIOError:
                firmwareUpdateViewController?.infoLabel.text = "File open/close error"
                
            case .firmwareDownloadFailed:
                firmwareUpdateViewController?.infoLabel.text = "Error downloading firmware"
                
            case .getFirmwareInfoFailed:
                firmwareUpdateViewController?.infoLabel.text = "Error obtaining firmware info"
                
            case .noError:
                firmwareUpdateViewController?.infoLabel.text = ""
                
            case .sequenceError:
                firmwareUpdateViewController?.infoLabel.text = "File chunks received out of order"
                
            case .sizeMismatch:
                firmwareUpdateViewController?.infoLabel.text = "Size mismatch"
                
            case .timeout:
                firmwareUpdateViewController?.infoLabel.text = "Timeout"
                
            case .unauthorized:
                firmwareUpdateViewController?.infoLabel.text = "Unauthorized - API key missing"
                
            case .upgradeFailed:
                firmwareUpdateViewController?.infoLabel.text = "General error"
                
            case .upgradeInitFailed:
                firmwareUpdateViewController?.infoLabel.text = "Upgrade initialization failed"
                
            case .upgradeNotRequired:
                firmwareUpdateViewController?.infoLabel.text = "Device firwmare is up-to-date"
        }
        
        firmwareUpdateViewController?.progressView.isHidden = true
        if #available(iOS 13.0, *) {
            firmwareUpdateViewController?.isModalInPresentation = false
        }
    }
    
    func trackerService(_ trackerService: TrackerService, onFirmwareUpgradeCompleted completed: Bool) {
        firmwareUpdateViewController?.infoLabel.text = "Firmware Update Completed"
        firmwareUpdateViewController?.estimateLabel.text = "Waiting for device to sync"
        if #available(iOS 13.0, *) {
            self.firmwareUpdateViewController?.isModalInPresentation = false
        }
    }
    
   
}
