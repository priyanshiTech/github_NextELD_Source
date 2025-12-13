//
//  CertifyOfflineDM.swift
//  NextEld
//
//  Created by priyanshi on 13/12/25.
//

import Foundation
import SwiftUI


//@MainActor
 class CertifiedOfflineViewModel: ObservableObject {

    @Published var isSyncing = false
    @Published var syncMessage: String = ""

    // MARK: - Sync Certified Logs (called every 1 min)
    @discardableResult
     
    func syncCertifiedOfflineLogs() async -> Bool {
        //  Fetch not-synced certified logs
        let unsyncedRecords =
        CertifyDatabaseManager.shared.fetchAllRecords(filterTypes: [.notSync])

        guard !unsyncedRecords.isEmpty else {
            syncMessage = "All certified logs already synced"
            return true
        }

        //  Map DB → API model
        let certifiedLogData: [CertifiedLogOfflineData] =
        unsyncedRecords.map { record in

            CertifiedLogOfflineData(
                
                certifiedAt: Int(record.startTime.timeIntervalSince1970),
                certifiedDate: record.date,
                certifiedDateTime: Int(record.startTime.timeIntervalSince1970 * 1000),
                certifiedSignature: "\(record.signature)", // if you have it
                coDriverId: record.coDriverID,
                driverId: Int(record.userID),
                localId: record.date, // date is unique in certify table
                shippingDocs: record.selectedShippingDoc
                    .components(separatedBy: ", "),
                trailers: record.selectedTrailer
                    .components(separatedBy: ", "),
                vehicleId: record.vehicleID
            )
        }

        let requestBody = CertifyOfflineData(
            certifiedLogData: certifiedLogData
        )
        
        print("Certidy Offline Data \(requestBody)")

        isSyncing = true
        defer { isSyncing = false }
        //  API Call
        do {
            let response: CertifiedOfflineResponse =
            try await NetworkManager.shared.post(
                .certifyDataOffline,
                body: requestBody
            )


            //  Update certify table as synced
            response.result.forEach { item in
                CertifyDatabaseManager.shared.updateCertifyStatus(
                    for: item.localId,
                    isCertify: "Yes",
                    syncStatus: 1
                )
            }
            syncMessage = response.message
            return true

        } catch {
            syncMessage = "Certified log sync failed"
            return false
        }
    }
}
