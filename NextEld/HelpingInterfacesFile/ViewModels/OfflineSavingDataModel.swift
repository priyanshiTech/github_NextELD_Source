//
//  OfflineSavingDataModel.swift
//  NextEld
//
//  Created by priyanshi   on 17/07/25.


import Foundation
import Combine
import SwiftUI

@MainActor
class SyncViewModel: ObservableObject {
    @Published var isSyncing = false
    @Published var syncMessage: String = ""

    func syncOfflineData() async {
        let unsyncedLogs = DatabaseManager.shared.fetchLogs().filter { !$0.isSynced }

        guard !unsyncedLogs.isEmpty else {
            print(" No unsynced logs found. All data already synced!")
            syncMessage = "All data already synced!"
            return
        }

        print("📤 Preparing \(unsyncedLogs.count) logs for syncing...")


 
        let driveringStatusData = unsyncedLogs.map { log in
          

            return DriveringStatusData(
                appVersion: "12.0",
                clientId: 1,
                currentLocation: log.location,
                customLocation: log.location,
                dateTime: log.startTime,
                days: log.day,
                driverId: log.userId,
                engineHour: log.engineHours,
                engineStatus: log.engineStatus,
                identifier: log.identifier,
                isSplit: log.isSplit,
                isVoilation: log.isVoilations,
                lastOnSleepTime: Int(log.lastSleepTime) ?? 0,
                lattitude: log.lat,
                localId: "\(log.id ?? 0)",
                logType: log.dutyType,
                longitude: log.long,
                note: log.notes,
                odometer: Int(log.odometer),
                origin: log.origin,
                osVersion: "iOS - \(UIDevice.current.systemVersion)",
                remainingDriveTime: Int(log.remainingDriveTime ?? "0") ?? 0,
                remainingDutyTime: Int(log.remainingDutyTime ?? "0") ?? 0,
                remainingSleepTime: Int(log.remainingSleepTime ?? "0") ?? 0,
                remainingWeeklyTime: Int(log.remainingWeeklyTime ?? "0") ?? 0,
                shift: log.shift,
                status: log.status,
                utcDateTime: log.timestamp,
                vehicleId: "\(log.vehicleId)"
            )
        }


//        let requestBody = SyncRequest(
//            eldLogData: [], driveringStatusData: driveringStatusData,
//            //splitLog: SplllitLogss(day: 0, dbId: 0, driverId: 0, shift: 0)
//            splitLog:  SplllitLogss(
//                day: log.day,
//                dbId: log.id ?? 0,
//                driverId: log.userId,
//                shift: log.shift
//            )
//
//            
//        )
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

        isSyncing = true
        defer { isSyncing = false }

        do {
            let response: SyncResponse = try await NetworkManager.shared.post(.ForSavingOfflineData, body: requestBody)

            print(" API Status: \(response.status)")
            print(" Message: \(response.message)")
            response.result.forEach { item in
                print("✔️ Synced localId: \(item.localId) → serverId: \(item.serverId)")
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
