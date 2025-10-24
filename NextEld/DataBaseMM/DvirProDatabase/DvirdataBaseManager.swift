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



class DvirDatabaseManager {
    static let shared = DvirDatabaseManager()
    
    private var db: Connection?
    private let dvirTable = Table("dvir_records")
    private let id = Expression<Int64>("id")
    private let UserID = Expression<String>("UserID")
    private let UserName = Expression<String>("UserName")
    private let startTime = Expression<String>("startTime")
    private let DAY = Expression<String>("DAY")
    private let Shift = Expression<String>("Shift")
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
        let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileUrl = documentDirectory.appendingPathComponent("dvir.sqlite3")
        db = try? Connection(fileUrl.path)
    }
    
    private func createTable() {
        do {
            try db?.run(dvirTable.create(ifNotExists: true) { table in
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
            print(" DVIR table created successfully (if not already present).")
        } catch {
            print(" Error creating DVIR table: \(error)")
        }
    }


    func insertRecord(_ record: DvirRecord) {
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
            
            let rowId = try db?.run(insert)
            print(" DVIR record inserted with ID: \(rowId ?? -1)")
            if let dataSize = record.signature?.count {
                print(" Trailer data size: \(dataSize) bytes")
            }
        } catch {
            print(" Database insert error: \(error)")
        }
    }

    
    func fetchAllRecords() -> [DvirRecord] {
        var records: [DvirRecord] = []
        do {
            if let rows = try db?.prepare(dvirTable) {
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
            }
        } catch {
            print(" Database fetch error: \(error)")
        }
        return records
    }

    //MARK: -  Fetch today's last log
    func fetchTodaysLastLog() -> DvirRecord? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let today = formatter.string(from: Date())
        
        // Filter today's records and order by DvirTime descending
        let query = dvirTable.filter(DAY == today).order(DvirTime.desc)
        
        do {
            if let row = try db?.pluck(query) {
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
            print("Error fetching today's last DVIR log: \(error)")
        }
        
        return nil
    }

 
}

extension DvirDatabaseManager {
    
    // MARK: - Fetch Record for a Specific Date
    func fetchRecord(for dayValue: String) -> DvirRecord? {
        do {
            let query = dvirTable.filter(DAY == dayValue)
            if let row = try db?.pluck(query) {
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
            print(" Database fetch error: \(error)")
        }
        return nil
    }
    
    
    // MARK: - Update Record by ID
    func updateRecord(_ record: DvirRecord) {
        guard let recordId = record.id else { return }
        let query = dvirTable.filter(id == recordId)
        
        do {
            try db?.run(query.update(
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
            print(" DVIR record updated with ID: \(recordId)")
        } catch {
            print(" Database update error: \(error)")
        }
    }
    
    

    
    // MARK: - Update Record by User + Date (Alternative Update)
    func updateRecord(_ record: DvirRecord, userID: String, day: String) {
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
            print(" DVIR record updated for UserID: \(userID) on \(day)")
        } catch {
            print(" Error updating DVIR record: \(error)")
        }
    }
    
    
    
    //MARK: -  Checking  information same day, shift
    func hasDvirFor(day: String, shift: String) -> Bool {
        do {
            guard let db = db else { return false }
            
            // Filter where both DAY and Shift match exactly
            let query = dvirTable.filter(self.DAY == day && self.Shift == shift)
            
            // Count how many rows match this condition
            let count = try db.scalar(query.count)
            
            // If one or more records found → return true (already exists)
            return count > 0
        } catch {
            print("Error checking DVIR for day \(day) & shift \(shift): \(error)")
            return false
        }
    }

    
    // MARK: - Delete All Records
    func deleteAllRecordsForDvirDataBase() {
        do {
            let deletedCount = try db?.run(dvirTable.delete()) ?? 0
            print(" Deleted all DVIR records (\(deletedCount) rows removed)")
        } catch {
            print(" Error deleting all DVIR records: \(error)")
        }
    }
}
