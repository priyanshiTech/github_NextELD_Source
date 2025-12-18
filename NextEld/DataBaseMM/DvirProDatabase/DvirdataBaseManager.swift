//
//  DvirdataBaseManager.swift
//  NextEld
//
//  Created by priyanshi   on 26/07/25.
//
import Foundation
import SwiftUI
import UIKit
import SQLite

enum DVIRFilterType {
    case user
    case between(startDate:Date, endDate: Date)
    case day
    case shift
    case notSync
    
}


class DvirDatabaseManager {
    static let shared = DvirDatabaseManager()
    
    private var db: Connection?
    private let dvirTable = Table("dvir_records")
    private let id = Expression<Int64>("id")
    private let UserID = Expression<String>("UserID")
    private let UserName = Expression<String>("UserName")
    private let startTime = Expression<Date>("startTime")
    private let DAY = Expression<Int>("DAY")
    private let Shift = Expression<Int>("Shift")
    private let DvirTime = Expression<String>("DvirTime")
    private let odometer = Expression<Double?>("odometer")
    private let location = Expression<String>("location")
    private let truckDefect = Expression<String>("truckDefect")
    private let trailerDefect = Expression<String>("trailerDefect")
    private let vehicleCondition = Expression<String>("vehicleCondition")
    private let notes = Expression<String>("notes")
    private let vehicleName = Expression<String>("vehicleName")
    private let vechicleID = Expression<String>("vechicleID")
    private let Sync = Expression<Int>("Sync")
    private let timestamp = Expression<String>("timestamp")
    private let Server_ID = Expression<String>("Server_ID")
    private let Trailer = Expression<String>("Trailer")
    private let Signature = Expression<Data?>("Signature") //  define image column
    
    private init() {
        setupDatabase()
        createTable()
    }
    
