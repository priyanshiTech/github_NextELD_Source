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
    
    @discardableResult
    func syncOfflineData() async -> Bool {
        
        let unsyncedLogs = DatabaseManager.shared.fetchLogs(filterTypes: [.notSync, .warning, .nextDayAlert], addWarningAndViolation: true)

        guard !unsyncedLogs.isEmpty else {
            // print(" No unsynced logs found. All data already synced!")
            syncMessage = "All data already synced!"
            return true
        }
            
        let driveringStatusData = unsyncedLogs.map { log in
            
            let safeStatus = log.status
            let safeLocation = log.location.trimmingCharacters(in: .whitespacesAndNewlines)
            let safeLatitude = SharedInfoManager.shared.lattitude
            let safeLongitude = SharedInfoManager.shared.longitude
            
            let voilation = log.isVoilations == "YES" ? "1" : "0"
            let safeLogType = voilation == "0" ? "log" : (log.dutyType)

////
            return DriveringStatusData(
                appVersion: AppInfo.version,
                clientId: AppStorageHandler.shared.clientId ?? 1,
                currentLocation: safeLocation,
                customLocation: safeLocation,
                dateTime: log.startTime.toLocalString(),
                days: log.day,
                driverId: log.userId,
                engineHour: log.engineHours,
                engineStatus: log.engineStatus,
                identifier: log.identifier,
                isSplit: log.isSplit,
                isVoilation: voilation,
                lastOnSleepTime: Int(log.lastSleepTime),
                lattitude: safeLatitude,
                localId: "\(log.id ?? 0)",
                logType: safeLogType,
                longitude: safeLongitude,
                note: log.notes,
                odometer: Double(log.odometer),
                origin: log.origin,
                osVersion: "iOS - \(UIDevice.current.systemVersion)",
                remainingDriveTime: log.remainingDriveTime ?? 0,
                remainingDutyTime: log.remainingDutyTime  ?? 0,
                remainingSleepTime: log.remainingSleepTime  ?? 0,
                remainingWeeklyTime:log.remainingWeeklyTime ?? 0,
                shift: log.shift,
                status: safeStatus,
                utcDateTime: Int(log.timestamp),
                vehicleId: String(log.vehicleId)
            )
        }
        var requestBody = SyncRequest()
        var splitLogs: SplllitLogss = .init(day: 0, dbId: 0, driverId: 0, shift: 0)
        requestBody.driveringStatusData = driveringStatusData
        if let firstLog = DatabaseManager.shared.getLastRecordForSplitShiftLog() {
            splitLogs = SplllitLogss(
                day: firstLog.day,
                dbId: Int(firstLog.id),
                driverId: firstLog.userId,
                shift: firstLog.shift
            )
            
        }
        requestBody.splitLog = splitLogs
        
        // print("Request data To Offline API ::::::::\(requestBody)")
        isSyncing = true
        defer { isSyncing = false }
        
        do {
            
            let encoder = try JSONEncoder().encode(requestBody)
            
            let response: SyncResponse = try await NetworkManager.shared.post(.ForSavingOfflineData, body: requestBody)
            
            print(" API Status: \(String(describing: response.result))")
            if let message = response.message {
                 print(" Message: \(message)")
            }
            
            response.result?.forEach { item in
                 print(" Synced localId: \(item.localId) → serverId: \(item.serverId)")
                DatabaseManager.shared.markLogAsSynced(localId: Int64(item.localId) ?? 0, serverId: item.serverId)
            }
            
            
//            let success = response.status == "2"
//            if let message = response.message, !message.isEmpty {
//                syncMessage = message
//            } else {
//                syncMessage = success ? "Data Synced Successfully!" : "Sync Failed!"
//            }
            return true
        } catch {
            //print(" Sync Failed: \(error.localizedDescription)")
            syncMessage = "Sync Failed!"
            return false
        }
    }
    
    
    func getLocation() async -> String {
        let lattitude = SharedInfoManager.shared.lattitude
        let longitude = SharedInfoManager.shared.longitude
        if lattitude == 0 && longitude == 0 { return ""}
        do {
            let response = try await NetworkManager.shared.get(.getLocation(lattitude: lattitude, Longitude: longitude))
            
            if let result = response["results"] as? [[String:Any]], let formattedAddress = result.first?["formatted_address"] as? String {
                return formattedAddress
            }
        } catch {
            return ""
        }
        return ""
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
