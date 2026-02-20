//
//  EngineSyncMonitor.swift
//  NextEld
//
//  Created by priyanshi on 06/01/26.
//

import Foundation
import os.log

// MARK: - Notification Names
extension Notification.Name {
    static let engineSyncEvent = Notification.Name("ENGINE_SYNC_EVENT")
}

enum EngineSyncEventType {
    case diagnosticStarted
    case diagnosticCleared
    case malfunctionStarted
    case malfunctionCleared
}


// MARK: - Engine Sync Monitor
final class EngineSyncMonitor {

    // MARK: - Thresholds
    private let DIAGNOSTIC_THRESHOLD: TimeInterval = 5          // 5 seconds
    private let MALFUNCTION_THRESHOLD: TimeInterval = 2          // 30 minutes
    private let MONITOR_INTERVAL: TimeInterval = 5              // Check every 5 seconds

    // MARK: - State
    private var lastValidEngineDataTime: TimeInterval?
    private var diagnosticActive = false
    private var malfunctionActive = false
//    private var previousOdometerMiles: Double = 0
//    private var previousEngineHours: Double = 0

    // MARK: - Timer
    private var timer: Timer?

    // MARK: - Start monitoring
    func startMonitoring() {
        stopMonitoring() // Ensure no duplicate timers

        timer = Timer.scheduledTimer(withTimeInterval: MONITOR_INTERVAL, repeats: true) { [weak self] _ in
            self?.checkECMData()
        }
    }

    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: - Periodic ECM check
    private func checkECMData() {
        // Fetch current ECM data (replace with real data source)
        let currentOdometerKM = getCurrentOdometerFromECM()
        let currentEngineHours = getCurrentEngineHoursFromECM()

        processECMData(
            currentOdometerKM: currentOdometerKM,
            currentEngineHours: currentEngineHours
        )
    }

    // MARK: - Process ECM Datan

    
    private func processECMData(
        currentOdometerKM: Double,
        currentEngineHours: Double
    ) {
        let odometerMiles = kilometersToMiles(currentOdometerKM)
        //  Fetch previous values from DB
        let previousOdometerMiles = getPreviousOdometerFromDB()
        let previousEngineHours = getPreviousEngineHoursFromDB()

        os_log(
            "NEW ODO: %{public}.2f miles | OLD ODO: %{public}.2f miles | ENG HRS: %{public}.2f",
            log: .default,
            type: .info,
            odometerMiles,
            previousOdometerMiles,
            previousEngineHours
        )


        //  Valid ECM data check
        if currentEngineHours > previousEngineHours &&
            odometerMiles > previousOdometerMiles {
            onValidEngineData()
        }

        // Always check diagnostics
        engineSyncDiagnostic()
    }

    

    // MARK: - Diagnostic Logic
    private func engineSyncDiagnostic() {
        let now = DateTimeHelper.currentDateTime().timeIntervalSince1970

        guard let lastTime = lastValidEngineDataTime else {
            lastValidEngineDataTime = now
            return
        }

        let elapsed = now - lastTime

        // Diagnostic
        // Diagnostic START
        if elapsed >= DIAGNOSTIC_THRESHOLD && !diagnosticActive {
            diagnosticActive = true
            logEngineSyncEvent(.diagnosticStarted)
        }

        // Malfunction START
        if elapsed >= MALFUNCTION_THRESHOLD && !malfunctionActive {
            malfunctionActive = true
            logEngineSyncEvent(.malfunctionStarted)
        }

    }

    // MARK: - Clear diagnostic when valid data received
    private func onValidEngineData() {
        
        
        lastValidEngineDataTime = DateTimeHelper.currentDateTime().timeIntervalSince1970

        if diagnosticActive {
            diagnosticActive = false
            logEngineSyncEvent(.diagnosticCleared)
        }

        if malfunctionActive {
            malfunctionActive = false
            logEngineSyncEvent(.malfunctionCleared)
        }

    }

    // MARK: - Logger
    private func logEngineSyncEvent(_ type: EngineSyncEventType) {

        let timestamp = Date().timeIntervalSince1970
        let status: String
        let message: String

        switch type {

        case .diagnosticStarted:
            status = "Engine Synchronization Diagnostic STARTED"
            message = "Engine Synchronization Diagnostic STARTED"

        case .diagnosticCleared:
            status = "Engine Synchronization Diagnostic CLEARED"
            message = "Engine Synchronization Diagnostic CLEARED"

        case .malfunctionStarted:
            status = "Engine Synchronization Malfunction STARTED"
            message = "Engine Synchronization Malfunction STARTED"

        case .malfunctionCleared:
            status = "Engine Synchronization Malfunction CLEARED"
            message = "Engine Synchronization Malfunction CLEARED"
        }

        os_log("%@", log: .default, type: .error, message)

//        DatabaseManager.shared.saveEngineSyncEvent(
//            status: status,
//            message: message
//        )

//        NotificationCenter.default.post(
//            name: .engineSyncEvent,
//            object: nil,
//            userInfo: [
//                "status": status,
//                "message": message,
//                "timestamp": timestamp
//            ]
//        )
    }

    // MARK: - odometer  convert kilometerHelpers
    private func kilometersToMiles(_ km: Double) -> Double {
        return km * 0.621371
    }
    
    

    // MARK: - Dummy ECM fetchers (replace with actual BLE/API data)
    private func getCurrentOdometerFromECM() -> Double {
        return 300
        //SharedInfoManager.shared.odometer
    }

    private func getCurrentEngineHoursFromECM() -> Double {
        return SharedInfoManager.shared.engineHours
    }
    //get last record to engine hours
    private func getPreviousOdometerFromDB() -> Double {

        guard let lastLog = DatabaseManager.shared.getLastRecordOfDriverLogs(
            filterTypes: [.day, .shift]
        ) else {
            return 0
        }

        return lastLog.odometer
    }


    private func getPreviousEngineHoursFromDB() -> Double {

        guard let lastLog = DatabaseManager.shared.getLastRecordOfDriverLogs(
            filterTypes: [.day, .shift]
        ) else {
            return 0
        }

        return Double(lastLog.engineHours) ?? 0.0
    }

}
