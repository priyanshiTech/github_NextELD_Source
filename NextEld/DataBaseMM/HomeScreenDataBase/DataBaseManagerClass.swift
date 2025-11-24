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

protocol DatabaseHandler {
    var db: Connection? { get }
}

enum FilterType {
    case getTodayRecord
    case getYesterdayRecord
    case day
    case user
    case violation
    case warning
    case nextDayAlert
    case splitShiftIdentifier
    case onDuty
    case onDrive
    case betweenDates(startDate: Date, endDate: Date)
    case specificDay(Int)
    case shift
    case notSync

}

enum SQLiteQuery {
    case fetchYesterdayRecord
    func getQuery() -> String {
        return ""
    }
}


struct DriverLogModel: Identifiable {
    var id: Int64?
    let status: String
    let startTime: Date
    let userId: Int
    let day: Int
    let isVoilations: Int
   // let isVoilations: String
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
    let remainingWeeklyTime: Int?
    let remainingDriveTime: Int?
    let remainingDutyTime: Int?
    let remainingSleepTime: Int?
    let breaktimerRemaning:Int?
    let lastSleepTime: Int
    let isSplit: Int
    let engineStatus: String
    let isCertifiedLog: String
}

struct DutyLog {
    let id: Int
    let status: String
    let startTime: Date
    let endTime: Date
}

class DatabaseManager: DatabaseHandler {
    static let shared = DatabaseManager()

    var db: Connection?
   
    //MARK: - Split shift Table
    let splitShiftTable = Table("SplitShiftLog")
    let splitTime = Expression<Double>("splitTime")


    // MARK: - Table and Columns
    let driverLogs = Table("driverLogs")
    let id = Expression<Int64>("id")
    let status = Expression<String>("status")
    let startTime = Expression<Date>("startTime")
    let userId = Expression<Int>("userId")
    let day = Expression<Int>("day")
    let isVoilationColumn = Expression<Int>("isVoilation")
  //  let isVoilationColumn = Expression<String>("isVoilation")
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
    let remainingWeeklyTime = Expression<Int>("remainingWeeklyTime")
    let remainingDriveTime = Expression<Int>("remainingDriveTime")
    let remainingDutyTime = Expression<Int>("remainingDutyTime")
    let remainingSleepTime = Expression<Int>("remainingSleepTime")
    let breaktimerRemaning = Expression<Int>("breaktimerRemaning")
    let lastSleepTime = Expression<Int>("lastSleepTime")
    let isSplit = Expression<Int>("isSplit")
    let engineStatus = Expression<String>("engineStatus")
    

