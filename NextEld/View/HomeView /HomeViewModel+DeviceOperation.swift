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
    
//    private func calculateSpeed(speed: Double) {
//        
//        if speed > 5.0 {
//            
//            if currentDriverStatus != .onDrive {
//                currentDriverStatus = .onDrive
//                saveTimerStateForStatus(status: currentDriverStatus.getName(), originType: .auto)
//            } else {
//
//                // show full screen on drive view
//            }
//            
//            
//        } else if speed == 0 {
//            // show dialog that you are idle from last calculated min do you want to move to onDuty?
//            if currentDriverStatus == .onDrive {
//                alertType = .idleState
//                showAlertOnHomeScreen = true
//            }
//            
//            // dismiss full screen drive view
//        }
//    }
    
    private func calculateSpeed(speed: Double) {
        let currentTime = DateTimeHelper.currentDateTime().timeIntervalSince1970 // current timestamp in seconds

        // MARK: - SPEED > 5 : Driving
        if speed > 5.0 {
            // Add current timestamp to high-speed list
            highSpeedList.append(currentTime)
            
            // Clear low-speed list when speed > 5
            lowSpeedList.removeAll()

            // Remove old timestamps older than 60 seconds (keep only last 60 seconds)
            highSpeedList.removeAll { timestamp in
                currentTime - timestamp > SPEED_WINDOW
            }

            // If 5 high-speed events in last 60 seconds → block screen
            // Check if cooldown period has passed
            let isCooldownActive = blockScreenCooldownUntil != nil && currentTime < blockScreenCooldownUntil!
            
            // Debug: Print tracking info
            // print("🚗 Speed: \(speed) | HighSpeedList Count: \(highSpeedList.count) | Cooldown Active: \(isCooldownActive) | ShowBlockScreen: \(showBlockScreen)")
            
            if highSpeedList.count >= 5 {
                if !isCooldownActive && !showBlockScreen {
                    // Only block if not already showing block screen
                    // print(" Blocking screen - 5 high-speed events detected")
                    
                    // DON'T clear the list - keep tracking so it can block again quickly after dismiss
                    // Only remove the oldest events, keep last 4 so we need just 1 more to trigger again
                    if highSpeedList.count > 4 {
                        highSpeedList = Array(highSpeedList.suffix(4))
                    }
                    
                    // Clear cooldown since we're blocking again
                    blockScreenCooldownUntil = nil
                    
                    // Block the screen
                    showBlockScreen = true
                    
                    // Update driver status to onDrive if not already
                    if currentDriverStatus != .onDrive {
                        setDriverStatus(status: .onDrive)
                        saveTimerStateForStatus(status: currentDriverStatus.getName(), originType: .auto)
                    }
                } else if isCooldownActive {
                    // print("⏳ Cooldown active - waiting before blocking again. Count: \(highSpeedList.count)")
                } else if showBlockScreen {
                    // print("📱 Block screen already showing")
                }
                // If cooldown is active, don't block but keep tracking (don't clear the list)
            } else {
                // print("📊 Tracking: \(highSpeedList.count)/5 events collected")
            }
        }
        // MARK: - SPEED <= 5 (including 0)
        else {
            // Add current timestamp to low-speed list
            lowSpeedList.append(currentTime)
            
            // Clear high-speed list when speed <= 5
            highSpeedList.removeAll()

            // Remove old timestamps older than 60 seconds (keep only last 60 seconds)
            lowSpeedList.removeAll { timestamp in
                currentTime - timestamp > SPEED_WINDOW
            }

            // If 4 low-speed events in last 60 seconds → unblock screen
            if lowSpeedList.count >= 4 {
                // Clear the list after triggering unblock
                lowSpeedList.removeAll()
                
                // Unblock the screen
                unBlockScreen()
            }

            // Additional "idle" dialog when speed == 0  //MARK: -  currently off
//            if speed == 0 {
//                if currentDriverStatus == .onDrive {
//                    alertType = .idleState
//                    showAlertOnHomeScreen = true
//                }
//            }
        }
    }
    
    // MARK: - Unblock Screen Function
    func unBlockScreen() {
        showBlockScreen = false
        
        // Set cooldown period - block screen won't show again for a few seconds
        let currentTime = Date().timeIntervalSince1970
        blockScreenCooldownUntil = currentTime + BLOCK_SCREEN_COOLDOWN
        
        // print("🔓 Unblocking screen - Cooldown until: \(blockScreenCooldownUntil ?? 0) | HighSpeedList Count: \(highSpeedList.count)")
        
        // Don't clear highSpeedList - keep tracking so it can show again after cooldown if condition is still met
        // Clear low-speed list since we're unblocking
        lowSpeedList.removeAll()
        
        // Note: highSpeedList is NOT cleared, so tracking continues
        // After cooldown ends, if speed is still > 5, it will continue adding timestamps
        // and block again when 5 events occur within 60 seconds
    }

    
    private func checkWhetherEngineStarts(rpm: Int) {
        let isEngineStartEntryRequired = isEngineStartStatusLogRequired()
        let isEngineOffEntryRequired = isEngineOffStatusLogRequired()
        
        if rpm >= 500, isEngineStartEntryRequired {
            self.saveTimerStateForStatus(status: AppConstants.engineOn, originType: .auto)
            // print("Engine On...")
        }
        if rpm < 500, isEngineOffEntryRequired {
            self.saveTimerStateForStatus(status: AppConstants.engineOff, originType: .auto)
            // print("Engine Off...")
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
