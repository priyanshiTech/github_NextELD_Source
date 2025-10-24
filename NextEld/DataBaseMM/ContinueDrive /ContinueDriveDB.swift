//
//  ContinueDriveDB.swift
//  NextEld
//
//  Created by priyanshi on 30/09/25.
//

import Foundation
import SQLite3
import SQLite
import SwiftUI

// MARK: - Continue Drive Model
struct ContinueDriveModel: Identifiable {
    let id: Int64?
    let userId: Int
    let status: String
    let startTime: String
    let endTime: String
    let breakTime: String
}

// MARK: - Continue Drive Database Manager
class ContinueDriveDBManager {
    static let shared = ContinueDriveDBManager()
    
    private var db: Connection?
    
    // MARK: - Table and Columns
    let continueDriveTable = Table("continueDriveLogs")
    let id = Expression<Int64>("id")
    let userId = Expression<Int>("userId")
    let status = Expression<String>("status")
    let startTime = Expression<String>("startTime")
    let endTime = Expression<String>("endTime")
    let breakTime = Expression<String>("breakTime")
    
    private init() {
        do {
            let docDir = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            let path = docDir.appendingPathComponent("local.db").path
            db = try Connection(path)
            print(" Continue Drive SQLite DB path: \(path)")
            
            createTable()
        } catch {
            print(" Continue Drive DB Init Error: \(error)")
        }
    }
    
    // MARK: - Create Table
    func createTable() {
        do {
            try db?.run(continueDriveTable.create(ifNotExists: true) { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(userId)
                t.column(status)
                t.column(startTime)
                t.column(endTime)
                t.column(breakTime)
            })
            print(" Continue Drive table created successfully")
        } catch {
            print(" Continue Drive Table Create Error: \(error)")
        }
    }
    
