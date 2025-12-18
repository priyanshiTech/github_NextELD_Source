//
//  certifydatabase.swift
//  NextEld
//
//  Created by priyanshi  on 13/08/25.
//

import Foundation
import SQLite

enum CertifyFilterType {
    case userId
    case specificDate(date:Date)
    case notSync
}

class CertifyDatabaseManager {
    
    static let shared = CertifyDatabaseManager()
    private var db: Connection?
    private let certifyTable = Table("certify_records")
    private let id = Expression<Int64>("id")
    private let userID = Expression<String>("userID")
    private let userName = Expression<String>("userName")
    private let date = Expression<Date>("date")
    private let shift = Expression<Int>("shift")
    private let selectedVehicle = Expression<String>("selectedVehicle")
    private let selectedTrailer = Expression<String>("selectedTrailer")
    private let selectedShippingDoc = Expression<String>("selectedShippingDoc")
    private let selectedCoDriver = Expression<String>("selectedCoDriver")
    private let vehicleID = Expression<Int?>("vehicleID")
    private let coDriverID = Expression<Int?>("coDriverID")
    private let isLogcertified = Expression<String>("isLogcertified")
    private let isSynced = Expression<Int>("isSynced")
    
    
    private init() {
        setupDatabase()
        createTable()
    }
    
    private func setupDatabase() {
        let documentDirectory = try! FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        let fileUrl = documentDirectory.appendingPathComponent("certify.sqlite3")
        db = try? Connection(fileUrl.path)
    }
    
    private func createTable() {
        
        do {
            try db?.run(certifyTable.create(ifNotExists: true) { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(userID)
                table.column(userName)
                table.column(date)
                table.column(shift)
                table.column(selectedVehicle)
                table.column(selectedTrailer)
                table.column(selectedShippingDoc)
                table.column(selectedCoDriver)
                table.column(vehicleID)
                table.column(coDriverID)
                table.column(isSynced)
                table.column(isLogcertified, defaultValue: "No")
            })
        } catch {
            // print("Error creating Certify table: \(error)")
        }
        do {
            try db?.run(certifyTable.addColumn(isLogcertified, defaultValue: "No"))
            // print("Column isLogCertified added successfully ")
        } catch {
            // print("Column may already exist: \(error)")
        }
        
    }
    
    
    
    func insertRecord(_ record: CertifyRecord) {
        do {
            let insert = certifyTable.insert(
                userID <- record.userID,
                userName <- record.userName,
                date <- record.date,
                shift <- record.shift,
                selectedVehicle <- record.selectedVehicle,
                selectedTrailer <- record.selectedTrailer,
                selectedShippingDoc <- record.selectedShippingDoc,
                selectedCoDriver <- record.selectedCoDriver,
                vehicleID <- record.vehicleID,
                coDriverID <- record.coDriverID,
                isSynced <- record.syncStatus,
                isLogcertified <- record.isCertify
                
            )
            let rowId = try db?.run(insert)
            // print("@@@@@@@@@@@@ Certify record inserted with ID: \(rowId ?? -1)")
        } catch {
            // print("@@@@@@@@@@@@@@@ Error inserting Certify record: \(error)")
        }
    }
    
    private func getFilter(for types: [CertifyFilterType]) -> SQLite.Expression<Bool> {
        var filterExpression: SQLite.Expression<Bool> = .init(value: true)
        for type in types {
            switch type {
            case .userId:
                filterExpression = filterExpression && userID == String(AppStorageHandler.shared.driverId ?? 0)
            case .specificDate(let date):
                filterExpression = filterExpression && self.date == date
            case .notSync:
                filterExpression = filterExpression && isSynced == 0
            }
        }
        return filterExpression
    }
    
    func getLastRecordOfCertifyLogs(filterTypes: [CertifyFilterType] = []) -> CertifyRecord? {
        let query = certifyTable.filter(getFilter(for: filterTypes)).order(date.desc).limit(1)
        var records: [CertifyRecord] = []
        do {
            if let rows = try db?.prepare(query) {
                for row in rows {
                    records.append(CertifyRecord(
                        userID: row[userID],
                        userName: row[userName],
                        date: row[date],
                        shift: row[shift],
                        selectedVehicle: row[selectedVehicle],
                        selectedTrailer: row[selectedTrailer],
                        selectedShippingDoc: row[selectedShippingDoc],
                        selectedCoDriver: row[selectedCoDriver],
                        vehicleID: row[vehicleID],     // Int? now
                        coDriverID: row[coDriverID],
                        syncStatus: row[isSynced],
                        isCertify: row[isLogcertified]
                    ))
                }
            }
        } catch {
            // print("Error fetching all records: \(error)")
        }
        return records.first
    }
    
