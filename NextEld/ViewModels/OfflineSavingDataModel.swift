//
//  OfflineSavingDataModel.swift
//  NextEld
//
//  Created by priyanshi   on 17/07/25.


import Foundation
import Combine
import SwiftUI

class SyncViewModel: ObservableObject {
    @Published var isSyncing = false
    @Published var syncMessage: String = ""
    
    func syncOfflineData() async {
        
        let unsyncedLogs = DatabaseManager.shared.fetchLogs(filterTypes: [.notSync])

        guard !unsyncedLogs.isEmpty else {
            print(" No unsynced logs found. All data already synced!")
            syncMessage = "All data already synced!"
            return
        }
        
        print("📤 Preparing \(unsyncedLogs.count) logs for syncing...")
        
        func normalizedStatus(_ value: String) -> String {
            let key = value.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            switch key {
            case "on-duty", "onduty", "on_duty":
                return "OnDuty"
            case "off-duty", "offduty", "off_duty":
                return "OffDuty"
            case "on-drive", "ondrive", "drive", "driving", "on_drive":
                return "OnDrive"
            case "sleep", "sleeper", "on-sleep", "on_sleep":
                return "Sleep"
            case "personaluse", "personal_use", "personal-conveyance":
                return "PersonalUse"
            case "yardmode", "yard_move", "yard-mode":
                return "YardMode"
            default:
                return value.isEmpty ? "OnDuty" : value
            }
        }
        
//        let dateFormatter: DateFormatter = {
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            formatter.timeZone = TimeZone(secondsFromGMT: 0)
//            formatter.locale = Locale(identifier: "en_US_POSIX")
//            return formatter
//        }()
//        
        
        let driveringStatusData = unsyncedLogs.map { log in
            
            let safeStatus = normalizedStatus(log.status)
            let safeLogType = "log"
            
            let storedLocation = AppStorageHandler.shared.customLocation ??
            UserDefaults.standard.string(forKey: "customLocation") ?? "Unknown Location"
            let trimmedLocation = log.location.trimmingCharacters(in: .whitespacesAndNewlines)
            let safeLocation = trimmedLocation.isEmpty ? storedLocation : trimmedLocation
            
            let safeLatitude = log.lat == 0 ? (AppStorageHandler.shared.lattitude ?? 0) : log.lat
            let safeLongitude = log.long == 0 ? (AppStorageHandler.shared.longitude ?? 0) : log.long
//            
            return DriveringStatusData(
                appVersion: AppInfo.version,
                clientId: AppStorageHandler.shared.clientId ?? 1,
                currentLocation: safeLocation,
                customLocation: safeLocation,
                dateTime: DateTimeHelper.getCurrentDateTimeString(),
                days: log.day,
                driverId: AppStorageHandler.shared.driverId ?? 0,
                engineHour: log.engineHours,
                engineStatus: log.engineStatus,
                identifier: 0,
                isSplit: log.isSplit,
                isVoilation: log.isVoilations,
                lastOnSleepTime: Int(log.lastSleepTime),
                lattitude: safeLatitude,
                localId: "\(log.id ?? 0)",
                logType: safeLogType,
                longitude: safeLongitude,
                note: log.notes,
                odometer: Double(log.odometer),
                origin: AppStorageHandler.shared.origin,
                osVersion: "iOS - \(UIDevice.current.systemVersion)",
                remainingDriveTime: log.remainingDriveTime ?? 0,
                remainingDutyTime: log.remainingDutyTime  ?? 0,
                remainingSleepTime: log.remainingSleepTime  ?? 0,
                remainingWeeklyTime:log.remainingWeeklyTime ?? 0,
                shift: log.shift,
                status: safeStatus,
                utcDateTime: Int(log.timestamp),
                vehicleId: "\(AppStorageHandler.shared.vehicleId ?? 0)"
            )
        }
        
        guard let firstLog = unsyncedLogs.first else { return }
        
        let splitLog = SplllitLogss(
            day: firstLog.day,
            dbId: Int(firstLog.id ?? 0),
            driverId: firstLog.userId,
            shift: firstLog.shift
        )
        
        let requestBody = SyncRequest(
            eldLogData: [],
            driveringStatusData: driveringStatusData,
            splitLog: splitLog
        )
        print("Request data To Offline API ::::::::\(requestBody)")
        isSyncing = true
        defer { isSyncing = false }
        
        do {
            let response: SyncResponse = try await NetworkManager.shared.post(.ForSavingOfflineData, body: requestBody)
            
            print(" API Status: \(response.status)")
            print(" Message: \(response.message)")
            
            response.result?.forEach { item in
                print(" Synced localId: \(item.localId) → serverId: \(item.serverId)")
                DatabaseManager.shared.markLogAsSynced(localId: Int64(item.localId) ?? 0, serverId: item.serverId)
            }
            syncMessage = response.status == "SUCCESS" ? "Data Synced Successfully!" : "Sync Failed!"
        } catch {
            print(" Sync Failed: \(error.localizedDescription)")
            syncMessage = "Sync Failed!"
        }
    }
}
































































//*//        let driveringStatusData = unsyncedLogs.map { log in
//            DriveringStatusData(
//                appVersion: "12.0",
//                clientId: 1,
//                currentLocation: log.location,
//                customLocation: log.location,
//                dateTime: log.startTime,
//                days: log.day,
//                driverId: log.userId,





//                engineHour: log.engineHours,
//                engineStatus: log.engineStatus,
//                identifier: log.identifier,
//                isSplit: log.isSplit,
//                isVoilation: log.isVoilations,
//                lastOnSleepTime: Int(log.lastSleepTime) ?? 0,
//                lattitude: log.lat,
//                localId: "\(log.id ?? 0)",
//                logType: log.dutyType,
//                longitude: log.long,
//                note: log.notes,
//                odometer: Int(log.odometer),
//                origin: log.origin,
//                osVersion: "iOS - \(UIDevice.current.systemVersion)",
//                remainingDriveTime: Int(log.remainingDriveTime ?? "0") ?? 0,
//                remainingDutyTime: Int(log.remainingDutyTime ?? "0") ?? 0,
//                remainingSleepTime: Int(log.remainingSleepTime ?? "0") ?? 0,
//                remainingWeeklyTime: Int(log.remainingWeeklyTime ?? "0") ?? 0,
//                shift: log.shift,
//                status: log.status,
//                utcDateTime: log.timestamp,
//
//                vehicleId: "\(log.vehicleId)"
//            )
//        }
//*//