    private init() {
        do {
            let docDir = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let path = docDir.appendingPathComponent("local.db").path
            db = try Connection(path)
            print("*__________ SQLite DB path: \(path)")

            createTable()
            createSplitShiftTable()
        } catch {
            print("******DB Init Error: \(error)")
        }
    }
    
    
    func createSplitShiftTable() {
        do {
            try db?.run(splitShiftTable.create(ifNotExists: true) { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(status)
                t.column(userId)
                t.column(day)
                t.column(shift)
                t.column(splitTime)
            })
        } catch {
            print("******splitShiftTable creation Error: \(error)")
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
                t.column(breaktimerRemaning)
                t.column(lastSleepTime)
                t.column(isSplit)
                t.column(engineStatus)
            })
        } catch {
            print("****** Table Create Error: \(error)")
        }
    }
    
    // GET Record By SQL Statements
    func fetchAllRecord(for query: SQLiteQuery) -> [DriverLogModel] {
            guard let db = db else { return [] }
            var logs: [DriverLogModel] = []
           do {
               for row in try db.prepare(driverLogs) {
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
                       breaktimerRemaning: row[breaktimerRemaning],
                       lastSleepTime: row[lastSleepTime],
                       isSplit: row[isSplit],
                       engineStatus: row[engineStatus], isCertifiedLog: ""
                   ))
               }
           } catch {
               print("Raw SQL query failed: \(error)")
           }

           return logs
    }
    
    private func getFilter(for type: FilterType) -> SQLite.Expression<Bool> {
        let currentStartOfDay = DateTimeHelper.startOfDay(for: DateTimeHelper.currentDateTime())
        let currentEndOfDay =  DateTimeHelper.calendar.date(byAdding: .day, value: 1, to: currentStartOfDay)!
        let yesterDay =  DateTimeHelper.calendar.date(byAdding: .day, value: -1, to: DateTimeHelper.currentDateTime()) ?? Date()
        let yesterDayStartOfDay =  DateTimeHelper.startOfDay(for: yesterDay)
        let yesterDayEndOfDay =  DateTimeHelper.calendar.date(byAdding: .day, value: 1, to: yesterDayStartOfDay) ?? Date()
    
        switch type {
        case .getTodayRecord:
            return startTime >= currentStartOfDay && startTime < currentEndOfDay
        case .getYesterdayRecord:
            return startTime >= yesterDayStartOfDay && startTime < yesterDayEndOfDay
        case .day:
            return day == AppStorageHandler.shared.days
        case .user:
            return userId == AppStorageHandler.shared.driverId ?? 0
        case .violation:
            return status != AppConstants.violation
        case .warning:
            return status != AppConstants.warning
        case .nextDayAlert:
            return status != AppConstants.nextDayAlertTitle
        case .splitShiftIdentifier:
            return self.identifier == AppStorageHandler.shared.splitShiftIdentifier
        case .onDuty:
            return self.status == AppConstants.on_Duty
        case .onDrive:
            return self.status == AppConstants.on_Drive
        case .betweenDates(let startDate, let endDate):
            return startTime >= startDate && startTime < endDate
        case .specificDay(let currentDay):
            return day == currentDay
        case .shift:
            return shift == AppStorageHandler.shared.shift
        case .notSync:
            return self.isSynced == false
        }
    }
    
    func fetchLogs(filterTypes: [FilterType] = [], addWarningAndViolation: Bool = false, order: [Expressible]? = [], limit: Int? = nil) -> [DriverLogModel] {
        var logs: [DriverLogModel] = []
        var filterExpression: SQLite.Expression<Bool> = getFilter(for: .user) // default filter
        if !addWarningAndViolation {
            // wether we need to add violation or warning in record mainly we will add this record when showing all record
            filterExpression = filterExpression && getFilter(for: .violation) && getFilter(for: .warning) && getFilter(for: .nextDayAlert)
        }
        for type in filterTypes {
            let filter = getFilter(for: type)
            filterExpression = filterExpression && filter
        }
        var query = driverLogs.filter(filterExpression).order(startTime.desc)
        if let order = order {
            query = query.order(order)
        }
        if let limit = limit {
            query = query.limit(limit)
        }
        do {
            for row in try db!.prepare(query) {
                logs.append(DriverLogModel(

                    id: row[id],
                    status: row[status],
                    startTime: row[startTime],
                    userId: row[userId],
                    day: row[day],
                    isVoilations: (try? row.get(isVoilationColumn)) ?? 0,
                   // isVoilations: "\(try row.get(isVoilationColumn))",
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
                    breaktimerRemaning: row[breaktimerRemaning],
                    lastSleepTime: row[lastSleepTime],
                    isSplit: row[isSplit],
                    engineStatus: row[engineStatus], isCertifiedLog: ""
                ))
            }
        } catch {
            print("Erooorrrooororor-------------- Fetch Error: \(error)")
        }
        return logs
    }
    
    // MARK: - Get Most Recent Trailer from Database
    func getMostRecentTrailer() -> String? {
        // First check DriverLogs database
        let logs = fetchLogs(filterTypes: [.user], addWarningAndViolation: false, order: [startTime.desc], limit: 100)
        
        print(" Searching for trailer in \(logs.count) driver logs...")
        
        // Find the most recent log with a non-empty trailer
        for (index, log) in logs.enumerated() {
            let trailer = log.trailers.trimmingCharacters(in: .whitespacesAndNewlines)
            print(" Log \(index + 1): status=\(log.status), trailer='\(trailer)'")
            
            if !trailer.isEmpty && trailer.lowercased() != "upcoming" {
                print(" Found trailer in driver logs: \(trailer)")
                return trailer
            }
        }
        
        // If not found in DriverLogs, check DVIR database
        print(" Checking DVIR database for trailer...")
        let dvirRecords = DvirDatabaseManager.shared.fetchAllRecords()
        let sortedDvirRecords = dvirRecords.sorted { record1, record2 in
            // Sort by timestamp descending (most recent first)
            let timestamp1 = Int64(record1.timestamp) ?? 0
            let timestamp2 = Int64(record2.timestamp) ?? 0
            return timestamp1 > timestamp2
        }
        
        for (index, record) in sortedDvirRecords.enumerated() {
            let trailer = record.Trailer.trimmingCharacters(in: .whitespacesAndNewlines)
            print(" DVIR Record \(index + 1): trailer='\(trailer)'")
            
            if !trailer.isEmpty && trailer.lowercased() != "upcoming" {
                print("Found trailer in DVIR database: \(trailer)")
                return trailer
            }
        }
        
        // Last fallback: Check UserDefaults
        if let userDefaultsTrailer = UserDefaults.standard.string(forKey: "trailer"),
           !userDefaultsTrailer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
           userDefaultsTrailer.lowercased() != "upcoming" {
            print(" Found trailer in UserDefaults: \(userDefaultsTrailer)")
            return userDefaultsTrailer
        }
        
        print(" No valid trailer found in any database or UserDefaults")
        return nil
    }

    
    func saveDriverLogsToSQLite(from logs: [ServerDriverLog]) {
        print("Correct!!!!!!!!!!!!!!!! Saving \(logs.count) logs into SQLite")

        for (index, log) in logs.enumerated() {
            
            let originCode = UserDefaults.standard.integer(forKey: "origin") // or from API
            let originValue = OriginType(rawValue: originCode)?.description ?? "Driver" // default

            let model = DriverLogModel(
                id: nil,
                status: log.status ?? "Unknown",
                startTime: DateTimeHelper.currentDateTime(),
                userId: log.driverId ?? 0,
                day: log.days ?? 0,
                isVoilations: log.isVoilation ?? 0,
                dutyType: log.logType ?? "",
                shift: log.shift ?? 0,
                vehicle: log.truckNo ?? "",
                isRunning: true,
                odometer: log.odometer ?? 0.0,
                engineHours: log.engineHour ?? "0",
                location: log.customLocation ?? "",
                lat: log.lattitude ?? 0.0,
                long: log.longitude ?? 0.0,
                origin: originValue ,
                isSynced: false,
                vehicleId: log.vehicleId ?? 0,
                trailers: (log.trailers ?? []).joined(separator: ", "),
                notes: log.note ?? "",
                serverId: log._id,
                timestamp: currentTimestampMillis(),
                identifier: log.identifier ?? 0,
                remainingWeeklyTime: Int(log.remainingWeeklyTime ?? "0") ?? 0,
                remainingDriveTime: Int(log.remainingDriveTime ?? "0") ?? 0,
                remainingDutyTime: Int(log.remainingDutyTime ?? "0") ?? 0,
                remainingSleepTime: Int(log.remainingSleepTime ?? "0") ?? 0, breaktimerRemaning: log.breaktimerRemaning,
                lastSleepTime: Int(log.lastOnSleepTime ?? "0") ?? 0,
                isSplit: 0,
                engineStatus: "Off", isCertifiedLog: ""
            )

            print(" Saving log #\(index + 1): \(model.status), \(model.startTime)")
            print("isVoilation before insert:", model.isVoilations)

            insertLog(from: model)
        }
        
        print("Finished saving logs.")

    }
    
    func insertLog(from model: DriverLogModel) {

        // Normalize status (case insensitive)
        let normalizedStatus = model.status.lowercased()
        
        let skipStatuses: Set<String> = [
            "cycle", "weeklycycle"
        ]
        
       
        if skipStatuses.contains(normalizedStatus) {
            print(" Skipping log insert for status: \(model.status)")
            return
        }
        
        do {
            
            let safeDay = model.day == 0 ? 1 : model.day
            let safeShift = model.shift == 0 ? 1 : model.shift

            
            let insert = driverLogs.insert(
                status <- model.status,
                startTime <- model.startTime,
                userId <- model.userId,
                day <- safeDay,
                isVoilationColumn <- model.isVoilations,
                dutyType <- model.dutyType,
                shift <- safeShift,
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
                remainingWeeklyTime <- model.remainingWeeklyTime ?? 0,
                remainingDriveTime <- model.remainingDriveTime ?? 0,
                remainingDutyTime <- model.remainingDutyTime ?? 0,
                remainingSleepTime <- model.remainingSleepTime ?? 0,
                breaktimerRemaning <- model.breaktimerRemaning ?? 0,
                lastSleepTime <- model.lastSleepTime,
                isSplit <- model.isSplit,
                engineStatus <- model.engineStatus
            )
            
            let rowID = try db?.run(insert) ?? 0
            print(" Log inserted into SQLite with ID: \(rowID) — \(model.status) at \(model.startTime)")

           
        } catch {
            print(" Insert Log Error: \(error.localizedDescription)")
        }
    }

    


    
    //MARK: -  TO DELETE ALL SAVED DATA IN DBMS

    func deleteAllLogs() {
        do {
            try db?.run(driverLogs.delete()) //  Uses the same table instance you declared at top
            try db?.run(splitShiftTable.delete())

            print("All logs deleted successfully")
        } catch {
            print("Error deleting logs: \(error)")
        }
    }
    
    func getLastRecordOfDriverLogs(filterTypes: [FilterType] = []) -> DriverLogModel? {
        var logs: [DriverLogModel] = []
        do {
            guard let db = self.db else { return nil}
            var filterExpression = getFilter(for: .user) && getFilter(for: .violation) && getFilter(for: .warning) && getFilter(for: .nextDayAlert)
            for type in filterTypes {
                let filter = getFilter(for: type)
                filterExpression = filterExpression && filter
            }
             let query = driverLogs
                            .filter(filterExpression)
                            .order(startTime.desc)
                            .limit(1)
            let resultSet = try db.prepare(query)
            for row in resultSet {
                logs.append(DriverLogModel(
                    id: row[id],
                    status: row[status],
                    startTime: row[startTime],
                    userId: row[userId],
                    day: row[day],
                    isVoilations: (try? row.get(isVoilationColumn)) ?? 0,
                   // isVoilations: "\(try row.get(isVoilationColumn))",
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
                    breaktimerRemaning: row[breaktimerRemaning],
                    lastSleepTime: row[lastSleepTime],
                    isSplit: row[isSplit],
                    engineStatus: row[engineStatus], isCertifiedLog: ""
                ))
            }
            
            return logs.first
        } catch {
            return nil
        }
    }

    func fetchLastRecord(before date: Date) -> DriverLogModel? {
        guard let db = self.db else { return nil }
        let baseFilter = getFilter(for: .user) && getFilter(for: .violation) && getFilter(for: .warning) && getFilter(for: .nextDayAlert)
        let filterExpression = baseFilter && startTime < date
        do {
            if let row = try db.pluck(driverLogs.filter(filterExpression).order(startTime.desc).limit(1)) {
                return DriverLogModel(
                    id: row[id],
                    status: row[status],
                    startTime: row[startTime],
                    userId: row[userId],
                    day: row[day],
                    isVoilations: (try? row.get(isVoilationColumn)) ?? 0,
                    dutyType: row[dutyType],
                    shift: row[shift],
                    vehicle: row[vehicleName],
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
                    breaktimerRemaning: row[breaktimerRemaning],
                    lastSleepTime: row[lastSleepTime],
                    isSplit: row[isSplit],
                    engineStatus: row[engineStatus],
                    isCertifiedLog: ""
                )
            }
        } catch {
            print(" Fetch last record before date error: \(error)")
        }
        return nil
    }

    
    func fetchDutyEventsForToday() -> [DutyLog] {
        let fetchTodaysLogs = fetchLogs(filterTypes: [.getTodayRecord])
        var logs: [DutyLog] = []
        let currentStartOfDay = DateTimeHelper.startOfDay(for: DateTimeHelper.currentDateTime())
        for log in fetchTodaysLogs {
            let log = DutyLog(id: Int(log.id ?? 0), status: log.status, startTime: log.startTime, endTime: log.startTime)
            logs.append(log)
        }
        if let yesterDayLastRecord = getLastRecordOfDriverLogs(filterTypes: [.getYesterdayRecord]) {
            // Previous day status continue today
            logs.insert(DutyLog(id: Int(yesterDayLastRecord.id ?? 0), status: yesterDayLastRecord.status, startTime: currentStartOfDay, endTime: DateTimeHelper.currentDateTime()), at: 0)
        } else {
            let logFromToday12AMtoCurrentTime = DutyLog(id: -111, status: DriverStatusType.offDuty.getName(), startTime: currentStartOfDay, endTime: DateTimeHelper.currentDateTime())
            logs.insert(logFromToday12AMtoCurrentTime, at: 0)
        }
        return logs
    }

    func fetchDutyEvents(for date: Date) -> [DutyLog] {
        let startOfDay = DateTimeHelper.startOfDay(for: date)
        let endOfDay = DateTimeHelper.calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? startOfDay

        let dayLogs = fetchLogs(filterTypes: [.betweenDates(startDate: startOfDay, endDate: endOfDay)])
        var dutyLogs: [DutyLog] = dayLogs
            .map { DutyLog(id: Int($0.id ?? 0), status: $0.status, startTime: $0.startTime, endTime: $0.startTime) }

        if let previousLog = fetchLastRecord(before: startOfDay) {
            dutyLogs.insert(
                DutyLog(id: Int(previousLog.id ?? 0), status: previousLog.status, startTime: startOfDay, endTime: startOfDay),
                at: 0
            )
        } else {
            dutyLogs.insert(
                DutyLog(id: -111, status: DriverStatusType.offDuty.getName(), startTime: startOfDay, endTime: startOfDay),
                at: 0
            )
        }

        if dutyLogs.isEmpty {
            dutyLogs = [
                DutyLog(id: -111, status: DriverStatusType.offDuty.getName(), startTime: startOfDay, endTime: startOfDay)
            ]
        }

        return dutyLogs.sorted { $0.startTime < $1.startTime }
    }
}

    //MARK: - Fetch last recent Day & Shift from DB


