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
            
            var certifyTimeStamp  = currentTimestampMillis()
            let certifiedDate = record.date
            if !DateTimeHelper.calendar.isDateInToday(certifiedDate) {
                
                // time required always in format certifyDate+" 23:59:59"
//                let requiredDateInString = certifiedDate.toLocalString(format: .dateOnlyFormat) + " 23:59:59"
//                let requiredDate = requiredDateInString.asDate()
                let certifiedDateTime = DateTimeHelper.endOfDay(for: certifiedDate)?.addingTimeInterval(-1)
                certifyTimeStamp = String(Int(certifiedDateTime?.timeIntervalSince1970 ?? 0) * 1000)
            }

           return CertifiedLogOfflineData(
                certifiedAt: Int(certifyTimeStamp),
                certifiedDate: certifiedDate.toLocalString(format: .dateOnlyFormat),
                certifiedDateTime: Int(certifyTimeStamp),
                certifiedSignature: nil, // if you have it
                coDriverId: record.coDriverID,
                driverId: Int(record.userID),
                localId: "\(record.localID ?? 0)", // date is unique in certify table
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
                    for: Int64(item.localId) ?? 0,
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
