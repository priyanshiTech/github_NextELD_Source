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
    let status: String
    let startTime: Date
    let endTime: Date
}

class DatabaseManager {
    static let shared = DatabaseManager()

    private var db: Connection?
    // Store last row values
    var lastDay: Int = 1
    var lastShift: Int = 1

    // MARK: - Table and Columns
    let driverLogs = Table("driverLogs")
    let id = Expression<Int64>("id")
    let status = Expression<String>("status")
    let startTime = Expression<String>("startTime")
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
                
               // let violationValue = "\((try? row.get(isVoilationColumn)) ?? 0)"
                            
                            //  Print before appending
               // print(" [DB LOG] Status: \(row[status]), isViolation: \(violationValue)")
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

    
    func saveDriverLogsToSQLite(from logs: [DriverLog]) {
        print("Correct!!!!!!!!!!!!!!!! Saving \(logs.count) logs into SQLite")

        for (index, log) in logs.enumerated() {
            
            let originCode = UserDefaults.standard.integer(forKey: "origin") // or from API
            let originValue = OriginType(rawValue: originCode)?.description ?? "Driver" // default

            let model = DriverLogModel(
                id: nil,
                status: log.status ?? "Unknown",
                startTime: log.dateTime ?? "N/A",
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
                timestamp: Int64(log.dateTime ?? "0") ?? 0,
                identifier: log.identifier ?? 0,
                remainingWeeklyTime: log.remainingWeeklyTime ?? 0,
                remainingDriveTime: log.remainingDriveTime ?? 0,
                remainingDutyTime: log.remainingDutyTime ?? 0,
                remainingSleepTime: log.remainingSleepTime ?? 0,
                lastSleepTime: log.lastOnSleepTime ?? 0,
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
            
            let safeDay = model.day == 0 ? self.lastDay : model.day
            let safeShift = model.shift == 0 ? self.lastShift : model.shift
            
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
                lastSleepTime <- model.lastSleepTime,
                isSplit <- model.isSplit,
                engineStatus <- model.engineStatus
            )
            
            let rowID = try db?.run(insert) ?? 0
            print(" Log inserted into SQLite with ID: \(rowID) — \(model.status) at \(model.startTime)")

            //  Update lastDay & lastShift after every insert
            self.updateLastDayAndShift(for: model.userId)
            print("👉 Last Day: \(DatabaseManager.shared.lastDay)")
            print("👉 Last Shift: \(DatabaseManager.shared.lastShift)")
        } catch {
            print(" Insert Log Error: \(error.localizedDescription)")
        }
    }

    


    
    //MARK: -  TO DELETE ALL SAVED DATA IN DBMS

