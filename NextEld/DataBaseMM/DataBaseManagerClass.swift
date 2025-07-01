//
//  DataBaseManagerClass.swift
//  NextEld
//
//  Created by Priyanshi   on 26/06/25.
//

import Foundation
import SQLite3
import SQLite

class DatabaseManager {
    static let shared = DatabaseManager()

    private var db: Connection?

    // MARK: - Table and Columns
    let driverLogs = Table("driverLogs")
    let id = Expression<Int64>("id") // Auto-increment
    let status = Expression<String>("status")
    let startTime = Expression<String>("startTime")
    let userId = Expression<Int>("userId")
    let day = Expression<Int>("day")
    let isVoilation = Expression<Int>("isVoilation")
    let dutyType = Expression<String>("dutyType")
    let shift = Expression<Int>("shift")
    let vehicleName = Expression<String>("vehicleName") // instead of vehicle
    let odometer = Expression<Double>("odometer")
    let engineHours = Expression<String>("engineHours")
    let location = Expression<String>("location")
    let lat = Expression<Double>("lat")
    let long = Expression<Double>("long")
    let origin = Expression<String>("origin")
    let isSynced = Expression<Bool>("isSynced")
    let vehicleId = Expression<Int>("vehicleId")
    let trailers = Expression<String>("trailers")
    let notes = Expression<String>("notes")
    let serverId = Expression<String?>("serverId")
    let timestamp = Expression<Int64>("timestamp")
    let identifier = Expression<Int>("identifier")
    let remainingWeeklyTime = Expression<String>("remainingWeeklyTime")
    let remainingDriveTime = Expression<String>("remainingDriveTime")
    let remainingDutyTime = Expression<String>("remainingDutyTime")
    let remainingSleepTime = Expression<String>("remainingSleepTime")
    let lastSleepTime = Expression<String>("lastSleepTime")
    let isSplit = Expression<Int>("isSplit")
    let engineStatus = Expression<String>("engineStatus")

    private init() {
        do {
            let docDir = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let path = docDir.appendingPathComponent("local.db").path
            db = try Connection(path)
            print("📁 SQLite DB path: \(path)")

            createTable()
        } catch {
            print("❌ DB Init Error: \(error)")
        }
    }

    private func createTable() {
        do {
            try db?.run(driverLogs.create(ifNotExists: true) { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(status)
                t.column(startTime)
                t.column(userId)
                t.column(day)
                t.column(isVoilation)
                t.column(dutyType)
                t.column(shift)
                t.column(vehicleName)
                t.column(odometer)
                t.column(engineHours)
                t.column(location)
                t.column(lat)
                t.column(long)
                t.column(origin)
                t.column(isSynced)
                t.column(vehicleId)
                t.column(trailers)
                t.column(notes)
                t.column(serverId)
                t.column(timestamp)
                t.column(identifier)
                t.column(remainingWeeklyTime)
                t.column(remainingDriveTime)
                t.column(remainingDutyTime)
                t.column(remainingSleepTime)
                t.column(lastSleepTime)
                t.column(isSplit)
                t.column(engineStatus)
            })
        } catch {
            print("❌ Table Create Error: \(error)")
        }
    }


