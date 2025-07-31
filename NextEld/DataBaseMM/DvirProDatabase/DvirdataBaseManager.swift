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
    private let odometer = Expression<String>("odometer")
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
                odometer <- record.odometer,
                company <- record.company,
                location <- record.location,
                vehicle <- record.vehicle,
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
                        odometer: row[odometer],
                        company: row[company],
                        location: row[location],
                        vehicle: row[vehicle],
                        trailer: row[trailer],
                        truckDefect: row[truckDefect],
                        trailerDefect: row[trailerDefect],
                        vehicleCondition: row[vehicleCondition],
                        notes: row[notes],
                        signature: row[signature] // fetch image
                    ))
                }
            }
            return records
        }
        
    
    
}




