extension DatabaseManager {
    //MARK: - Fetch last recent Day & Shift from DB
//    func updateLastDayAndShift(for userIdValue: Int) {
//        guard let db = db else { return }
//        do {
//            if let row = try db.pluck(
//                driverLogs
//                    .filter(userId == userIdValue)
//                    .order(timestamp.desc)
//                    .limit(1)
//            ) {
//                var fetchedDay = row[day]
//                var fetchedShift = row[shift]
//
//                //  Default handling: agar 0 ya blank aaye to 1 set karo
//                if fetchedDay == 0 { fetchedDay = 1 }
//                if fetchedShift == 0 { fetchedShift = 1 }
//
//                // Save to properties
//                self.lastDay = fetchedDay
//                self.lastShift = fetchedShift
//
//                print(" Last row → Day: \(fetchedDay), Shift: \(fetchedShift)")
//            } else {
//                print(" No rows found for userId: \(userIdValue)")
//                self.lastDay = 1
//                self.lastShift = 1
//            }
//        } catch {
//            print(" Error fetching last day/shift: \(error)")
//            self.lastDay = 1
//            self.lastShift = 1
//        }
//    }
}

 

extension DatabaseManager {
    func saveTimerLog(
        status: String,
        startTime: Date,
        dutyType: String,
        remainingWeeklyTime: Int,
        remainingDriveTime: Int,
        remainingDutyTime: Int,
        remainingSleepTime: Int,
        breakTimeRemaning: Int,
        lastSleepTime: Int,
        RemaningRestBreak: String,
        isruning: Bool,
        isVoilations: Bool = false
        //isVoilations: String

    ) {
        let storedOrigin = AppStorageHandler.shared.origin?.trimmingCharacters(in: .whitespacesAndNewlines)
        let originCode = UserDefaults.standard.integer(forKey: "origin")
        let fallbackOrigin = OriginType(rawValue: originCode)?.description ?? OriginType.driver.description
        let resolvedOrigin = (storedOrigin?.isEmpty == false) ? storedOrigin! : fallbackOrigin
        if storedOrigin?.isEmpty ?? true {
            AppStorageHandler.shared.origin = resolvedOrigin
        }
        
        let log = DriverLogModel(
            id: nil,
            status: status,
            startTime: startTime,
            userId: AppStorageHandler.shared.driverId ?? 0,
            day: AppStorageHandler.shared.days,
            isVoilations: isVoilations ? 1 : 0,   //  Actual Bool → Int
            dutyType: dutyType,
            shift: AppStorageHandler.shared.shift,
            vehicle: AppStorageHandler.shared.vehicleNo ?? "",
                //UserDefaults.standard.string(forKey: "truckNo") ?? "Null",
            isRunning: isruning,
            odometer: 0.0,
            engineHours: "0",
            location: UserDefaults.standard.string(forKey: "customLocation") ?? "",
            lat: Double(UserDefaults.standard.string(forKey: "lattitude") ?? "") ?? 0,
            long: Double(UserDefaults.standard.string(forKey: "longitude") ?? "") ?? 0,
            origin: resolvedOrigin,
            isSynced: false,
            vehicleId: AppStorageHandler.shared.vehicleId ?? 0,
                //UserDefaults.standard.integer(forKey: "vehicleId"),
            trailers: UserDefaults.standard.string(forKey: "trailer") ?? "",
            notes: "",
            serverId: nil,
            timestamp:TimeUtils.currentTimestamp(with: AppStorageHandler.shared.timeZoneOffset ?? ""),
              //CurrentTimeHelperStamp.currentTimestamp,
            // Int64(Date().timeIntervalSince1970),
            identifier: AppStorageHandler.shared.splitShiftIdentifier,
            remainingWeeklyTime: remainingWeeklyTime,
            remainingDriveTime: remainingDriveTime,
            remainingDutyTime: remainingDutyTime,
            remainingSleepTime: remainingSleepTime,
            breaktimerRemaning: breakTimeRemaning,
            lastSleepTime: lastSleepTime,
            isSplit: 0,
            engineStatus: "Off", isCertifiedLog: ""
            
        )
        
        insertLog(from: log)
    }
    
}
    //MARK: -  DriverLogModel for DataBase struct DriverLogModel: Identifiable {
    

    //MARK: -  Upload sync Data