    func fetchLogs() -> [DriverLogModel] {
        var logs: [DriverLogModel] = []
        do {
            for row in try db!.prepare(driverLogs) {
                logs.append(DriverLogModel(
                    status: row[status],
                    startTime: row[startTime],
                    userId: row[userId],
                    day: row[day],
                    isVoilation: row[isVoilation],
                    dutyType: row[dutyType],
                    shift: row[shift],
                    vehicle: row[vehicleName] ,
                    odometer: row[odometer],
                    engineHours: row[engineHours],
                    location: row[location],
                    lat: row[lat],
                    long: row[long],
                    origin: row[origin],
                    isSynced: row[isSynced],
                    vehicleId: row[vehicleId],
                    trailers: row[trailers],
                    notes: row[notes],
                    serverId: row[serverId],
                    timestamp: row[timestamp],
                    identifier: row[identifier],
                    remainingWeeklyTime: row[remainingWeeklyTime],
                    remainingDriveTime: row[remainingDriveTime],
                    remainingDutyTime: row[remainingDutyTime],
                    remainingSleepTime: row[remainingSleepTime],
                    lastSleepTime: row[lastSleepTime],
                    isSplit: row[isSplit],
                    engineStatus: row[engineStatus]
                ))
            }
        } catch {
            print("❌ Fetch Error: \(error)")
        }
        return logs
    }

    
    func saveDriverLogsToSQLite(from logs: [DriverLog]) {
        print("💾 Saving \(logs.count) logs into SQLite")

        for (index, log) in logs.enumerated() {
            let model = DriverLogModel(
                status: log.status ?? "Unknown",
                startTime: log.dateTime ?? "N/A",
                userId: log.driverId ?? 0,
                day: log.days ?? 0,
                isVoilation: log.isVoilation ?? 0,
                dutyType: log.logType ?? "log",
                shift: log.shift ?? 0,
                vehicle: log.truckNo ?? "",
                odometer: log.odometer ?? 0.0,
                engineHours: log.engineHour ?? "0",
                location: log.customLocation ?? "",
                lat: log.lattitude ?? 0.0,
                long: log.longitude ?? 0.0,
                origin: log.origin ?? "Driver",
                isSynced: false,
                vehicleId: log.vehicleId ?? 0,
                trailers: (log.trailers ?? []).joined(separator: ", "),
                notes: log.note ?? "",
                serverId: log._id,
                timestamp: Int64(log.dateTime ?? "0") ?? 0, // Convert dateTime string to Int64
                identifier: log.identifier ?? 0,
                remainingWeeklyTime: log.remainingWeeklyTime ?? "0",
                remainingDriveTime: log.remainingDriveTime ?? "0",
                remainingDutyTime: log.remainingDutyTime ?? "0",
                remainingSleepTime: log.remainingSleepTime ?? "0",
                lastSleepTime: log.lastOnSleepTime ?? "0",
                isSplit: 0, // Not present in DriverLog — defaulted
                engineStatus: "Off" // Not present in DriverLog — defaulted
            )

            print("📝 Saving log #\(index + 1): \(model.status), \(model.startTime)")
            insertLog(from: model)
        }

        print("✅ Finished saving logs.")
    }

    
    func insertLog(from model: DriverLogModel) {
        do {
            let insert = driverLogs.insert(
                status <- model.status,
                startTime <- model.startTime,
                userId <- model.userId,
                day <- model.day,
                isVoilation <- model.isVoilation,
                dutyType <- model.dutyType,
                shift <- model.shift,
                vehicleName <- model.vehicle, // ✅ Ensure this matches column
                odometer <- model.odometer,
                engineHours <- model.engineHours,
                location <- model.location,
                lat <- model.lat,
                long <- model.long,
                origin <- model.origin,
                isSynced <- model.isSynced,
                vehicleId <- model.vehicleId,
                trailers <- model.trailers,
                notes <- model.notes,
                serverId <- model.serverId,
                timestamp <- model.timestamp,
                identifier <- model.identifier,
                remainingWeeklyTime <- model.remainingWeeklyTime,
                remainingDriveTime <- model.remainingDriveTime,
                remainingDutyTime <- model.remainingDutyTime,
                remainingSleepTime <- model.remainingSleepTime,
                lastSleepTime <- model.lastSleepTime,
                isSplit <- model.isSplit,
                engineStatus <- model.engineStatus
            )

            try db?.run(insert)
            print("✅ Log inserted into SQLite: \(model.status) at \(model.startTime)")
        } catch {
            print("❌ Insert Log Error: \(error.localizedDescription)")
        }
    }



}



//MARK: -  DriverLogModel for DataBase struct DriverLogModel: Identifiable {
struct DriverLogModel: Identifiable {
    var id = UUID()

    let status: String
    let startTime: String
    let userId: Int
    let day: Int
    let isVoilation: Int
    let dutyType: String
    let shift: Int
    let vehicle: String
    let odometer: Double
    let engineHours: String
    let location: String
    let lat: Double
    let long: Double
    let origin: String
    let isSynced: Bool
    let vehicleId: Int
    let trailers: String
    let notes: String
    let serverId: String?
    let timestamp: Int64
    let identifier: Int
    let remainingWeeklyTime: String
    let remainingDriveTime: String
    let remainingDutyTime: String
    let remainingSleepTime: String
    let lastSleepTime: String
    let isSplit: Int
    let engineStatus: String
}

