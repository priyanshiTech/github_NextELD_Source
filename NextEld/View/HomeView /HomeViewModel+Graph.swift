import Foundation

extension HomeViewModel {

    func loadEventsFromDatabase() {
        var logs = DatabaseManager.shared.fetchDutyEventsForToday()
        logs.sort { $0.startTime < $1.startTime }

        self.graphEvents = logs.enumerated().map { index, log in
            let status = DriverStatusType(fromName: log.status) ?? .offDuty
            var endDate = DateTimeHelper.currentDateTime()
            if !(index == logs.count-1) {
                let nextIndexLog = logs[index+1]
                endDate = nextIndexLog.startTime
            }
            
            return HOSEvent(
                id: log.id,
                x: log.startTime,
                event_end_time: endDate,
                dutyType: status
            )
        }
    }
}
   