    func deleteAllLogs() {
        do {
            try db?.run(driverLogs.delete()) //  Uses the same table instance you declared at top
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
                       
                        print("Graph LOG: \(statusValue) Start Date : \(startDate)")
                        print("Graph LOG: \(statusValue) End Date : \(startDate)")
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

    //MARK: - Fetch last recent Day & Shift from DB


extension DatabaseManager {
    //MARK: - Fetch last recent Day & Shift from DB
    func updateLastDayAndShift(for userIdValue: Int) {
        guard let db = db else { return }
        do {
            if let row = try db.pluck(
                driverLogs
                    .filter(userId == userIdValue)
                    .order(timestamp.desc)
                    .limit(1)
            ) {
                var fetchedDay = row[day]
                var fetchedShift = row[shift]

                //  Default handling: agar 0 ya blank aaye to 1 set karo
                if fetchedDay == 0 { fetchedDay = 1 }
                if fetchedShift == 0 { fetchedShift = 1 }

                // Save to properties
                self.lastDay = fetchedDay
                self.lastShift = fetchedShift

                print(" Last row → Day: \(fetchedDay), Shift: \(fetchedShift)")
            } else {
                print(" No rows found for userId: \(userIdValue)")
                self.lastDay = 1
                self.lastShift = 1
            }
        } catch {
            print(" Error fetching last day/shift: \(error)")
            self.lastDay = 1
            self.lastShift = 1
        }
    }
}

 

extension DatabaseManager {
    
    func saveTimerLog(
        status: String,
        startTime: String,
        dutyType: String,
        remainingWeeklyTime: Int,
        remainingDriveTime: Int,
        remainingDutyTime: Int,
        remainingSleepTime: Int,
        lastSleepTime: Int,
        RemaningRestBreak: String,
        isruning: Bool,
        isVoilations: Bool = false
        //isVoilations: String

    ) {
        let log = DriverLogModel(
            id: nil,
            status: status,
            startTime: startTime,
            userId: UserDefaults.standard.integer(forKey: "userId"),
            day: UserDefaults.standard.integer(forKey: "day"),
            isVoilations: isVoilations ? 1 : 0,   //  Actual Bool → Int
            dutyType: dutyType,
            shift: UserDefaults.standard.integer(forKey: "shift"),
            vehicle: UserDefaults.standard.string(forKey: "truckNo") ?? "Null",
            isRunning: isruning,
            odometer: 0.0,
            engineHours: "0",
            location: UserDefaults.standard.string(forKey: "customLocation") ?? "",
            lat: Double(UserDefaults.standard.string(forKey: "lattitude") ?? "") ?? 0,
            long: Double(UserDefaults.standard.string(forKey: "longitude") ?? "") ?? 0,
            origin: DriverInfo.origins                                                   /*UserDefaults.standard.string(forKey: "origin") ?? "Null"*/,
            isSynced: false,
            vehicleId: UserDefaults.standard.integer(forKey: "vehicleId"),
            trailers: UserDefaults.standard.string(forKey: "trailer") ?? "",
            notes: "",
            serverId: nil,
            timestamp:TimeUtils.currentTimestamp(with: DriverInfo.timeZoneOffset),
              //CurrentTimeHelperStamp.currentTimestamp,
            // Int64(Date().timeIntervalSince1970),
            identifier: 0,
            remainingWeeklyTime: remainingWeeklyTime,
            remainingDriveTime: remainingDriveTime,
            remainingDutyTime: remainingDutyTime,
            remainingSleepTime: remainingSleepTime,
            lastSleepTime: lastSleepTime,
            isSplit: 0,
            engineStatus: "Off", isCertifiedLog: ""
            
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
        let lastSleepTime: Int
        let isSplit: Int
        let engineStatus: String
        let isCertifiedLog: String
        
        //Show latest

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
    //MARK: - - SAVE And updated
extension DatabaseManager {
    func updateDayShiftInDB(day: Int, shift: Int, userId: Int) {
        guard let db = db else { return }
        
        do {
            if let row = try db.pluck(
                driverLogs
                    .filter(self.userId == userId)
                    .order(timestamp.desc)
                    .limit(1)
            ) {
                let logId = row[id]
                let log = driverLogs.filter(id == logId)
                
                try db.run(log.update(self.day <- day, self.shift <- shift))
                print(" DB Updated → Day: \(day), Shift: \(shift) for logId: \(logId)")
                
                // keep DatabaseManager cache also updated
                self.lastDay = day
                self.lastShift = shift
            } else {
                print(" No recent row found to update Day/Shift")
            }
        } catch {
            print(" Error updating day/shift in DB: \(error)")
        }
    }
}

    //MARK++++++++++++++++++for hours recap

extension DatabaseManager {
    func fetchWorkEntriesLast7Days() -> [WorkEntry] {
        let calendar = Calendar.current
        let today = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        df.locale = Locale(identifier: "en_US_POSIX")
        df.timeZone = .current

        // Fetch all logs
        let allLogs = fetchLogs()

        var results: [WorkEntry] = []

        for offset in (-6...0) {
            guard let day = calendar.date(byAdding: .day, value: offset, to: today) else { continue }
            let startOfDay = calendar.startOfDay(for: day)
            let startOfNextDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

            // Filter logs for this day
            let logsForDay = allLogs.compactMap { log -> (Date, String)? in
                guard let startDate = df.date(from: log.startTime) else { return nil }
                return (startDate, log.status)
            }
            .filter { $0.0 >= startOfDay && $0.0 < startOfNextDay }
            .sorted { $0.0 < $1.0 }

            var dutySeconds: TimeInterval = 0

            for (i, log) in logsForDay.enumerated() {
                let startDate = log.0
                let status = log.1

                let endDate: Date
                if i + 1 < logsForDay.count {
                    endDate = logsForDay[i+1].0
                } else {
                    endDate = calendar.isDateInToday(day) ? Date() : startOfNextDay
                }

                let duration = max(0, endDate.timeIntervalSince(startDate))

                if status == "OnDuty" || status == "OnDrive" {
                    dutySeconds += duration
                } else if status == "OffDuty" || status == "OnSleep" {
                    // optional split rule: short off-duty counts as duty
                    if duration <= 2 * 3600 {
                        dutySeconds += duration
                    }
                }
            }

            results.append(WorkEntry(date: day, hoursWorked: dutySeconds))
        }

        return results.sorted { $0.date < $1.date }
    }
    func totalWorkedHours(for day: Date) -> TimeInterval {
            let calendar = Calendar.current
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            df.locale = Locale(identifier: "en_US_POSIX")
            df.timeZone = .current

            let allLogs = fetchLogs()
            let startOfDay = calendar.startOfDay(for: day)
            let startOfNextDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

            let logsForDay = allLogs.compactMap { log -> (Date, String)? in
                guard let startDate = df.date(from: log.startTime) else { return nil }
                return (startDate, log.status)
            }
            .filter { $0.0 >= startOfDay && $0.0 < startOfNextDay }
            .sorted { $0.0 < $1.0 }

            var dutySeconds: TimeInterval = 0

            for (i, log) in logsForDay.enumerated() {
                let startDate = log.0
                let status = log.1

                let endDate: Date
                if i + 1 < logsForDay.count {
                    endDate = logsForDay[i+1].0
                } else {
                    endDate = calendar.isDateInToday(day) ? Date() : startOfNextDay
                }

                let duration = max(0, endDate.timeIntervalSince(startDate))

                if status == "OnDuty" || status == "OnDrive" {
                    dutySeconds += duration
                } else if status == "OffDuty" || status == "OnSleep" {
                    if duration <= 2 * 3600 { dutySeconds += duration }
                }
            }
            return dutySeconds
        }

    /// Hours available today = 14h limit - worked hours
        func availableHoursToday() -> TimeInterval {
            let worked = totalWorkedHours(for: Date())
            let limit: TimeInterval = 14 * 3600
            return max(0, limit - worked)
        }
        /// Helper to format TimeInterval → HH:mm:ss
        func formatTime(_ seconds: TimeInterval) -> String {
            let hrs = Int(seconds) / 3600
            let mins = (Int(seconds) % 3600) / 60
            let secs = Int(seconds) % 60
            return String(format: "%02d:%02d:%02d", hrs, mins, secs)
        }
    // for 70 hours
    
    // Cycle available hours = 60h/7days
    func availableCycleHours(days: Int = 7, limitHours: Int = 70) -> TimeInterval {
        let calendar = Calendar.current
        let today = Date()
        
        guard let startDate = calendar.date(byAdding: .day, value: -(days - 1), to: today) else {
            return 0
        }
        
        // fetch last N days logs
        let logs = fetchLogs()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        df.locale = Locale(identifier: "en_US_POSIX")
        df.timeZone = .current
        
        // Convert and filter logs
        let logsForRange = logs.compactMap { log -> (Date, String)? in
            guard let startDateLog = df.date(from: log.startTime) else { return nil }
            return (startDateLog, log.status)
        }
        .filter { $0.0 >= startDate } // only last N days
        .sorted { $0.0 < $1.0 }
        
        // Calculate duty seconds
        var dutySeconds: TimeInterval = 0
        for (i, log) in logsForRange.enumerated() {
            let startDateLog = log.0
            let status = log.1
            
            let endDate: Date
            if i + 1 < logsForRange.count {
                endDate = logsForRange[i+1].0
            } else {
                endDate = Date()
            }
            
            let duration = max(0, endDate.timeIntervalSince(startDateLog))
            
            if status == "OnDuty" || status == "OnDrive" {
                dutySeconds += duration
            } else if status == "OffDuty" || status == "OnSleep" {
                if duration <= 2 * 3600 { dutySeconds += duration }
            }
        }
        // Cycle rule: 60h/7days
        let cycleLimit: TimeInterval = TimeInterval(limitHours * 3600)
        return max(0, cycleLimit - dutySeconds)
    }
  
}

//MARK: - - SAVE And updated
extension DatabaseManager {

    //MARK: -  to show a voilations today helping function in once a time
      func hasViolationForToday(violationType: String) -> Bool {
           guard let db = db else { return false }

           do {
               // Get today's date string
               let formatter = DateFormatter()
               formatter.dateFormat = "yyyy-MM-dd"
               let todayString = formatter.string(from: Date())

               // Check if there's already a violation for today with the same type
               let query = driverLogs.filter(
                   isVoilationColumn == 1 &&
                   status == "Violation" &&
                   dutyType.like("%\(violationType)%") &&
                   startTime.like("\(todayString)%")
               )

               let count = try db.scalar(query.count)
               print("Found \(count) violations for today with type: \(violationType)")
               return count > 0

           } catch {
               print("Error checking violation for today: \(error)")
               return false
           }
       }

    
    
    func updateVoilation(isVoilation: Bool , DutyType: String) {
        let voilationValue = isVoilation ? 1 : 0
        guard let db = db else { return }
        do {
            if let row = try db.pluck(
                driverLogs
                    .order(timestamp.desc)
                    .limit(1)
            ) {
                let logId = row[id]
                let log = driverLogs.filter(id == logId)
                
                try db.run(log.update(self.isVoilationColumn <- voilationValue, self.status <- status))
                print(" DB Updated → voilation")
                
            } else {
                print(" No recent row found to update Day/Shift")
            }
        } catch {
            print(" Error updating day/shift in DB: \(error)")
        }
    }
   
    
    // Add these methods inside the DatabaseManager extension (after hasViolationForToday)

    func hasWarningForToday(warningType: String) -> Bool {
        guard let db = db else { return false }
        
        do {
            // Get today's date string
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let todayString = formatter.string(from: Date())
            
            // Check if there's already a warning for today with the same type
            let query = driverLogs.filter(
                isVoilationColumn == 0 &&
                status == "Warning" &&
                dutyType.like("%\(warningType)%") &&
                startTime.like("\(todayString)%")
            )
            
            let count = try db.scalar(query.count)
            print("Found \(count) warnings for today with type: \(warningType)")
            return count > 0
            
        } catch {
            print("Error checking warning for today: \(error)")
            return false
        }
    }

    func hasAnyViolationOrWarningForToday() -> (hasViolation: Bool, has30MinWarning: Bool, has15MinWarning: Bool) {
        guard let db = db else { return (false, false, false) }
        
        do {
            // Get today's date string
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let todayString = formatter.string(from: Date())
            
            // Check for violations
            let violationQuery = driverLogs.filter(
                isVoilationColumn == 1 &&
                status == "Violation" &&
                startTime.like("\(todayString)%")
            )
            let violationCount = try db.scalar(violationQuery.count)
            
            // Check for 30min warnings
            let warning30Query = driverLogs.filter(
                isVoilationColumn == 0 &&
                status == "Warning" &&
                dutyType.like("%30 minutes%") &&
                startTime.like("\(todayString)%")
            )
            let warning30Count = try db.scalar(warning30Query.count)
            
            // Check for 15min warnings
            let warning15Query = driverLogs.filter(
                isVoilationColumn == 0 &&
                status == "Warning" &&
                dutyType.like("%15 minutes%") &&
                startTime.like("\(todayString)%")
            )
            let warning15Count = try db.scalar(warning15Query.count)
            
            return (
                hasViolation: violationCount > 0,
                has30MinWarning: warning30Count > 0,
                has15MinWarning: warning15Count > 0
            )
            
        } catch {
            print("Error checking violations/warnings for today: \(error)")
            return (false, false, false)
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
                startTime >= startOfYesterdayString &&
                startTime < endOfYesterdayString
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
                startTime >= startOfYesterdayString &&
                startTime < endOfYesterdayString &&
                status == "OffDuty"
            )
            
            var hasLongOffDuty = false
            let offDutyLogs = try db.prepare(offDutyQuery)
            
            for log in offDutyLogs {
                let startTimeString = log[startTime]
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                formatter.timeZone = TimeZone.current
                
                if let startDate = formatter.date(from: startTimeString) {
                    // Calculate duration from start time to now (or next log)
                    let duration = Date().timeIntervalSince(startDate)
                    let hours = duration / 3600
                    
                    print("Off Duty log started at: \(startTimeString), Duration: \(hours) hours")
                    
                    if hours >= 10 {
                        hasLongOffDuty = true
                        print("Found Off Duty longer than 10 hours!")
                        break
                    }
                }
            }
            
            // Check certification status using existing fields
            // Since we don't have isCertifiedLog column, we'll use a workaround
            
            // Option 1: Check if all previous day logs have notes (assuming certified logs have notes)
            let certifiedQuery = driverLogs.filter(
                startTime >= startOfYesterdayString &&
                startTime < endOfYesterdayString &&
                notes != ""  // Non-empty notes might indicate certification
            )
            let certifiedCount = try db.scalar(certifiedQuery.count)
            print("Found \(certifiedCount) logs with notes (possibly certified)")
            
            // Option 2: Check sync status (certified logs should be synced)
            let syncedQuery = driverLogs.filter(
                startTime >= startOfYesterdayString &&
                startTime < endOfYesterdayString &&
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