    // MARK: - Save Continue Drive Data
    func saveContinueDriveData(
        userId: Int,
        status: String,
        startTime: String,
        endTime: String,
        breakTime: String
    ) {
        guard let db = db else {
            print(" Database connection not available")
            return
        }
        
        do {
            let insert = continueDriveTable.insert(
                self.userId <- userId,
                self.status <- status,
                self.startTime <- startTime,
                self.endTime <- endTime,
                self.breakTime <- breakTime
            )
            
            let rowID = try db.run(insert)
            print(" Continue Drive data inserted with ID: \(rowID)")
            print(" Status: \(status), Start: \(startTime), End: \(endTime), Break: \(breakTime)")
            
        } catch {
            print(" Insert Continue Drive Data Error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Fetch All Continue Drive Data
    func fetchAllContinueDriveData() -> [ContinueDriveModel] {
        var data: [ContinueDriveModel] = []
        
        guard let db = db else {
            print(" Database connection not available")
            return data
        }
        
        do {
            for row in try db.prepare(continueDriveTable.order(id.desc)) {
                data.append(ContinueDriveModel(
                    id: row[id],
                    userId: row[userId],
                    status: row[status],
                    startTime: row[startTime],
                    endTime: row[endTime],
                    breakTime: row[breakTime]
                ))
            }
        } catch {
            print(" Fetch Continue Drive Data Error: \(error)")
        }
        
        return data
    }
    
    // MARK: - Fetch Latest Continue Drive Data
    func fetchLatestContinueDriveData() -> ContinueDriveModel? {
        guard let db = db else {
            print(" Database connection not available")
            return nil
        }
        
        do {
            if let row = try db.pluck(continueDriveTable.order(id.desc).limit(1)) {
                return ContinueDriveModel(
                    id: row[id],
                    userId: row[userId],
                    status: row[status],
                    startTime: row[startTime],
                    endTime: row[endTime],
                    breakTime: row[breakTime]
                )
            }
        } catch {
            print(" Fetch Latest Continue Drive Data Error: \(error)")
        }
        
        return nil
    }
    
    // MARK: - Update Continue Drive Data
    func updateContinueDriveData(
        id: Int64,
        status: String? = nil,
        startTime: String? = nil,
        endTime: String? = nil,
        breakTime: String? = nil
    ) {
        guard let db = db else {
            print(" Database connection not available")
            return
        }
        
        do {
            let record = continueDriveTable.filter(self.id == id)
            
            if let status = status {
                try db.run(record.update(self.status <- status))
            }
            if let startTime = startTime {
                try db.run(record.update(self.startTime <- startTime))
            }
            if let endTime = endTime {
                try db.run(record.update(self.endTime <- endTime))
            }
            if let breakTime = breakTime {
                try db.run(record.update(self.breakTime <- breakTime))
            }
            
            print(" Continue Drive data updated for ID: \(id)")
            
        } catch {
            print(" Update Continue Drive Data Error: \(error)")
        }
    }
    
    func deleteAllContinueDriveData() {
        guard let db = db else {
            print(" Database connection not available")
            return
        }
        do {
            try db.run(continueDriveTable.delete())
            print(" All Continue Drive data deleted")
        } catch {
            print(" Delete All Continue Drive Data Error: \(error)")
        }
    }
    // MARK: - Update Latest Continue Drive Data
    func updateLatestContinueDriveData(
        status: String? = nil,
        startTime: String? = nil,
        endTime: String? = nil,
        breakTime: String? = nil
    ) {
        guard let db = db else {
            print(" Database connection not available")
            return
        }
        
        do {
            let record = continueDriveTable.order(id.desc).limit(1)
            
            if let status = status {
                try db.run(record.update(self.status <- status))
            }
            if let startTime = startTime {
                try db.run(record.update(self.startTime <- startTime))
            }
            if let endTime = endTime {
                try db.run(record.update(self.endTime <- endTime))
            }
            if let breakTime = breakTime {
                try db.run(record.update(self.breakTime <- breakTime))
            }
            
            print(" Latest Continue Drive data updated")
            
        } catch {
            print(" Update Latest Continue Drive Data Error: \(error)")
        }
    }
    
    // MARK: - Update Continue Drive Data by User ID
    func updateContinueDriveDataByUserId(
        userId: Int,
        status: String? = nil,
        startTime: String? = nil,
        endTime: String? = nil,
        breakTime: String? = nil
    ) {
        guard let db = db else {
            print(" Database connection not available")
            return
        }
        
        do {
            let record = continueDriveTable.filter(self.userId == userId)
            
            if let status = status {
                try db.run(record.update(self.status <- status))
            }
            if let startTime = startTime {
                try db.run(record.update(self.startTime <- startTime))
            }
            if let endTime = endTime {
                try db.run(record.update(self.endTime <- endTime))
            }
            if let breakTime = breakTime {
                try db.run(record.update(self.breakTime <- breakTime))
            }
            
            print(" Continue Drive data updated for User ID: \(userId)")
            
        } catch {
            print(" Update Continue Drive Data by User ID Error: \(error)")
        }
    }
    
    // MARK: - Update Complete Continue Drive Record
    func updateCompleteContinueDriveRecord(
        id: Int64,
        userId: Int,
        status: String,
        startTime: String,
        endTime: String,
        breakTime: String
    ) {
        guard let db = db else {
            print(" Database connection not available")
            return
        }
        
        do {
            let record = continueDriveTable.filter(self.id == id)
            
            try db.run(record.update(
                self.userId <- userId,
                self.status <- status,
                self.startTime <- startTime,
                self.endTime <- endTime,
                self.breakTime <- breakTime
            ))
            
            print(" Complete Continue Drive record updated for ID: \(id)")
            
        } catch {
            print(" Update Complete Continue Drive Record Error: \(error)")
        }
    }
}

// MARK: - Continue Drive View Model
class ContinueDriveViewModel: ObservableObject {
    @Published var continueDriveData: [ContinueDriveModel] = []
    @Published var isLoading = false
    
    func loadContinueDriveData() {
        isLoading = true
        continueDriveData = ContinueDriveDBManager.shared.fetchAllContinueDriveData()
        isLoading = false
        print(" Loaded \(continueDriveData.count) continue drive records")
    }
    
    func saveContinueDriveData(
        userId: Int,
        status: String,
        startTime: String,
        endTime: String,
        breakTime: String
    ) {
        ContinueDriveDBManager.shared.saveContinueDriveData(
            userId: userId,
            status: status,
            startTime: startTime,
            endTime: endTime,
            breakTime: breakTime
        )
        
        loadContinueDriveData()
    }
    
    func updateContinueDriveData(
        id: Int64,
        status: String? = nil,
        startTime: String? = nil,
        endTime: String? = nil,
        breakTime: String? = nil
    ) {
        ContinueDriveDBManager.shared.updateContinueDriveData(
            id: id,
            status: status,
            startTime: startTime,
            endTime: endTime,
            breakTime: breakTime
        )
        
        loadContinueDriveData()
    }
    

    
    func updateContinueDriveDataByUserId(
        userId: Int,
        status: String? = nil,
        startTime: String? = nil,
        endTime: String? = nil,
        breakTime: String? = nil
    ) {
        ContinueDriveDBManager.shared.updateContinueDriveDataByUserId(
            userId: userId,
            status: status,
            startTime: startTime,
            endTime: endTime,
            breakTime: breakTime
        )
        
        loadContinueDriveData()
    }

    
    func deleteAllContinueDriveData() {
        ContinueDriveDBManager.shared.deleteAllContinueDriveData()
        loadContinueDriveData()
    }
}




