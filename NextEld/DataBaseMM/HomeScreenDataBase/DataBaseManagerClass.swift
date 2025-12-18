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
    case engineStatus
    case notEngineStartStatus
    case notEngineStopStatus
    case specificDate(date: Date)
    case login
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
    let isVoilations: String
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
    let remainingWeeklyTime: Int?
    let remainingDriveTime: Int?
    let remainingDutyTime: Int?
    let remainingSleepTime: Int?
    let breaktimerRemaning:Int?
    let lastSleepTime: Int
    let isSplit: Int
    let engineStatus: String
    let isSystemGenerated: Int?
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
    let isVoilationColumn = Expression<String>("isVoilation")
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
    let isSystemGenerated = Expression<Int>("isSystemGenerated")
    

    private init() {
        do {
            let docDir = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let path = docDir.appendingPathComponent("local.db").path
            db = try Connection(path)
            // print("*__________ SQLite DB path: \(path)")

            createTable()
            createSplitShiftTable()
        } catch {
            // print("******DB Init Error: \(error)")
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
            // print("******splitShiftTable creation Error: \(error)")
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
                t.column(isSystemGenerated, defaultValue: 0)
            })
        } catch {
            // print("****** Table Create Error: \(error)")
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
                       isVoilations: row[isVoilationColumn],
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
                       breaktimerRemaning: row[breaktimerRemaning],
                       lastSleepTime: row[lastSleepTime],
                       isSplit: row[isSplit],
                       engineStatus: row[engineStatus],
                       isSystemGenerated: row[isSystemGenerated],
                       
                   ))
               }
           } catch {
               // print("Raw SQL query failed: \(error)")
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
            return self.status == AppConstants.onDuty
        case .onDrive:
            return self.status == AppConstants.onDrive
        case .betweenDates(let startDate, let endDate):
            return startTime >= startDate && startTime < endDate
            
        case .specificDay(let currentDay):
            return day == currentDay
        case .shift:
            return shift == AppStorageHandler.shared.shift
        case .notSync:
            return self.isSynced == false
        case .engineStatus:
            return status == AppConstants.engineOff || status == AppConstants.engineOn
        case .notEngineStartStatus:
            return status != AppConstants.engineOn
        case .notEngineStopStatus:
            return status != AppConstants.engineOff
        case .specificDate(let date):
            return startTime == date
        case .login:
            return status == AppConstants.login
        }
    }
    
    func fetchLogs(filterTypes: [FilterType] = [], addWarningAndViolation: Bool = false, order: [Expressible]? = nil, limit: Int? = nil) -> [DriverLogModel] {
        var logs: [DriverLogModel] = []
        var filterExpression: SQLite.Expression<Bool> = .init(value: true)
        
        if !addWarningAndViolation { //default case
            // wether we need to add violation or warning in record mainly we will add this record when showing all record
            filterExpression = filterExpression && baseFilter()
        }
        for type in filterTypes {
            let filter = getFilter(for: type)
            filterExpression = filterExpression && filter
        }
        var query = driverLogs.filter(filterExpression)
        if let order = order {
            query = query.order(order)
        } else {
            query = query.order(startTime.asc)
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
                    isVoilations: row[isVoilationColumn],
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
                    breaktimerRemaning: row[breaktimerRemaning],
                    lastSleepTime: row[lastSleepTime],
                    isSplit: row[isSplit],
                    engineStatus: row[engineStatus],
                    isSystemGenerated: row[isSystemGenerated],
                ))
            }
        } catch {
            // print("Erooorrrooororor-------------- Fetch Error: \(error)")
        }
        
        // Remove duplicates: Keep only one entry per status + startTime combination
        // Since logs are already ordered by startTime.desc, first occurrence is most recent
        // Use time window (2 seconds) to catch near-duplicates
        var uniqueLogs: [DriverLogModel] = []
        
        for log in logs {
            var isDuplicate = false
            
            // Check if this log is a duplicate of any already added log
            for existingLog in uniqueLogs {
                // Same status and userId
                if existingLog.status == log.status && existingLog.userId == log.userId {
                    // Check if startTime is within 2 seconds
                    let timeDifference = abs(existingLog.startTime.timeIntervalSince(log.startTime))
                    if timeDifference <= 2.0 {
                        isDuplicate = true
                        break
                    }
                }
            }
            
            // Also check by serverId if available (most reliable)
            if let serverId = log.serverId, !serverId.isEmpty {
                for existingLog in uniqueLogs {
                    if let existingServerId = existingLog.serverId,
                       existingServerId == serverId && existingLog.userId == log.userId {
                        isDuplicate = true
                        break
                    }
                }
            }
            
            if !isDuplicate {
                uniqueLogs.append(log)
            }
        }
        
        return uniqueLogs
    }
    
    // MARK: - Get Most Recent Trailer from Database
    func getMostRecentTrailer() -> String? {
        // First check DriverLogs database
        let logs = fetchLogs(filterTypes: [.user], addWarningAndViolation: false, order: [startTime.desc], limit: 100)
        
        // print(" Searching for trailer in \(logs.count) driver logs...")
        
        // Find the most recent log with a non-empty trailer
        for (index, log) in logs.enumerated() {
            let trailer = log.trailers.trimmingCharacters(in: .whitespacesAndNewlines)
            // print(" Log \(index + 1): status=\(log.status), trailer='\(trailer)'")
            
            if !trailer.isEmpty && trailer.lowercased() != "upcoming" {
                // print(" Found trailer in driver logs: \(trailer)")
                return trailer
            }
        }
        
        // If not found in DriverLogs, check DVIR database
        // print(" Checking DVIR database for trailer...")
        let dvirRecords = DvirDatabaseManager.shared.fetchAllRecords()
        let sortedDvirRecords = dvirRecords.sorted { record1, record2 in
            // Sort by timestamp descending (most recent first)
            let timestamp1 = Int64(record1.timestamp) ?? 0
            let timestamp2 = Int64(record2.timestamp) ?? 0
            return timestamp1 > timestamp2
        }
        
        for (index, record) in sortedDvirRecords.enumerated() {
            let trailer = record.Trailer.trimmingCharacters(in: .whitespacesAndNewlines)
            // print(" DVIR Record \(index + 1): trailer='\(trailer)'")
            
            if !trailer.isEmpty && trailer.lowercased() != "upcoming" {
                // print("Found trailer in DVIR database: \(trailer)")
                return trailer
            }
        }
        
        // Last fallback: Check UserDefaults
        if let userDefaultsTrailer = UserDefaults.standard.string(forKey: "trailer"),
           !userDefaultsTrailer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
           userDefaultsTrailer.lowercased() != "upcoming" {
            // print(" Found trailer in UserDefaults: \(userDefaultsTrailer)")
            return userDefaultsTrailer
        }
        
        // print(" No valid trailer found in any database or UserDefaults")
        return nil
    }
    // MARK: - Save Login/Logout Logs to Database
    func saveLoginLogoutLogsToSQLite(from logs: [LoginLogoutLog]) {
        // print("Saving \(logs.count) login/logout logs into SQLite")
        
        for (index, log) in logs.enumerated() {
            // Determine status - Login or Logout
            var statusString = log.status ?? ""
            var dutyType = log.logType ?? ""

            
            // If status field contains login/logout info, use that
            if let status = log.status?.lowercased() {
                if status.contains("login") {
                    statusString = "Login"
                    dutyType = "Login"
                } else if status.contains("logout") {
                    statusString = "Logout"
                    dutyType = "Logout"
                }
            }
            
            var isVoilation: String = "NO"
            if log.isVoilation == 1 {
                isVoilation = "YES"
            }
            var dateTime: Date? = nil
            if let timeStampString = log.dateTime,
                let timeStamp = TimeInterval(timeStampString) {
                let convertToSecond = TimeInterval(timeStamp/1000)
                dateTime = Date(timeIntervalSince1970: convertToSecond)
                print("datetime: \(dateTime!)")
           }
            
            let model = DriverLogModel(
                id: nil,
                status: statusString,
                startTime:  dateTime ?? Date() ,
                userId: log.driverId ?? 0,
                day: log.days ?? 0,
                isVoilations: isVoilation,
                dutyType: dutyType,
                shift: log.shift ?? 0,
                vehicle: "",
                odometer: log.odometer ?? 0.0,
                engineHours: log.engineHour ?? "0",
                location: log.customLocation ?? "",
                lat: log.lattitude ?? 0.0,
                long: log.longitude ?? 0.0,
                origin: log.origin ?? "",
                isSynced: true,
                vehicleId: log.vehicleId ?? 0,
                trailers: "",
                notes: log.note ?? "",
                serverId: log._id,
                timestamp:Int64(log.dateTime ?? "0") ?? 0,
                identifier: 0,
                remainingWeeklyTime: Int(log.remainingWeeklyTime ?? "0") ?? 0,
                remainingDriveTime: Int(log.remainingDriveTime ?? "0") ?? 0,
                remainingDutyTime: Int(log.remainingDutyTime ?? "0") ?? 0,
                remainingSleepTime: Int(log.remainingSleepTime ?? "0") ?? 0,
                breaktimerRemaning: nil,
                lastSleepTime: 0,
                isSplit: 0,
                engineStatus: "Off",
                isSystemGenerated: log.isReportGenerated
            )
            
            // print("Saving login/logout log: \(model.status), \(model.startTime)")
            insertLog(from: model)
            print("Login/Logout data saved successfully, \(index + 1)/\(logs.count)")
        }
        
        // print("Finished saving login/logout logs.")
    }
    
    func saveDriverLogsToSQLite(from logs: [ServerDriverLog]) {
        // print("Correct!!!!!!!!!!!!!!!! Saving \(logs.count) logs into SQLite")
        
        for (_, log) in logs.enumerated() {
            var isVoilation: String = ""
            
            var dutyType: String = log.status ?? ""

            if log.status == AppConstants.personalUse {
                isVoilation = "NO"
                dutyType = DriverStatusType.personalUse.getName()
            } else if log.status == AppConstants.yardMove  {
                isVoilation = "NO"
                dutyType = DriverStatusType.yardMode.getName()
            } else if log.status == AppConstants.engineOn {
                isVoilation = "Engine"
            } else if log.status == AppConstants.engineOff {
                isVoilation = "Engine"
            } else{
                if log.logType == "log" || log.logType == "System Generated" {
                    isVoilation = "NO"
                } else {
                    isVoilation = "YES"
                    dutyType = log.logType ?? ""
                }
            }
            let model = DriverLogModel(
                id: nil,
                status: log.status ?? "",
                startTime: log.dateTime?.asDate() ?? Date(),
                userId: log.driverId ?? 0,
                day: log.days ?? 0,
                isVoilations: isVoilation,
                dutyType: dutyType,
                shift: log.shift ?? 0,
                vehicle: log.truckNo ?? "",
                odometer: log.odometer ?? 0.0,
                engineHours: log.engineHour ?? "0",
                location: log.customLocation ?? "",
                lat: log.lattitude ?? 0.0,
                long: log.longitude ?? 0.0,
                origin: log.origin ?? "",
                isSynced: true,
                vehicleId: log.vehicleId ?? 0,
                trailers: (log.trailers ?? []).joined(separator: ", "),
                notes: log.note ?? "",
                serverId: log._id,
                timestamp: log.receivedTimestamp ?? 0,
                identifier: log.identifier ?? 0,
                remainingWeeklyTime: Int(log.remainingWeeklyTime ?? "0") ?? 0,
                remainingDriveTime: Int(log.remainingDriveTime ?? "0") ?? 0,
                remainingDutyTime: Int(log.remainingDutyTime ?? "0") ?? 0,
                remainingSleepTime: Int(log.remainingSleepTime ?? "0") ?? 0, breaktimerRemaning: log.breaktimerRemaning,
                lastSleepTime: Int(log.lastOnSleepTime ?? "0") ?? 0,
                isSplit: log.isSplit ?? 0,
                engineStatus: log.engineStatus ?? "Off",
                isSystemGenerated: log.isSystemGenerated
            )

            // print(" Saving log #\(index + 1): \(model.status), \(model.startTime)")
            // print("isVoilation before insert:", model.isVoilations)

            insertLog(from: model)
        }
        
        // print("Finished saving logs.")

    }
    
    func insertLog(from model: DriverLogModel) {
        // Normalize status (case insensitive)
        let normalizedStatus = model.status.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        let skipStatuses: Set<String> = [
            "cycle", "weeklycycle"
        ]
        
        if skipStatuses.contains(normalizedStatus) {
            // print(" Skipping log insert for status: \(model.status)")
            return
        }
        
     //    Check for duplicate: First by serverId (most reliable), then by status + startTime + userId
        do {
             // First check: If serverId exists, check for duplicate by serverId
            if let serverId = model.serverId, !serverId.isEmpty {
                let serverIdCheck = driverLogs.filter(
                    self.serverId == serverId &&
                    userId == model.userId
                )
                let serverIdCount = try db?.scalar(serverIdCheck.count) ?? 0
                if serverIdCount > 0 {
                    // print(" Duplicate log found by serverId: \(serverId), skipping insert")
                    return
                }
            }
            
            // Second check: Check for same status (case-insensitive) + startTime (within 5 seconds) + userId
            let fiveSecondsBefore = model.startTime.addingTimeInterval(-5.0)
            let fiveSecondsAfter = model.startTime.addingTimeInterval(5.0)
            
            // Get the most recent log for this user to check if status changed
            let recentLogsQuery = driverLogs.filter(
                userId == model.userId
            ).order(startTime.desc).limit(1)
            
            if let mostRecentLog = try db?.pluck(recentLogsQuery) {
                let mostRecentStatus = mostRecentLog[status].lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
                let mostRecentTime = mostRecentLog[startTime]
                
                // If same status and within 5 seconds, skip insertion
                if normalizedStatus == mostRecentStatus {
                    let timeDifference = abs(model.startTime.timeIntervalSince(mostRecentTime))
                    if timeDifference <= 5.0 {
                        // print(" Duplicate log found (same status '\(model.status)' within 5 seconds), skipping insert")
                        return
                    }
                }
            }
            
            // Third check: Check for logs with same normalized status, userId, and startTime within 5 seconds
            let duplicateCheck = driverLogs.filter(
                Expression<String>("lower(trim(status))") == normalizedStatus &&
                userId == model.userId &&
                startTime >= fiveSecondsBefore &&
                startTime <= fiveSecondsAfter
            )
            
            let existingCount = try db?.scalar(duplicateCheck.count) ?? 0
            if existingCount > 0 {
                // print(" Duplicate log found (status: \(model.status), time: \(model.startTime)), skipping insert")
                return
            }
        } catch {
            // print(" Error checking for duplicate: \(error), proceeding with insert")
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
                engineStatus <- model.engineStatus,
                isSystemGenerated <- model.isSystemGenerated ?? 0
            )
            
            let rowID = try db?.run(insert) ?? 0
            // print(" Log inserted into SQLite with ID: \(rowID) — \(model.status) at \(model.startTime)")
            
        } catch {
             print(" Insert Log Error: \(error.localizedDescription)")
        }
    }
    


    


    
    //MARK: -  TO DELETE ALL SAVED DATA IN DBMS

    func deleteAllLogs(completion: (() -> Void)? = nil) {
        do {
            try db?.transaction {
                try db?.run(driverLogs.delete())
                try db?.run("DELETE FROM sqlite_sequence WHERE name = 'driverLogs'")
            }
            completion?()
            print("Data Delete Successfully.....")
        } catch {
             print("Error deleting logs: \(error)")
        }
    }
    
    func baseFilter() -> SQLite.Expression<Bool> {
        var statusFilter : SQLite.Expression<Bool> = .init(value: false)
        for status in DriverStatusType.allCases {
            if status != .none {
                statusFilter = statusFilter || (self.status == status.getName())
            }
        }
        
        return statusFilter && getFilter(for: .user)
    }
    
    func getLastRecordOfDriverLogs(filterTypes: [FilterType] = [], applyBaseFilter: Bool = true) -> DriverLogModel? {
        var logs: [DriverLogModel] = []
        do {
            guard let db = self.db else { return nil}
            var filterExpression: SQLite.Expression<Bool> = .init(value: true)
            if applyBaseFilter {
                filterExpression = baseFilter()
            }
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
                    isVoilations: row[isVoilationColumn],
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
                    breaktimerRemaning: row[breaktimerRemaning],
                    lastSleepTime: row[lastSleepTime],
                    isSplit: row[isSplit],
                    engineStatus: row[engineStatus],
                    isSystemGenerated: row[isSystemGenerated],
                ))
            }
            
            return logs.first
        } catch {
            return nil
        }
    }

    func fetchLastRecord(before date: Date) -> DriverLogModel? {
        guard let db = self.db else { return nil }
        var filterExpression: SQLite.Expression<Bool> = baseFilter() && startTime < date
        
        do {
            if let row = try db.pluck(driverLogs.filter(filterExpression).order(startTime.desc).limit(1)) {
                return DriverLogModel(
                    id: row[id],
                    status: row[status],
                    startTime: row[startTime],
                    userId: row[userId],
                    day: row[day],
                    isVoilations: row[isVoilationColumn],
                    dutyType: row[dutyType],
                    shift: row[shift],
                    vehicle: row[vehicleName],
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
                    isSystemGenerated: row[isSystemGenerated]
                )
            }
        } catch {
            // print(" Fetch last record before date error: \(error)")
        }
        return nil
    }

    
    func fetchDutyEventsForToday(currentDate: Date = DateTimeHelper.currentDateTime()) -> [DutyLog] {
        let startOfDay = DateTimeHelper.startOfDay(for: currentDate)
        let endOfDay = DateTimeHelper.endOfDay(for: currentDate) ?? DateTimeHelper.currentDateTime()
        let fetchTodaysLogs = fetchLogs(filterTypes: [.betweenDates(startDate: startOfDay, endDate: endOfDay)])
        var logs: [DutyLog] = []
        let currentStartOfDay = DateTimeHelper.startOfDay(for: currentDate)
        for log in fetchTodaysLogs {
            let log = DutyLog(id: Int(log.id ?? 0), status: log.status, startTime: log.startTime, endTime: log.startTime)
            logs.append(log)
        }
        
        let yesterDay =  DateTimeHelper.calendar.date(byAdding: .day, value: -1, to: currentDate) ?? Date()
        let yesterDayStartOfDay =  DateTimeHelper.startOfDay(for: yesterDay)
        let yesterDayEndOfDay =  DateTimeHelper.calendar.date(byAdding: .day, value: 1, to: yesterDayStartOfDay) ?? Date()
        
        if let yesterDayLastRecord = getLastRecordOfDriverLogs(filterTypes: [.betweenDates(startDate: yesterDayStartOfDay, endDate: yesterDayEndOfDay)]) {
            // Previous day status continue today
            if DateTimeHelper.currentCalendar.isDateInToday(currentDate) {
                logs.insert(DutyLog(id: Int(yesterDayLastRecord.id ?? 0), status: yesterDayLastRecord.status, startTime: currentStartOfDay, endTime: DateTimeHelper.currentDateTime()), at: 0)
            } else {
                logs.insert(DutyLog(id: Int(yesterDayLastRecord.id ?? 0), status: yesterDayLastRecord.status, startTime: currentStartOfDay, endTime: currentDate), at: 0)
            }
            
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
//                // print(" Last row → Day: \(fetchedDay), Shift: \(fetchedShift)")
//            } else {
//                // print(" No rows found for userId: \(userIdValue)")
//                self.lastDay = 1
//                self.lastShift = 1
//            }
//        } catch {
//            // print(" Error fetching last day/shift: \(error)")
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
        isVoilations: Bool = false,
        origin: String,
        notes: String = ""
        //isVoilations: String

    ) {
        var address = ""
        Task { @MainActor in
            address = await SyncViewModel().getLocation()
        }
        
        var originType = origin
        
        // originType will be `Unidentified` when Odometer or Engine hour value is Zero
        if SharedInfoManager.shared.odometer == 0 || SharedInfoManager.shared.engineHours == 0 {
            originType = OriginType.unidentified.description
        }
        AppStorageHandler.shared.origin = originType
        let timestamp = Int64(startTime.timeIntervalSince1970 * 1000)
        
        let log = DriverLogModel(
            id: nil,
            status: status,
            startTime: startTime,
            userId: AppStorageHandler.shared.driverId ?? 0,
            day: AppStorageHandler.shared.days,
            isVoilations: isVoilations ? "YES" : "NO",   //  Actual Bool → Int
            dutyType: dutyType,
            shift: AppStorageHandler.shared.shift,
            vehicle: AppStorageHandler.shared.vehicleNo ?? "",
                //UserDefaults.standard.string(forKey: "truckNo") ?? "Null",
            odometer: SharedInfoManager.shared.odometer,
            engineHours: "\(SharedInfoManager.shared.engineHours)",
            location: address,
            lat: SharedInfoManager.shared.lattitude,
            long: SharedInfoManager.shared.longitude,
            origin: originType,
            isSynced: false,
            vehicleId: AppStorageHandler.shared.vehicleId ?? 0,
                //UserDefaults.standard.integer(forKey: "vehicleId"),
            trailers: UserDefaults.standard.string(forKey: "trailer") ?? "",
            notes: notes,
            serverId: nil,
            timestamp:timestamp,
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
            engineStatus: "Off",
            isSystemGenerated: 0
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
            // print("Identifier updated for \(uniqueId) to \(identifier)")
        } catch {
            // print("failed to update Identifier: \(error)")
        }
    }
    
    func markLogAsSynced(localId: Int64, serverId: String) {
        do {
            let log = driverLogs.filter(id == localId)
            try db?.run(log.update(isSynced <- true, self.serverId <- serverId))
            // print(" Marked localId \(localId) as synced with serverId \(serverId)")
        } catch {
            // print(" Update Sync Status Error: \(error)")
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
            // print(" Update Timer Value Error: \(error)")
        }
    }
}

