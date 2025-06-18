//
//  FrimWareUpdateModel.swift
//  NextEld
//
//  Created by priyanshi on 17/06/25.
//

import Foundation
import PacificTrack
import Combine

class FirmwareUpdateViewModel: ObservableObject {
    @Published var infoText: String = "Checking firmware..."
    @Published var isUpdateButtonVisible: Bool = false
    @Published var isProgressVisible: Bool = false
    @Published var updateInProgress: Bool = false
    
    private let trackerService = TrackerService.sharedInstance
    
    func checkForFirmwareUpdate() {
        trackerService.isUpgradeAvailable { [weak self] isAvailable, error in
            DispatchQueue.main.async {
                guard error == .noError else {
                    self?.infoText = {
                        switch error {
                        case .deviceInfoFailed: return "Error obtaining device info"
                        case .getFirmwareInfoFailed: return "Error obtaining firmware info"
                        case .unauthorized: return "Unauthorized - API key missing"
                        default: return "Unknown error occurred"
                        }
                    }()
                    self?.isProgressVisible = false
                    return
                }
                
                if isAvailable {
                    self?.infoText = "Update available"
                    self?.isUpdateButtonVisible = true
                    self?.isProgressVisible = false
                } else {
                    self?.infoText = "Device firmware is up-to-date."
                    self?.isProgressVisible = false
                }
            }
        }
    }
    
    func startFirmwareUpdate() {
        isUpdateButtonVisible = false
        isProgressVisible = true
        infoText = "Updating..."
        updateInProgress = true
        trackerService.performUpgrade()
        // Optionally: hook into progress delegate if available
    }
}