    func fetchAllRecords(filterTypes: [CertifyFilterType] = []) -> [CertifyRecord] {
        let query = certifyTable.filter(getFilter(for: filterTypes))
        var records: [CertifyRecord] = []
        do {
            if let rows = try db?.prepare(query) {
                for row in rows {
                    records.append(CertifyRecord(
                        localID: row[id],
                        userID: row[userID],
                        userName: row[userName],
                        date: row[date],
                        shift: row[shift],
                        selectedVehicle: row[selectedVehicle],
                        selectedTrailer: row[selectedTrailer],
                        selectedShippingDoc: row[selectedShippingDoc],
                        selectedCoDriver: row[selectedCoDriver],
                        vehicleID: row[vehicleID],     // Int? now
                        coDriverID: row[coDriverID],
                        syncStatus: row[isSynced],
                        isCertify: row[isLogcertified]
                    ))
                }
            }
        } catch {
            // print("Error fetching all records: \(error)")
        }
        return records
    }

    
    //MARK: -  For Update Records
    func saveRecord(_ record: CertifyRecord) {
        do {
            // Check if record exists for the same date
            let query = certifyTable.filter(date == record.date)
            if let existing = try db?.pluck(query) {
                try db?.run(query.update(
                    id <- record.localID ?? existing[id],
                    userID <- record.userID,
                    userName <- record.userName,
                    shift <- record.shift,
                    selectedVehicle <- record.selectedVehicle,
                    selectedTrailer <- record.selectedTrailer,
                    selectedShippingDoc <- record.selectedShippingDoc,
                    selectedCoDriver <- record.selectedCoDriver,
                    vehicleID <- record.vehicleID,
                    coDriverID <- record.coDriverID,
                    isSynced <- record.syncStatus,
                    isLogcertified <- record.isCertify,
                ))
                // print("@@@@@ Record updated successfully for date \(record.date)")
            } else {
                // If not exists → insert new
                let insert = certifyTable.insert(
                    userID <- record.userID,
                    userName <- record.userName,
                    date <- record.date,
                    shift <- record.shift,
                    selectedVehicle <- record.selectedVehicle,
                    selectedTrailer <- record.selectedTrailer,
                    selectedShippingDoc <- record.selectedShippingDoc,
                    selectedCoDriver <- record.selectedCoDriver,
                    vehicleID <- record.vehicleID,
                    coDriverID <- record.coDriverID,
                    isSynced <- record.syncStatus,
                    isLogcertified <- record.isCertify
                )
                let rowId = try db?.run(insert)
                // print("@@@@@@@@@@@@ Certify record inserted with ID: \(rowId ?? -1)")
            }
        } catch {
            print("Error saving certifcy record: \(error)")
        }
    }
    
    func updateCertifyStatus(for date: Date, isCertify: String, syncStatus: Int) {
        
        do {
            let query = certifyTable.filter(self.date == date)
            try db?.run(query.update(
                self.isLogcertified <- isCertify,
                self.isSynced <- syncStatus
            ))
            // print("DB updated for \(date): isCertify=\(isCertify), syncStatus=\(syncStatus)")
        } catch {
            // print("Failed to update certify status: \(error)")
        }
        
    }
    
    
    func updateCertifyStatus(for id: Int64, isCertify: String, syncStatus: Int) {
        
        do {
            let query = certifyTable.filter(self.id == id)
            try db?.run(query.update(
                self.isLogcertified <- isCertify,
                self.isSynced <- syncStatus
            ))
            // print("DB updated for \(date): isCertify=\(isCertify), syncStatus=\(syncStatus)")
        } catch {
            // print("Failed to update certify status: \(error)")
        }
        
    }
    
    //MARK: -  Save Server Certify Records from Login Response (same pattern as DVIR)
    func saveServerCertifyRecords(from serverCertifyLogs: [[String: Any]]) {
        guard let db = db else {
            // print(" Database connection is nil, cannot save server Certify records")
            return
        }
        
        var savedCount = 0
        var skippedCount = 0
        
        for serverRecord in serverCertifyLogs {
            // Extract certifiedDate to check if record already exists
            guard let certifiedStringDate = serverRecord["certifiedDate"] as? String, let certifiedDate = certifiedStringDate.asDate(format: .dateOnlyFormat) else {
                // print(" Skipping record: Missing or invalid certifiedDate")
                continue
            }
            
            // Check if record already exists for this date
            if recordExistsForDate(date: certifiedDate) {
                skippedCount += 1
                continue
            }
            
            // Convert server record to CertifyRecord
            if let certifyRecord = convertServerRecordToCertifyRecord(serverRecord) {
                do {
                    let insert = certifyTable.insert(
                        userID <- certifyRecord.userID,
                        userName <- certifyRecord.userName,
                        date <- certifyRecord.date,
                        shift <- certifyRecord.shift,
                        selectedVehicle <- certifyRecord.selectedVehicle,
                        selectedTrailer <- certifyRecord.selectedTrailer,
                        selectedShippingDoc <- certifyRecord.selectedShippingDoc,
                        selectedCoDriver <- certifyRecord.selectedCoDriver,
                        vehicleID <- certifyRecord.vehicleID,
                        coDriverID <- certifyRecord.coDriverID,
                        isSynced <- certifyRecord.syncStatus,
                        isLogcertified <- certifyRecord.isCertify
                    )
                    
                    try db.run(insert)
                    savedCount += 1
                    // print(" Saved server Certify record with date: \(certifiedDate)")
                } catch {
                    // print(" Error saving server Certify record: \(error.localizedDescription)")
                }
            }
        }
        
        // print(" Server Certify records saved: \(savedCount), skipped (duplicates): \(skippedCount)")
    }
    