extension DatabaseManager {
    func updateIdentifier(uniqueId: Int64, identifier: Int) {
        do {
            let log = driverLogs.filter(id == uniqueId)
            try db?.run(log.update(self.identifier <- identifier))
            print("Identifier updated for \(uniqueId) to \(identifier)")
        } catch {
            print("failed to update Identifier: \(error)")
        }
    }
    
    func markLogAsSynced(localId: Int64, serverId: String) {
        do {
            let log = driverLogs.filter(id == localId)
            try db?.run(log.update(isSynced <- true, self.serverId <- serverId))
            print(" Marked localId \(localId) as synced with serverId \(serverId)")
        } catch {
            print(" Update Sync Status Error: \(error)")
        }
    }
    
    func updateValues(id: Int64, remainingCycleTime: TimeInterval? = nil, remainingOnDutyTime: TimeInterval? = nil, remainingOnDriveTime: TimeInterval? = nil) {
        do {
            let log = driverLogs.filter(self.id == id)
            if let remainingCycleTime {
                try db?.run(log.update(self.remainingWeeklyTime <- Int(remainingCycleTime)))
            }
            if let remainingOnDutyTime {
                try db?.run(log.update(self.remainingDutyTime <- Int(remainingOnDutyTime)))
            }
            if let remainingOnDriveTime {
                try db?.run(log.update(self.remainingDriveTime <- Int(remainingOnDriveTime)))
            }
            
        } catch {
            print(" Update Timer Value Error: \(error)")
        }
    }
}

