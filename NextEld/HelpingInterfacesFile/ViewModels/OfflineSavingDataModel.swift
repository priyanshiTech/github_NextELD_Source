//
//  OfflineSavingDataModel.swift
//  NextEld
//
//  Created by priyanshi   on 17/07/25.
//

import Foundation
import Combine
import SwiftUI


//class SyncViewModel: ObservableObject {
//    @Published var syncMessage = ""
//    @Published var isSyncing = false
//    
//
//    
//    
//    func syncOfflineData() {
//        let unsyncedLogs = DatabaseManager.shared.fetchLogs().filter { !$0.isSynced }
//        
//        guard !unsyncedLogs.isEmpty else {
//            print(" No unsynced logs found. All data already synced!")
//            return
//        }
//        
//        print("📤 Preparing \(unsyncedLogs.count) logs for syncing...")
//        
//        // Convert local DB models to API request models
//        let driveringStatusData = unsyncedLogs.map { log in
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
//                vehicleId: "\(log.vehicleId)"
//            )
//        }
//        
//        let requestBody = SyncRequest(
//            eldLogData: [],
//            driveringStatusData: driveringStatusData,
//            splitLog: SplllitLogss(day: 0, dbId: 0, driverId: 0, shift: 0)
//        )
//        
//        guard let url = URL(string: "YOUR_API_URL_HERE") else { return }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        do {
//            let jsonData = try JSONEncoder().encode(requestBody)
//            request.httpBody = jsonData
//            
//            //  Print JSON before sending
//            print("📤 Sending JSON to server:")
//            print(String(data: jsonData, encoding: .utf8) ?? "Invalid JSON")
//        } catch {
//            print(" Encoding Error: \(error.localizedDescription)")
//            return
//        }
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print(" Sync failed with error: \(error.localizedDescription)")
//                return
//            }
//            
//            guard let httpResponse = response as? HTTPURLResponse else {
//                print("************************** No response from server!")
//                return
//            }
//            
//            print("********************* Server responded with status code: \(httpResponse.statusCode)")
//            
//            if let data = data {
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data, options: [])
//                    print("Server Response JSON: \(json)")
//                    
//                    if let resultDict = json as? [String: Any],
//                       let resultArray = resultDict["result"] as? [[String: Any]] {
//                        
//                        for item in resultArray {
//                            let localId = item["localId"] as? String ?? "N/A"
//                            let serverId = item["serverId"] as? String ?? "N/A"
//                            
//                            print("✔️ Synced localId: \(localId) → serverId: \(serverId)")
//                            
//                            // Update local DB to mark as synced
//                            DatabaseManager.shared.markLogAsSynced(localId: Int64(localId) ?? 0, serverId: serverId)
//                        }
//                    }
//                    
//                } catch {
//                    print(" JSON Parse Error: \(error.localizedDescription)")
//                }
//            }
//            
//        }.resume()
//    }
//    
//}


import Foundation

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
            DriveringStatusData(
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

        let requestBody = SyncRequest(
            eldLogData: [], driveringStatusData: driveringStatusData,
            splitLog: SplllitLogss(day: 0, dbId: 0, driverId: 0, shift: 0)
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
