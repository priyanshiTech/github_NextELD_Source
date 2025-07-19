//
//  DataBaseManagerClass.swift
//  NextEld
//
//  Created by Priyanshi   on 26/06/25.
//

import Foundation
import SQLite3
import SQLite
import Foundation

struct DutyLog {
    let id: Int
    let status: String         // "ON_DUTY", "DRIVE", "SLEEP", "OFF_DUTY"
    let startTime: Date
    let endTime: Date
}

class DatabaseManager {
    static let shared = DatabaseManager()

    private var db: Connection?

    // MARK: - Table and Columns
    let driverLogs = Table("driverLogs")
    let id = Expression<Int64>("id")
    let status = Expression<String>("status")
    let startTime = Expression<String>("startTime")
    let userId = Expression<Int>("userId")
    let day = Expression<Int>("day")
    let isVoilationColumn = Expression<Int>("isVoilation")
    let dutyType = Expression<String>("dutyType")
    let shift = Expression<Int>("shift")
    let vehicleName = Expression<String>("vehicleName") //instead of vehicle
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
            print("*__________ SQLite DB path: \(path)")

            createTable()
        } catch {
            print("******DB Init Error: \(error)")
        }
    }

   func createTable() {
        do {
            try db?.run(driverLogs.create(ifNotExists: true) { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(status)
                t.column(startTime)
                t.column(userId)
                t.column(day)
                t.column(isVoilationColumn)
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
            print("****** Table Create Error: \(error)")
        }
    }



    func fetchLogs() -> [DriverLogModel] {
        var logs: [DriverLogModel] = []
        do {
            for row in try db!.prepare(driverLogs) {
                logs.append(DriverLogModel(
                    id: row[id],
                    status: row[status],
                    startTime: row[startTime],
                    userId: row[userId],
                    day: row[day],
                    isVoilations: (try? row.get(isVoilationColumn)) ?? 0,


                    dutyType: row[dutyType],
                    shift: row[shift],
                    vehicle: row[vehicleName] ,
                    isRunning: true,
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
            print("Erooorrrooororor-------------- Fetch Error: \(error)")
        }
        return logs
    }

    
    func saveDriverLogsToSQLite(from logs: [DriverLog]) {
        print("Correct!!!!!!!!!!!!!!!! Saving \(logs.count) logs into SQLite")

        for (index, log) in logs.enumerated() {
            let model = DriverLogModel(
                id: nil,
                status: log.status ?? "Unknown",
                startTime: log.dateTime ?? "N/A",
                userId: log.driverId ?? 0,
                day: log.days ?? 0,
                isVoilations: log.isVoilation ?? 1,
                dutyType: log.logType ?? "log",
                shift: log.shift ?? 0,
                vehicle: log.truckNo ?? "",
                isRunning: true,
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
                timestamp: Int64(log.dateTime ?? "0") ?? 0,
                identifier: log.identifier ?? 0,
                remainingWeeklyTime: log.remainingWeeklyTime ?? "0",
                remainingDriveTime: log.remainingDriveTime ?? "0",
                remainingDutyTime: log.remainingDutyTime ?? "0",
                remainingSleepTime: log.remainingSleepTime ?? "0",
                lastSleepTime: log.lastOnSleepTime ?? "0",
                isSplit: 0,
                engineStatus: "Off"
            )

            print(" Saving log #\(index + 1): \(model.status), \(model.startTime)")
            print("isVoilation before insert:", model.isVoilations)

            insertLog(from: model)
        }

        print("Finished saving logs.")
       

    }

    func insertLog(from model: DriverLogModel)

    {
            do {
                let insert = driverLogs.insert(
                    status <- model.status,
                    startTime <- model.startTime,
                    userId <- model.userId,
                    day <- model.day,
                    isVoilationColumn <- model.isVoilations,
                    dutyType <- model.dutyType,
                    shift <- model.shift,
                    vehicleName <- model.vehicle,
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
                    remainingWeeklyTime <- model.remainingWeeklyTime ?? "NA",
                    remainingDriveTime <- model.remainingDriveTime ?? "NA",
                    remainingDutyTime <- model.remainingDutyTime ?? "NA",
                    remainingSleepTime <- model.remainingSleepTime ?? "NA",
                    lastSleepTime <- model.lastSleepTime,
                    isSplit <- model.isSplit,
                    engineStatus <- model.engineStatus
                )

                // Run insert and capture the auto-incremented ID
                let rowID = try db?.run(insert) ?? 0
                print(" Log inserted into SQLite with ID: \(rowID) — \(model.status) at \(model.startTime)")

            } catch {
                print(" Insert Log Error: \(error.localizedDescription)")
            }
        
      

        }
    
    //MARK: -  TO DELETE ALL SAVED DATA IN DBMS


    func deleteAllLogs() {
        let driverLogs = Table("DriverLogs")
        do {
            try db?.run(driverLogs.delete())
            print("All logs deleted successfully")
        } catch {
            print("Error deleting logs: \(error)")
        }
    }


    
    func fetchDutyEventsForToday() -> [DutyLog] {
        var logs: [DutyLog] = []

        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        do {
            guard let db = self.db else { return [] }

            // No filter here because startTime is stored as string; filter manually after parsing
            for row in try db.prepare(driverLogs) {
                let idValue = Int(row[id])
                let statusValue = row[status]
                let startString = row[startTime]
                let endString = row[startTime]
                print(endString)

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 19800) // IST = GMT+5:30


                if let startDate = dateFormatter.date(from: startString) {
                    // Use timestamp or calculate +2 hours if no end field
                    let endDate = startDate.addingTimeInterval(00 * 60 * 60) // assume 2 hr default
                    
                 

                    // Only use logs from today
                    if startDate >= startOfDay && startDate < endOfDay {
                        let log = DutyLog(id: idValue, status: statusValue, startTime: startDate, endTime: endDate)
                        logs.append(log)
                    }
                }
            }
        } catch {
            print("Failed to fetch duty logs: \(error)")
        }

        return logs
    }

    
    
}

//MARK: -  to save a  Each timer funcationality in DataBase Management
extension DatabaseManager {
    func saveTimerLog(
        status: String,
        startTime: String,
        remainingWeeklyTime: String,
        remainingDriveTime: String,
        remainingDutyTime: String,
        remainingSleepTime: String,
        lastSleepTime: String,
        isruning: Bool,
        isVoilations: Bool = true
    ) {
        
        
        
        
        let log = DriverLogModel(
            id: nil,
            status: status,
            startTime: startTime,
            userId: UserDefaults.standard.integer(forKey: "userId"),
            day:  UserDefaults.standard.integer(forKey: "day"),
            isVoilations: UserDefaults.standard.integer(forKey: "isVoilation"),
            dutyType: UserDefaults.standard.string(forKey: "logType") ?? "Null",
            shift: UserDefaults.standard.integer(forKey: "shift"),
            vehicle:UserDefaults.standard.string(forKey: "truckNo") ?? "Null",
            isRunning: true,
            odometer: 0.0,
            engineHours: "0",
            location:  UserDefaults.standard.string( forKey: "customLocation") ?? "",
            lat: Double(UserDefaults.standard.string(forKey: "lattitude") ?? "") ?? 0,
            long: Double(UserDefaults.standard.string(forKey: "longitude") ?? "") ?? 0,
            origin: UserDefaults.standard.string(forKey: "origin") ?? "Null",
            isSynced: false,
            vehicleId:UserDefaults.standard.integer(forKey: "vehicleId"),
            trailers: UserDefaults.standard.string(forKey: "trailer") ?? "",
            notes: "",
            serverId: nil,
            timestamp: Int64(Date().timeIntervalSince1970),
            identifier: Int.random(in: 1000...9999),
            remainingWeeklyTime: remainingWeeklyTime,
            remainingDriveTime: remainingDriveTime,
            remainingDutyTime: remainingDutyTime,
            remainingSleepTime: remainingSleepTime,
            lastSleepTime: lastSleepTime,
            isSplit: 0,
            engineStatus: "Off"
        )
        insertLog(from: log)
    }
}


//MARK: -  DriverLogModel for DataBase struct DriverLogModel: Identifiable {
struct DriverLogModel: Identifiable {
    
    var id: Int64?
    let status: String
    let startTime: String
    let userId: Int
    let day: Int
    let isVoilations: Int
    let dutyType: String
    let shift: Int
    let vehicle: String
    let isRunning: Bool
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
    let remainingWeeklyTime: String?
    let remainingDriveTime: String?
    let remainingDutyTime: String?
    let remainingSleepTime: String?
    let lastSleepTime: String
    let isSplit: Int
    let engineStatus: String
}


//MARK: -  Upload sync Data

extension DatabaseManager {

    func markLogAsSynced(localId: Int64, serverId: String) {
        do {
            let log = driverLogs.filter(id == localId)
            try db?.run(log.update(isSynced <- true, self.serverId <- serverId))
            print(" Marked localId \(localId) as synced with serverId \(serverId)")
        } catch {
            print(" Update Sync Status Error: \(error)")
        }
    }
}