    private func setupDatabase() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("dvir.sqlite3")
            db = try Connection(fileUrl.path)
            // print(" Database connection established: \(fileUrl.path)")
        } catch {
            // print(" Database setup error: \(error.localizedDescription)")
            // Try to create database with alternative path
            do {
                let fileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("dvir.sqlite3")
                db = try Connection(fileUrl.path)
                // print(" Database connection established (alternative path): \(fileUrl.path)")
            } catch {
                // print(" Failed to create database connection: \(error.localizedDescription)")
            }
        }
    }
    
    private func createTable() {
        guard let db = db else {
            // print(" Database connection is nil, cannot create table")
            return
        }
        
        do {
            try db.run(dvirTable.create(ifNotExists: true) { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(UserID)
                table.column(UserName)
                table.column(startTime)
                table.column(DAY)
                table.column(Shift)
                table.column(DvirTime)
                table.column(odometer)
                table.column(location)
                table.column(truckDefect)
                table.column(trailerDefect)
                table.column(vehicleCondition)
                table.column(notes)
                table.column(vehicleName)
                table.column(vechicleID)
                table.column(Sync)
                table.column(timestamp)
                table.column(Server_ID)
                table.column(Trailer)
                table.column(Signature)// Data? type column for image or file data
            })
            // print(" DVIR table created successfully (if not already present).")
        } catch {
            // print(" Error creating DVIR table: \(error.localizedDescription)")
            // print(" Error details: \(error)")
        }
    }


    func insertRecord(_ record: DvirRecord) {
        guard let db = db else {
            // print(" Database connection is nil, cannot insert record")
            return
        }
        
        do {
            let insert = dvirTable.insert(
                UserID <- record.UserID,
                UserName <- record.UserName,
                startTime <- record.startTime,
                DAY <- record.DAY,
                Shift <- record.Shift,
                DvirTime <- record.DvirTime,
                odometer <- record.odometer,
                location <- record.location,
                truckDefect <- record.truckDefect,
                trailerDefect <- record.trailerDefect,
                vehicleCondition <- record.vehicleCondition,
                notes <- record.notes,
                vehicleName <- record.vehicleName,
                vechicleID <- record.vechicleID,
                Sync <- record.Sync,
                timestamp <- record.timestamp,
                Server_ID <- record.Server_ID,
                Trailer <- record.Trailer,
                Signature <- record.signature
            )
            
            let rowId = try db.run(insert)
            // print(" DVIR record inserted with ID: \(rowId)")
            if let dataSize = record.signature?.count {
                // print("📋 Signature data size: \(dataSize) bytes")
            }
        } catch {
            // print(" Database insert error: \(error.localizedDescription)")
            // print(" Error details: \(error)")
        }
    }
    
    private func getFilter(for types: [DVIRFilterType]) -> SQLite.Expression<Bool> {
        var filterExpression: SQLite.Expression<Bool> = .init(value: true)
        for type in types {
            switch type {
            case .user:
                filterExpression = filterExpression && UserID == String(AppStorageHandler.shared.driverId ?? 0)
            case .between(let startDate, let endDate):
                filterExpression = filterExpression && startTime > startDate && startTime < endDate
            case .day:
                filterExpression = filterExpression && DAY == (AppStorageHandler.shared.days)
            case .shift:
                filterExpression = filterExpression && Shift == (AppStorageHandler.shared.shift)
            case .notSync:
                filterExpression = filterExpression && Sync == 0
            }
        }
        return filterExpression
    }

    
    func fetchAllRecords(filterTypes: [DVIRFilterType] = [], limit: Int? = nil) -> [DvirRecord] {
        var records: [DvirRecord] = []
        
        guard let db = db else {
            // print(" Database connection is nil, cannot fetch records")
            return records
        }
        var query = dvirTable.filter(getFilter(for: filterTypes))
        if let limit = limit {
            query = query.limit(limit).order(startTime.desc)
        }
        do {
            let rows = try db.prepare(query)
            for row in rows {
                let record = DvirRecord(
                    id: row[id],
                    UserID: row[UserID],
                    UserName: row[UserName],
                    startTime: row[startTime],
                    DAY: row[DAY],
                    Shift: row[Shift],
                    DvirTime: row[DvirTime],
                    odometer: row[odometer],
                    location: row[location],
                    truckDefect: row[truckDefect],
                    trailerDefect: row[trailerDefect],
                    vehicleCondition: row[vehicleCondition],
                    notes: row[notes],
                    vehicleName: row[vehicleName],
                    vechicleID: row[vechicleID],
                    Sync: row[Sync],
                    timestamp: row[timestamp],
                    Server_ID: row[Server_ID],
                    Trailer: row[Trailer],
                    signature: row[Signature]
                )
                records.append(record)
            }
            // print(" Fetched \(records.count) DVIR records from database")
        } catch {
            // print(" Database fetch error: \(error.localizedDescription)")
            // print(" Error details: \(error)")
        }
        return records
    }

    //MARK: -  Fetch today's last log
    func fetchTodaysLastLog() -> DvirRecord? {
        guard let db = db else {
            // print(" Database connection is nil, cannot fetch today's log")
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let today = formatter.string(from: Date())
        
        // Filter today's records and order by DvirTime descending
        let query = dvirTable.order(DvirTime.desc)
        
        do {
            if let row = try db.pluck(query) {
                return DvirRecord(
                    id: row[id],
                    UserID: row[UserID],
                    UserName: row[UserName],
                    startTime: row[startTime],
                    DAY: row[DAY],
                    Shift: row[Shift],
                    DvirTime: row[DvirTime],
                    odometer: row[odometer],
                    location: row[location],
                    truckDefect: row[truckDefect],
                    trailerDefect: row[trailerDefect],
                    vehicleCondition: row[vehicleCondition],
                    notes: row[notes],
                    vehicleName: row[vehicleName],
                    vechicleID: row[vechicleID],
                    Sync: row[Sync],
                    timestamp: row[timestamp],
                    Server_ID: row[Server_ID],
                    Trailer: row[Trailer],
                    signature: row[Signature]
                )
            }
        } catch {
            // print(" Error fetching today's last DVIR log: \(error.localizedDescription)")
        }
        
        return nil
    }

 
}

extension DvirDatabaseManager {
    
