import Foundation
import SQLite3
import SQLite

extension DatabaseManager {
    
    func insertSplitShiftLog(status: String, time: TimeInterval) {
        guard let db else { return }

        let safeDay = AppStorageHandler.shared.days == 0 ? 1 : AppStorageHandler.shared.days
        let safeShift = AppStorageHandler.shared.shift == 0 ? 1 : AppStorageHandler.shared.shift
        let userId = AppStorageHandler.shared.driverId ?? 0

        do {
            let insert = splitShiftTable.insert(
                self.status <- status,
                self.splitTime <- Double(time),
                self.day <- safeDay,
                self.shift <- safeShift,
                self.userId <- userId
            )
            try db.run(insert)
            
        } catch {
            // print("Insert SplitShift error")
        }
    }

    
    func getLastRecordForSplitShiftLog() -> SplitShiftLog? {
        
        var splitShiftLogs: [SplitShiftLog] = []
        guard let db else { return nil }
        do {
            let query = splitShiftTable.order(self.id.desc).limit(1)
            let result = try db.prepare(query)
            for row in result {
                splitShiftLogs.append(
                    SplitShiftLog(id: Int(row[id]), status: row[status], splitTime: row[splitTime], day: row[day], shift: row[shift], userId: row[userId])
                )
            }
            return splitShiftLogs.first
        } catch {
            // print("Error while fetching the value from split shift log table: \(error)")
            return nil
        }
    }
    //MARK: -  to fetch All data
    func getfetchAllSplitShiftLog() -> [SplitShiftLog] {

        guard let db else { return [] }
        var logs: [SplitShiftLog] = []

        let currentUserId = AppStorageHandler.shared.driverId ?? 0

        do {
            let query = splitShiftTable
                .filter(self.userId == currentUserId)
                .order(self.id.desc)

            for row in try db.prepare(query) {
                logs.append(
                    SplitShiftLog(
                        id: Int(row[id]),
                        status: row[status],
                        splitTime: row[splitTime],
                        day: row[day],
                        shift: row[shift],
                        userId: row[userId]
                    )
                )
            }
        } catch {
            // print("Fetch SplitShift error")
        }
        return logs
    }

    
    
    func updateSplitDurationForID(_ id: Int64, _ duration: Double) {
        guard let db else { return }
        do {
            let update = splitShiftTable.filter(self.id == id).update(self.splitTime <- duration)
            try db.run(update)
        } catch {
            // print("Error while updating the split duration: \(error)")
        }
       
    }
    
    func deleteAllSplitShiftLogs() {
        guard let db else { return }
        do {
            try db.run(splitShiftTable.delete())
        } catch {
            // print("Error while deleting all split shift logs: \(error)")
        }
    }
    
}
