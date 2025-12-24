//
//  DvirOfflineViewModel.swift
//  NextEld
//
//  Created by priyanshi   on 13/12/25.
//

import Foundation
import SwiftUI



 class DVIROfflineViewModel: ObservableObject {

    @Published var isSyncing: Bool = false
    @Published var syncMessage: String = ""

    // MARK: - Sync DVIR Offline Logs (call every 1 min)
    @discardableResult
    func syncDVIROfflineLogs() async -> Bool {

        //  Fetch not-synced DVIR records
        let unsyncedRecords =
        DvirDatabaseManager.shared.fetchAllRecords(filterTypes: [.notSync])

        guard !unsyncedRecords.isEmpty else {
            syncMessage = "All DVIR logs already synced"
            return true
        }

        //  Map DB → API model
        let dvirStatusData: [DvirStatusDataOffline] =
        unsyncedRecords.map { record in

            DvirStatusDataOffline(
                clientId: AppStorageHandler.shared.clientId,
                companyName: AppStorageHandler.shared.company,
                dateTime:  DateTimeHelper.formatDateToLocalTime(record.startTime),

                driverId: Int(record.UserID),
                driverSignFile: record.signature?.base64EncodedString(),
                engineHour: nil,
                localId: "\(record.id ?? 0)",
                location: record.location,
                notes: record.notes,
                odometer: Int(record.odometer ?? 0),
                timestamp: Int(record.timestamp),
                trailer: [record.Trailer],
                trailerDefect: [record.trailerDefect],
                truckDefect: [record.truckDefect],
                vehicleCondition: record.vehicleCondition,
                vehicleId: Int(record.vechicleID)
            )
        }

        let requestBody = DvirOfflinedataModel(
            dvirStatusData: dvirStatusData
        )

        isSyncing = true
        defer { isSyncing = false }

        // API Callj
        do {
            let response: DVIROfflineResponseModel =
            try await NetworkManager.shared.post(
                .dvirDataOffline,
                body: requestBody
            )

            //  Token expiry
//            if response.token?.lowercased() == "false" {
            //                SessionManagerClass.shared.clearToken()
//                syncMessage = "Session expired"
//                return false
//            }
            

            //  Mark DVIR records as synced
            response.result?.forEach { item in
                guard let localIdString = item.localId,
                      let localIdInt64 = Int64(localIdString) else {
                    print(" Failed to convert localId to Int64: \(item.localId ?? "nil")")
                    return
                }

                DvirDatabaseManager.shared.updateRecordSyncStatus(
                    localId: localIdInt64,
                    serverId: item.serverId
                )
            }

            syncMessage = response.message ?? "DVIR synced successfully"
            return true

        } catch {
            syncMessage = "DVIR offline sync failed"
            return false
        }
    }
}
