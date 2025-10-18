import Foundation

extension HomeViewModel {

    func loadEventsFromDatabase() {
        var logs = DatabaseManager.shared.fetchDutyEventsForToday()
        logs.sort { $0.startTime < $1.startTime }

        //  Add dummy OFF_DUTY if needed
        
        if logs.isEmpty {
            if let startOfDay = "\(DateTimeHelper.currentDate()) 00:00:00".asDate()
            {
                logs.append(DutyLog(
                    id: -999,
                    status: DriverStatusType.offDuty.getName(),
                    startTime: startOfDay,
                    endTime: DateTimeHelper.currentDateTime()
                ))
            }
        }

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


    // MARK: - Timer that updates the last event's end_time every second
//    func startLiveUpdateTimer() {
//        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
//            // Reload from database to get latest status changes
//            self.loadEventsFromDatabase()
//        }
//    }

//    private func normalizeStatus(_ status: String) -> String {
//        switch status {
//        case "OnDuty": return "ON_DUTY"
//        case "OffDuty": return "OFF_DUTY"
//        case "OnSleep": return "SLEEP"
//        case "OnDrive": return "DRIVE"
//        case "PersonalUse": return "PERSONAL_USE"
//        case "YardMove": return "YARD_MOVE"
//        case "ON-DUTY": return "ON_DUTY"
//        case "OFF-DUTY": return "OFF_DUTY"
//        case "SLEEP": return "SLEEP"
//        case "DRIVE": return "DRIVE"
//        case "PERSONAL_USE": return "PERSONAL_USE"
//        case "YARD_MOVE": return "YARD_MOVE"
//        default: return "OFF_DUTY"
//        }
//    }
    
    // MARK: - Force refresh method for immediate chart update
//    func forceRefresh() {
//        loadEventsFromDatabase()
//    }
    
    // MARK: - Update current status and refresh chart
//    func updateStatus(_ newStatus: String) {
//        currentStatus = newStatus
//        loadEventsFromDatabase()
//    }
}