//MARK: - Check for previous day logs that need certification
extension DatabaseManager {
    func hasPreviousDayLogsUncertified() -> Bool {
        guard let db = db else {
            print("Database not available")
            return false
        }
        
        do {
            let calendar = Calendar.current
            let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())!
            let startOfYesterday = calendar.startOfDay(for: yesterday)
            let endOfYesterday = calendar.date(byAdding: .day, value: 1, to: startOfYesterday)!
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            formatter.timeZone = TimeZone.current
            
            let startOfYesterdayString = formatter.string(from: startOfYesterday)
            let endOfYesterdayString = formatter.string(from: endOfYesterday)
            
            print("Checking for logs between: \(startOfYesterdayString) and \(endOfYesterdayString)")
            
            // Check if there are any logs from previous day
            let query = driverLogs.filter(
                startTime >= startOfYesterday &&
                startTime < endOfYesterday
            )
            
            
            
            let totalCount = try db.scalar(query.count)
            print("Found \(totalCount) logs from previous day")
            
            // If no logs from previous day, return false (normal popup)
            if totalCount == 0 {
                print("No previous day logs found - showing normal popup")
                return false
            }
            
            // Check for Off Duty duration (10+ hours)
            let offDutyQuery = driverLogs.filter(
                startTime >= startOfYesterday &&
                startTime < endOfYesterday &&
                status == "OffDuty"
            )
            
            var hasLongOffDuty = false
            let offDutyLogs = try db.prepare(offDutyQuery)
            
            for log in offDutyLogs {
                let startTimeString = log[startTime]
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                formatter.timeZone = TimeZone.current
                
              //  if let startDate = formatter.date(from: startTimeString) {
                    // Calculate duration from start time to now (or next log)
                    let duration = Date().timeIntervalSince(startTimeString)
                    let hours = duration / 3600
                    
                    print("Off Duty log started at: \(startTimeString), Duration: \(hours) hours")
                    
                    if hours >= 10 {
                        hasLongOffDuty = true
                        print("Found Off Duty longer than 10 hours!")
                        break
              //      }
                }
            }
            
            // Check certification status using existing fields
            // Since we don't have isCertifiedLog column, we'll use a workaround
            
            // Option 1: Check if all previous day logs have notes (assuming certified logs have notes)
            let certifiedQuery = driverLogs.filter(
                startTime >= startOfYesterday &&
                startTime < endOfYesterday &&
                notes != ""  // Non-empty notes might indicate certification
            )
            let certifiedCount = try db.scalar(certifiedQuery.count)
            print("Found \(certifiedCount) logs with notes (possibly certified)")
            
            // Option 2: Check sync status (certified logs should be synced)
            let syncedQuery = driverLogs.filter(
                startTime >= startOfYesterday &&
                startTime < endOfYesterday &&
                isSynced == true  // Synced might indicate certification
            )
            let syncedCount = try db.scalar(syncedQuery.count)
            print("Found \(syncedCount) synced logs from previous day")
            
            // Determine if certification is needed
            // If less than 50% logs are synced or have notes, consider uncertified
            let certificationThreshold = totalCount / 2
            let highestIndication = max(certifiedCount, syncedCount)
            let needsCertification = (highestIndication < certificationThreshold && totalCount > 0) || hasLongOffDuty
            
            if needsCertification {
                if hasLongOffDuty {
                    print("Showing CERTIFY popup - Off Duty longer than 10 hours")
                } else {
                    print("Showing CERTIFY popup - logs need certification")
                }
            } else {
                print("Showing NORMAL popup - all logs are certified")
            }
            
            return needsCertification
            
        } catch {
            print("Error checking previous day logs: \(error)")
            // If error, assume normal popup
            return false
        }
    }
}


