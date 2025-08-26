//
//  certifydatabase.swift
//  NextEld
//
//  Created by priyanshi   on 13/08/25.
//

import Foundation
import SQLite

class CertifyDatabaseManager {
    static let shared = CertifyDatabaseManager()
    
    private var db: Connection?
    private let certifyTable = Table("certify_records")
    private let id = Expression<Int64>("id")
    private let userID = Expression<String>("userID")
    private let userName = Expression<String>("userName")
    private let startTime = Expression<String>("startTime")
    private let date = Expression<String>("date")
    private let shift = Expression<String>("shift")
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
                table.column(startTime)
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
            print("Error creating Certify table: \(error)")
        }
        do {
            try db?.run(certifyTable.addColumn(isLogcertified, defaultValue: "No"))
            print("Column isLogCertified added successfully ")
        } catch {
            print("Column may already exist: \(error)")
        }

    }
    
    

    func insertRecord(_ record: CertifyRecord) {
        do {
            let insert = certifyTable.insert(
                userID <- record.userID,
                userName <- record.userName,
                startTime <- record.startTime,
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
            print("@@@@@@@@@@@@ Certify record inserted with ID: \(rowId ?? -1)")
        } catch {
            print("@@@@@@@@@@@@@@@ Error inserting Certify record: \(error)")
        }
    }

    func fetchAllRecords() -> [CertifyRecord] {
        var records: [CertifyRecord] = []
        
        do {
            if let rows = try db?.prepare(certifyTable) {
                for row in rows {
                    records.append(CertifyRecord(
                        userID: row[userID],
                        userName: row[userName],
                        startTime: row[startTime],
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
            print("Error fetching all records: \(error)")
        }
        
        return records
    }


//MARK: -  For Update Records
    func saveRecord(_ record: CertifyRecord) {
        do {
            // Check if record exists for the same date
            let query = certifyTable.filter(date == record.date)
            if let existing = try db?.pluck(query) {
                // If exists → update it
                try db?.run(query.update(
                    userID <- record.userID,
                    userName <- record.userName,
                    startTime <- record.startTime,
                    shift <- record.shift,
                    selectedVehicle <- record.selectedVehicle,
                    selectedTrailer <- record.selectedTrailer,
                    selectedShippingDoc <- record.selectedShippingDoc,
                    selectedCoDriver <- record.selectedCoDriver,
                    vehicleID <- record.vehicleID,
                    coDriverID <- record.coDriverID,
                    isSynced <- record.syncStatus,
                    isLogcertified <- record.isCertify
                ))
                print("@@@@@ Record updated successfully for date \(record.date)")
            } else {
                // If not exists → insert new
                
                let insert = certifyTable.insert(
                    userID <- record.userID,
                    userName <- record.userName,
                    startTime <- record.startTime,
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
                print("@@@@@@@@@@@@ Certify record inserted with ID: \(rowId ?? -1)")
            }
        } catch {
            print("Error saving record: \(error)")
        }
    }

    func updateCertifyStatus(for date: String, isCertify: String, syncStatus: Int) {
        do {
            let query = certifyTable.filter(self.date == date)
            try db?.run(query.update(
                self.isLogcertified <- isCertify,
                self.isSynced <- syncStatus
            ))
            print("DB updated for \(date): isCertify=\(isCertify), syncStatus=\(syncStatus)")
        } catch {
            print("Failed to update certify status: \(error)")
        }
    }

    
    //MARK: -  Delete all records from db

    func deleteAllRecords() {
        do {
            try db?.run(certifyTable.delete())
            print("##### All certify records deleted successfully!")
        } catch {
            print("Error deleting all certify records: \(error)")
        }
    }
    
    func markCertified(for date: String) {
        do {
            let record = certifyTable.filter(self.date == date)
            try db?.run(record.update(self.isLogcertified <- "Yes"))
            print("Updated certification for date \(date)")
        } catch {
            print(" Failed to update certify flag: \(error)")
        }
    
        
        let all = CertifyDatabaseManager.shared.fetchAllRecords()
        print(" After update DB records: \(all)")
    }




}