    // MARK: - Fetch Record for a Specific Date
    func fetchRecord(for dayValue: String) -> DvirRecord? {
        guard let db = db else {
            // print(" Database connection is nil, cannot fetch record for date: \(dayValue)")
            return nil
        }
        
        do {
            let query = dvirTable.filter(DAY == Int(dayValue) ?? 0)
            if let row = try db.pluck(query) {
                return DvirRecord(
                    id: row[id],
                    UserID: row[UserID],
                    UserName: row[UserName],
                    startTime: row[startTime],
                    DAY: row[DAY],
                    Shift: row[Shift],
                    DvirTime: row[DvirTime],
                    odometer: row[odometer],
                    location: row[location],
                    truckDefect: row[truckDefect],
                    trailerDefect: row[trailerDefect],
                    vehicleCondition: row[vehicleCondition],
                    notes: row[notes],
                    vehicleName: row[vehicleName],
                    vechicleID: row[vechicleID],
                    Sync: row[Sync],
                    timestamp: row[timestamp],
                    Server_ID: row[Server_ID],
                    Trailer: row[Trailer],
                    signature: row[Signature]
                )
            }
        } catch {
            // print(" Database fetch error for date \(dayValue): \(error.localizedDescription)")
        }
        return nil
    }
    // MARK: - Update Sync Status
    func updateRecordSyncStatus(localId: Int64, serverId: String?) {
        guard let db = db else { return }

        let row = dvirTable.filter(id == localId)

        do {
            try db.run(row.update(
                Sync <- 1,
                Server_ID <- (serverId ?? ""),
               
            ))
            print("ServerId in DVIRdatabaseManegr $$$$$$$: \(Server_ID)")
        } catch {
            // print("Failed to update DVIR sync status: \(error)")
        }
    }

    
    // MARK: - Update Record by ID
    func updateRecord(_ record: DvirRecord) {
        guard let recordId = record.id else {
            // print(" Cannot update record: record ID is nil")
            return
        }
        
        guard let db = db else {
            // print(" Database connection is nil, cannot update record")
            return
        }
        
        let query = dvirTable.filter(id == recordId)
        
        do {
            let updatedRows = try db.run(query.update(
                UserID <- record.UserID,
                UserName <- record.UserName,
                startTime <- record.startTime,
                DAY <- record.DAY,
                Shift <- record.Shift,
                DvirTime <- record.DvirTime,
                odometer <- record.odometer,
                location <- record.location,
                truckDefect <- record.truckDefect,
                trailerDefect <- record.trailerDefect,
                vehicleCondition <- record.vehicleCondition,
                notes <- record.notes,
                vehicleName <- record.vehicleName,
                vechicleID <- record.vechicleID,
                Sync <- record.Sync,
                timestamp <- record.timestamp,
                Server_ID <- record.Server_ID,
                Trailer <- record.Trailer,
                Signature <- record.signature
            ))
            // print(" DVIR record updated with ID: \(recordId), rows affected: \(updatedRows)")
        } catch {
            // print(" Database update error: \(error.localizedDescription)")
            // print(" Error details: \(error)")
        }
    }
    
    

    
    // MARK: - Update Record by User + Date (Alternative Update)
    func updateRecord(_ record: DvirRecord, userID: String, day: Int) {
        do {
            guard let db = db else { return }
            let row = dvirTable.filter(self.UserID == userID && self.DAY == day)
            try db.run(row.update(
                self.startTime <- record.startTime,
                self.DvirTime <- record.DvirTime,
                self.Shift <- record.Shift,
                self.odometer <- record.odometer,
                self.location <- record.location,
                self.truckDefect <- record.truckDefect,
                self.trailerDefect <- record.trailerDefect,
                self.vehicleCondition <- record.vehicleCondition,
                self.notes <- record.notes,
                self.vehicleName <- record.vehicleName,
                self.vechicleID <- record.vechicleID,
                self.Sync <- record.Sync,
                self.timestamp <- record.timestamp,
                self.Server_ID <- record.Server_ID,
                self.Trailer <- record.Trailer,
                self.Signature <- record.signature
            ))
            // print(" DVIR record updated for UserID: \(userID) on \(day)")
        } catch {
            // print(" Error updating DVIR record: \(error)")
        }
    }
    
    
    