    // MARK: - Check if record exists for date
    private func recordExistsForDate(date: Date) -> Bool {
        guard let db = db else { return false }
        do {
            let query = certifyTable.filter(self.date == date)
            if let _ = try db.pluck(query) {
                return true
            }
        } catch {
            // print(" Error checking if record exists: \(error)")
        }
        return false
    }
    
    // MARK: - Convert Server Certify JSON to CertifyRecord
    private func convertServerRecordToCertifyRecord(_ serverRecord: [String: Any]) -> CertifyRecord? {
        // Extract driver info
        let driverId = serverRecord["driverId"] as? Int ?? 0
        let driverName = serverRecord["driverName"] as? String ?? ""
        
        // Extract vehicle info
        let vehicleId = serverRecord["vehicleId"] as? Int ?? 0
        let vehicleName = serverRecord["vehicleName"] as? String ?? ""
        
        // Extract co-driver info
        let coDriverId = serverRecord["coDriverId"] as? Int ?? 0
        let coDriverName = serverRecord["coDriverName"] as? String ?? ""
        
        // Extract arrays and convert to comma-separated strings
        let trailersArray = serverRecord["trailers"] as? [String] ?? []
        let shippingDocsArray = serverRecord["shippingDocs"] as? [String] ?? []
        let trailersString = trailersArray.joined(separator: ", ")
        let shippingDocsString = shippingDocsArray.joined(separator: ", ")
        
        // Extract date
        let certifiedDate = serverRecord["certifiedDate"] as? String ?? ""
        
        // Extract timestamp and convert to Date
        // Try certifiedDateTime first (milliseconds), then certifiedAt (seconds)
        var startTime = Date()
        if let certifiedDateTime = serverRecord["certifiedDateTime"] as? Int {
            startTime = Date(timeIntervalSince1970: TimeInterval(certifiedDateTime) / 1000.0)
        } else if let certifiedAt = serverRecord["certifiedAt"] as? Int {
            startTime = Date(timeIntervalSince1970: TimeInterval(certifiedAt))
        } else if let lCertifiedDate = serverRecord["lCertifiedDate"] as? Int64 {
            startTime = Date(timeIntervalSince1970: TimeInterval(lCertifiedDate) / 1000.0)
        }
        
        // Extract shift (default to 0 if not available)
        let shift = serverRecord["shift"] as? Int ?? 0
        
        return CertifyRecord(
            userID: String(driverId),
            userName: driverName,
            date: certifiedDate.asDate(format: .dateOnlyFormat) ?? Date(),
            shift: shift,
            selectedVehicle: vehicleName,
            selectedTrailer: trailersString.isEmpty ? "None" : trailersString,
            selectedShippingDoc: shippingDocsString.isEmpty ? "None" : shippingDocsString,
            selectedCoDriver: coDriverName.isEmpty == false ? coDriverName : "None",
            vehicleID: vehicleId,
            coDriverID: coDriverId,
            signature: nil, // Signature is stored separately in API as base64 string
            syncStatus: 1, // Mark as synced since it came from server
            isCertify: "Yes" // Already certified data from server
        )
    }
    
    //MARK: -  Delete all records from db
    func deleteAllCertifyRecords() {
        do {
            try db?.transaction {
                try db?.run(certifyTable.delete())
                try db?.run("DELETE FROM sqlite_sequence WHERE name = 'certifyTable'")
            }
            // print("##### All certify records deleted successfully!")
        } catch {
            // print("Error deleting all certify records: \(error)")
        }
    }
    
   /* func markCertified(for date: String, userID: String) {
        do {
            let record = certifyTable.filter(self.date == date && self.userID == userID)
            try db?.run(record.update(self.isLogcertified <- "Yes"))
            // print("Updated certification for date \(date) and user \(userID)")
        } catch {
            // print("Failed to update certify flag: \(error)")
        }
        
        let updated = fetchAllRecords()
        // print("After update DB record: \(updated)")
    }*/
    
    func markCertified(for date: Date, userID: String) {
        let record = certifyTable.filter(self.date == date && self.userID == userID)

        do {
            if let _ = try db?.pluck(record) {
                // Row exists -> update
                try db?.run(record.update(self.isLogcertified <- "Yes"))
            } else {
                // Row does NOT exist -> insert new row
                try db?.run(certifyTable.insert(
                    self.date <- date,
                    self.userID <- userID,
                    self.isLogcertified <- "Yes"
                ))
            }
        } catch {
            print("Failed to certify: \(error)")
        }
    }

}
