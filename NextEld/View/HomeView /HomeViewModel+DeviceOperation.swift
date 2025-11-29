//
//  HomeViewModel+DeviceOperation.swift
//  NextEld
//
//  Created by nitin jain on 29/11/25.
//

import Foundation

extension HomeViewModel {
    func hadleDeviceValues(notification: Notification) {
        if let rpm = notification.userInfo?["rpm"] as? Int {
            checkWhetherEngineStarts(rpm: rpm)
        }
        
        // verify the speed is greater than 5 mile/h change status to onDrive with origin auto
        if let speed = notification.userInfo?["speed"] as? Double {
            calculateSpeed(speed: speed)
        }
        
        if let odometer = notification.userInfo?["odometer"] as? Double {
            SharedInfoManager.shared.odometer = odometer
        }
        
        if let engineHour = notification.userInfo?["engineHours"] as? Double {
            SharedInfoManager.shared.engineHours = engineHour
        }
        
        if let lattitude = notification.userInfo?["lattitude"] as? Double, let longitude = notification.userInfo?["longitude"] as? Double {
            SharedInfoManager.shared.lattitude = lattitude
            SharedInfoManager.shared.longitude = longitude
        }
        
    }
    
    private func calculateSpeed(speed: Double) {
        if speed > 5.0 {
            if currentDriverStatus != .onDrive {
                currentDriverStatus = .onDrive
                saveTimerStateForStatus(status: currentDriverStatus.getName(), originType: .auto)
            } else {
                // show full screen on drive view
            }
            
            
        } else if speed == 0 {
            // show dialog that you are idle from last calculated min do you want to move to onDuty?
            if currentDriverStatus == .onDrive {
                alertType = .idleState
                showAlertOnHomeScreen = true
            }
            
            // dismiss full screen drive view
        }
    }
    
    private func checkWhetherEngineStarts(rpm: Int) {
        let isEngineStartEntryRequired = isEngineStartStatusLogRequired()
        let isEngineOffEntryRequired = isEngineOffStatusLogRequired()
        
        if rpm >= 500, isEngineStartEntryRequired {
            self.saveTimerStateForStatus(status: AppConstants.engineOn, originType: .auto)
            print("Engine On...")
        }
        if rpm < 500, isEngineOffEntryRequired {
            self.saveTimerStateForStatus(status: AppConstants.engineOff, originType: .auto)
            print("Engine Off...")
        }
    }
    
    func isEngineStartStatusLogRequired() ->  Bool {
        guard let logs = DatabaseManager.shared.getLastRecordOfDriverLogs(filterTypes: [.engineStatus]) else {
            return true
        }
        if logs.status == AppConstants.engineOn {
            return false
        } else if logs.status == AppConstants.engineOff {
            return true
        }
        return true
    }
    
    func isEngineOffStatusLogRequired() ->  Bool {
        guard let logs = DatabaseManager.shared.getLastRecordOfDriverLogs(filterTypes: [.engineStatus]) else {
            return false
        }
        if logs.status == AppConstants.engineOff {
            return false
        } else if logs.status == AppConstants.engineOn {
            return true
        }
        return false
    }
}