    //MARK: -  Checking  information same day, shift
    func hasDvirFor(day: Int, shift: Int) -> Bool {
        do {
            guard let db = db else { return false }
            
            // Filter where both DAY and Shift match exactly
            let query = dvirTable.filter(self.DAY == day && self.Shift == shift)
            
            // Count how many rows match this condition
            let count = try db.scalar(query.count)
            
            // If one or more records found → return true (already exists)
            return count > 0
        } catch {
            // print("Error checking DVIR for day \(day) & shift \(shift): \(error)")
            return false
        }
    }

    
    // MARK: - Delete All Records
    func deleteAllRecordsForDvirDataBase() {
        do {
            try db?.transaction {
                try db?.run(dvirTable.delete())
                try db?.run("DELETE FROM sqlite_sequence WHERE name = 'dvirTable'")
            }
            // print(" Deleted all DVIR records (\(deletedCount) rows removed)")
        } catch {
            // print(" Error deleting all DVIR records: \(error)")
        }
    }
    
    // MARK: - Check if record exists by Server_ID
    func recordExists(serverId: String) -> Bool {
        guard let db = db else {
            // print(" Database connection is nil, cannot check record existence")
            return false
        }
        
        do {
            let query = dvirTable.filter(Server_ID == serverId)
            let count = try db.scalar(query.count)
            return count > 0
        } catch {
            // print(" Error checking record existence: \(error.localizedDescription)")
            return false
        }
    }
    
    // MARK: - Save Server DVIR Records from Login Response
    func saveServerDvirRecords(from serverDvirLogs: [[String: Any]]) {
        guard let db = db else {
            // print(" Database connection is nil, cannot save server DVIR records")
            return
        }
        
        var savedCount = 0
        var skippedCount = 0
        
        for serverRecord in serverDvirLogs {
            // Extract Server_ID (_id)
            guard let serverId = serverRecord["_id"] as? String, !serverId.isEmpty else {
                // print(" Skipping record: Missing or invalid _id")
                continue
            }
            
            // Check if record already exists
            if recordExists(serverId: serverId) {
                skippedCount += 1
                continue
            }
            
            // Convert server record to DvirRecord
            if let dvirRecord = convertServerRecordToDvirRecord(serverRecord) {
                do {
                    let insert = dvirTable.insert(
                        UserID <- dvirRecord.UserID,
                        UserName <- dvirRecord.UserName,
                        startTime <- dvirRecord.startTime,
                        DAY <- dvirRecord.DAY,
                        Shift <- dvirRecord.Shift,
                        DvirTime <- dvirRecord.DvirTime,
                        odometer <- dvirRecord.odometer,
                        location <- dvirRecord.location,
                        truckDefect <- dvirRecord.truckDefect,
                        trailerDefect <- dvirRecord.trailerDefect,
                        vehicleCondition <- dvirRecord.vehicleCondition,
                        notes <- dvirRecord.notes,
                        vehicleName <- dvirRecord.vehicleName,
                        vechicleID <- dvirRecord.vechicleID,
                        Sync <- dvirRecord.Sync,
                        timestamp <- dvirRecord.timestamp,
                        Server_ID <- dvirRecord.Server_ID,
                        Trailer <- dvirRecord.Trailer,
                        Signature <- dvirRecord.signature
                    )
                    
                    try db.run(insert)
                    savedCount += 1
                    // print(" Saved server DVIR record with Server_ID: \(serverId)")
                } catch {
                    // print(" Error saving server DVIR record: \(error.localizedDescription)")
                }
            }
        }
        
        // print(" Server DVIR records saved: \(savedCount), skipped (duplicates): \(skippedCount)")
    }
    
