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
    private let driver = Expression<String>("driver")
    private let time = Expression<String>("time")
    private let date = Expression<String>("date")
    private let odometer = Expression<Double?>("odometer")
    private let company = Expression<String>("company")
    private let location = Expression<String>("location")
    private let vehicle = Expression<String>("vehicle")
    private let trailer = Expression<String>("trailer")
    private let truckDefect = Expression<String>("truckDefect")
    private let trailerDefect = Expression<String>("trailerDefect")
    private let vehicleCondition = Expression<String>("vehicleCondition")
    private let notes = Expression<String>("notes")
    private let signature = Expression<Data?>("signature") //  define image column
    
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
        try? db?.run(dvirTable.create(ifNotExists: true) { table in
            table.column(id, primaryKey: .autoincrement)
            table.column(driver)
            table.column(time)
            table.column(date)
            table.column(odometer)
            table.column(company)
            table.column(location)
            table.column(vehicle)
            table.column(trailer)
            table.column(truckDefect)
            table.column(trailerDefect)
            table.column(vehicleCondition)
            table.column(notes)
            table.column(signature) // image column in main table
        })
    }
    

    func insertRecord(_ record: DvirRecord) {
        do {
            let insert = dvirTable.insert(
                driver <- record.driver,
                time <- record.time,
                date <- record.date,
                odometer <- record.odometer ?? 0.0,
                company <- record.company,
                location <- record.location,
                vehicle <- record.vehicleID,
                trailer <- record.trailer,
                truckDefect <- record.truckDefect,
                trailerDefect <- record.trailerDefect,
                vehicleCondition <- record.vehicleCondition,
                notes <- record.notes,
                signature <- record.signature
            )
            
            let rowId = try db?.run(insert)
            print(" Record inserted with ID: \(rowId ?? -1)")
            print(" Signature data size: \(record.signature?.count ?? 0) bytes")
        } catch {
            print(" Database insert error: \(error)")
        }
    }
    
    
        func fetchAllRecords() -> [DvirRecord] {
            var records: [DvirRecord] = []
            if let rows = try? db?.prepare(dvirTable) {
                for row in rows {
                    records.append(DvirRecord(
                        id: row[id],
                        driver: row[driver],
                        time: row[time],
                        date: row[date],
                        odometer: row[odometer] ?? 0.0,
                        company: row[company],
                        location: row[location],
                        vehicleID: row[vehicle],
                        trailer: row[trailer],
                        truckDefect: row[truckDefect],
                        trailerDefect: row[trailerDefect],
                        vehicleCondition: row[vehicleCondition],
                        notes: row[notes], engineHour: 0,
                        signature: row[signature] // fetch image
                    ))
                }
            }
            return records
        }
 
}

extension DvirDatabaseManager {
    
    //  Fetch record for a specific date
    func fetchRecord(for dateValue: String) -> DvirRecord? {
        do {
            let query = dvirTable.filter(date == dateValue)
            if let row = try db?.pluck(query) {
                return DvirRecord(
                    id: row[id],
                    driver: row[driver],
                    time: row[time],
                    date: row[date],
                    odometer: row[odometer] ?? 0.0,
                    company: row[company],
                    location: row[location],
                    vehicleID: row[vehicle],
                    trailer: row[trailer],
                    truckDefect: row[truckDefect],
                    trailerDefect: row[trailerDefect],
                    vehicleCondition: row[vehicleCondition],
                    notes: row[notes], engineHour: 0,
                    signature: row[signature]
                )
            }
        } catch {
            print("Database fetch error: \(error)")
        }
        return nil
    }
    
    //  Update existing record by ID
    func updateRecord(_ record: DvirRecord) {
        guard let recordId = record.id else { return }
        let query = dvirTable.filter(id == recordId)
        
        do {
            try db?.run(query.update(
                driver <- record.driver,
                time <- record.time,
                date <- record.date,
                odometer <- record.odometer,
                company <- record.company,
                location <- record.location,
                vehicle <- record.vehicleID,
                trailer <- record.trailer,
                truckDefect <- record.truckDefect,
                trailerDefect <- record.trailerDefect,
                vehicleCondition <- record.vehicleCondition,
                notes <- record.notes,
                signature <- record.signature
            ))
            print(" Record updated with ID: \(recordId)")
        } catch {
            print("Database update error: \(error)")
        }
    }
    
    func recordExists(driver: String, date: String) -> Bool {
            do {
                guard let db = db else { return false }
                let query = dvirTable.filter(self.driver == driver && self.date == date)
                let count = try db.scalar(query.count)
                return count > 0
            } catch {
                print("Error checking record existence: \(error)")
                return false
            }
        }
    





    // Update existing DVIR record (replace signature + details)
    func updateRecord(_ record: DvirRecord, driver: String, date: String) {
        do {
            guard let db = db else { return }
            let row = dvirTable.filter(self.driver == driver && self.date == date)
            try db.run(row.update(
                self.time <- record.time,
                self.vehicle <- record.vehicleID,
                self.trailer <- record.trailer,
                self.truckDefect <- record.truckDefect,
                self.trailerDefect <- record.trailerDefect,
                self.vehicleCondition <- record.vehicleCondition,
                self.notes <- record.notes,
                self.signature <- record.signature
            ))
            print("DVIR record updated for \(driver) at \(date)")
        } catch {
            print("Error updating DVIR: \(error)")
        }
    }
}


