    // MARK: - Convert Server DVIR JSON to DvirRecord
    private func convertServerRecordToDvirRecord(_ serverRecord: [String: Any]) -> DvirRecord? {
        // Extract dateTime and parse it
        let dateTimeString = serverRecord["dateTime"] as? String ?? ""
        
        // Extract driver info
        let driverId = serverRecord["driverId"] as? Int ?? 0
        let driverName = serverRecord["driverName"] as? String ?? ""
        
        // Extract vehicle info
        let vehicleId = serverRecord["vehicleId"] as? Int ?? 0
        let vehicleNo = serverRecord["vehicleNo"] as? String ?? ""
        
        // Extract defects (arrays)
        let truckDefectArray = serverRecord["truckDefect"] as? [String] ?? []
        let trailerDefectArray = serverRecord["trailerDefect"] as? [String] ?? []
        let trailerArray = serverRecord["trailer"] as? [String] ?? []
        
        // Convert arrays to comma-separated strings
        let truckDefect = truckDefectArray.joined(separator: ", ")
        let trailerDefect = trailerDefectArray.joined(separator: ", ")
        let trailer = trailerArray.joined(separator: ", ")
        
        // Extract other fields
        let location = serverRecord["location"] as? String ?? ""
        let notes = serverRecord["notes"] as? String ?? ""
        let vehicleCondition = serverRecord["vehicleCondition"] as? String ?? ""
        let odometer = serverRecord["odometer"] as? Double ?? 0.0
        let timestamp = serverRecord["timestamp"] as? String ?? "\(Int(Date().timeIntervalSince1970 * 1000))"
        let serverId = serverRecord["_id"] as? String ?? ""
        var imageData: Data? = nil
        Task {
            let driverSignFile = serverRecord["driverSignFile"] as? String ?? ""
            if let url = URL(string: driverSignFile),
                let data = try? await NetworkManager.shared.getImage(url) {
                imageData = data
            }
           
        }
        
        
        // Create DvirRecord
        let record = DvirRecord(
            id: nil, // Will be auto-generated by database
            UserID: "\(driverId)",
            UserName: driverName,
            startTime: dateTimeString.asDate() ?? Date(),
            DAY: AppStorageHandler.shared.days,
            Shift: AppStorageHandler.shared.shift, // Default shift
            DvirTime: "",
            odometer: odometer,
            location: location,
            truckDefect: truckDefect,
            trailerDefect: trailerDefect,
            vehicleCondition: vehicleCondition,
            notes: notes,
            vehicleName: vehicleNo,
            vechicleID: "\(vehicleId)",
            Sync: 1, // Mark as synced since it's from server
            timestamp: timestamp,
            Server_ID: serverId,
            Trailer: trailer,
            signature: imageData
        )
        
        return record
    }
    
    // MARK: - Parse DateTime String
    private func parseDateTime(_ dateTimeString: String) -> (day: String, time: String) {
        // Expected format: "2025-11-07 11:32:01"
        let components = dateTimeString.split(separator: " ")
        
        if components.count == 2 {
            let datePart = String(components[0]) // "2025-11-07"
            let timePart = String(components[1]) // "11:32:01"
            
            // Server sends date in "yyyy-MM-dd" format, which matches DateTimeHelper.currentDate() format
            // So we can use it directly
            return (datePart, timePart)
        }
        
        // Fallback to current date/time if parsing fails
        return (DateTimeHelper.currentDate(), DateTimeHelper.currentTime())
    }
    
    // MARK: - Static Helper to Save Server DVIR from Login Response
    // Call this function from login response handler with the driverDvirLog array
    static func saveServerDvirFromLoginResponse(_ loginResponse: [String: Any]) {
        // Extract result object
        guard let result = loginResponse["result"] as? [String: Any] else {
            // print(" No 'result' object found in login response")
            return
        }
        
        // Extract driverDvirLog array
        guard let driverDvirLog = result["driverDvirLog"] as? [[String: Any]], !driverDvirLog.isEmpty else {
            // print(" No 'driverDvirLog' found in login response or array is empty")
            return
        }
        
        // print(" Found \(driverDvirLog.count) server DVIR records in login response")
        
        // Save server DVIR records to database
        DvirDatabaseManager.shared.saveServerDvirRecords(from: driverDvirLog)
        
        // Post notification to refresh EmailDvir list
      //  NotificationCenter.default.post(name: NSNotification.Name("DVIRRecordUpdated"), object: nil)
        // print(" Posted DVIRRecordUpdated notification after saving server records")
    }
}
