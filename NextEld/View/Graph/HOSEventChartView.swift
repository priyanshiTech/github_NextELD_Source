
import SwiftUI

// MARK: - Data Model
struct HOSEvent: Identifiable {
    let id: Int
    let x: Date
    let event_end_time: Date
    let dutyType: DriverStatusType
    var color: Color {
        switch dutyType {
        case .onDuty:
            return .blue
        case .offDuty:
            return .orange
        case .onDrive:
            return .green
        case .sleep:
            return .gray
        case .personalUse:
            return .orange
        case .yardMode:
            return .blue
        case .none:
            return .gray
        }
    }
}


//class HOSEventsChartViewModel: ObservableObject {
//    
//    @Published var events: [HOSEvent] = []
//    @Published var refreshTrigger = UUID()
//    @Published var currentStatus: String = "OFF_DUTY"
//
//    private var timer: Timer?
//
//    init(initialEvents: [HOSEvent]? = nil) {
//        if let events = initialEvents {
//            self.events = events
//        } else {
//            loadEventsFromDatabase()
//        }
//
//        // MARK: -  Start live refresh
//        startLiveUpdateTimer()
//    }
//
//    func loadEventsFromDatabase() {
//        var logs = DatabaseManager.shared.fetchDutyEventsForToday()
//        logs.sort { $0.startTime < $1.startTime }
//
//        //  Add dummy OFF_DUTY if needed
//        
//        if logs.isEmpty {
//            if let startOfDay = "\(DateTimeHelper.currentDate()) 00:00:00".asDate()
//            {
//                logs.append(DutyLog(
//                    id: -999,
//                    status: "OFF_DUTY",
//                    startTime: startOfDay,
//                    endTime: DateTimeHelper.currentDateTime()
//                ))
//            }
//        }
//
//        self.events = logs.enumerated().map { index, log in
//            let normalizedStatus = normalizeStatus(log.status)
//            var endDate = DateTimeHelper.currentDateTime()
//            if !(index == logs.count-1) {
//                let nextIndexLog = logs[index+1]
//                endDate = nextIndexLog.startTime
//            }
//            
//            print(" Chart Event: \(log.status) -> \(normalizedStatus) (Color: \(normalizedStatus == "OFF_DUTY" ? "Orange" : normalizedStatus == "ON_DUTY" ? "Blue" : normalizedStatus == "DRIVE" ? "Green" : "Gray"))")
//            
//            return HOSEvent(
//                id: log.id,
//                x: log.startTime,
//                event_end_time: endDate,
//                dutyType: normalizedStatus
//            )
//        }
//
//        // Force immediate UI update
//        DispatchQueue.main.async {
//            self.refreshTrigger = UUID()
//        }
//    }
//
//
//    // MARK: - Timer that updates the last event's end_time every second
//    func startLiveUpdateTimer() {
//        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
//            // Reload from database to get latest status changes
//            self.loadEventsFromDatabase()
//        }
//    }
//
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
//    
//    // MARK: - Force refresh method for immediate chart update
////    func forceRefresh() {
////        loadEventsFromDatabase()                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
////    }
////    
////    // MARK: - Update current status and refresh chart
////    func updateStatus(_ newStatus: String) {
////        currentStatus = newStatus
////        loadEventsFromDatabase()
////    }
//}
                          

// MARK: - Grid Lines View
struct GridLinesView: View {
    let width: CGFloat
    let height: CGFloat
    let hourWidth: CGFloat
    
    var body: some View {
        Canvas { context, size in
            // Draw vertical hour lines
            for hour in 0...24 {
                let x = CGFloat(hour) * hourWidth
                let path = Path { path in
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: height))
                }
                context.stroke(path, with: .color(.gray.opacity(0.4)), lineWidth: 1)
            }
            
            // Draw horizontal lines
            for row in 0...4 {
                let y = CGFloat(row) * (height / 4.0)
                let path = Path { path in
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: width, y: y))
                }
                context.stroke(path, with: .color(.gray.opacity(0.3)), lineWidth: 0.5)
            }
            
            // Draw quarter hour marks with precise positioning
            for hour in 0..<24 {
                let hourX = CGFloat(hour) * hourWidth
                for quarter in 1...3 {
                    let x = hourX + (hourWidth * CGFloat(quarter) / 4.0)
                    let quarterHeight: CGFloat = quarter == 2 ? 10 : 2
                    
                    for row in 0..<4 {
                        let sectionStart = CGFloat(row) * (height / 4.0)
                        let path = Path { path in
                            path.move(to: CGPoint(x: x, y: sectionStart + height / 3.0))
                            path.addLine(to: CGPoint(x: x, y: sectionStart + height / 4.0 - quarterHeight))
                        }
                        context.stroke(path, with: .color(.black), lineWidth: 0.5)
                    }
                }
            }
        }
    }
}





struct DutyLinePathView: View {
    let events: [HOSEvent]
    let levelMap: [String: Int]
    let rowHeight: CGFloat
    let hourWidth: CGFloat

    private func yPositionForLevel(_ level: Int) -> CGFloat {
        CGFloat(level) * rowHeight + rowHeight / 2
    }

    func minutesSinceMidnight(_ date: Date) -> Int? {
        let calendar = DateTimeHelper.calendar
        
        let components = calendar.dateComponents([.hour, .minute], from: date)
        guard let hour = components.hour, let minute = components.minute else { return nil }
        return (hour * 60) + minute
    }
    func secondsSinceMidnight(_ date: Date) -> Int? {
        let calendar = DateTimeHelper.calendar
        let comps = calendar.dateComponents([.hour, .minute, .second], from: date)
        guard let h = comps.hour, let m = comps.minute, let s = comps.second else { return nil }
        return h * 3600 + m * 60 + s
    }


    private func getStatusLabel(_ dutyType: DriverStatusType) -> String {
        switch dutyType {
        case .onDuty: return "ON"
        case .onDrive: return "D"
        case .sleep: return "SB"
        case .offDuty: return "OF"
        default: return "OF"
        }
    }

    private func colorForDutyType(_ dutyType: String) -> Color {
        switch dutyType {
        case "OFF_DUTY": return .orange
        case "ON_DUTY": return .blue
        case "DRIVE": return .green
        case "SLEEP": return .gray
        default: return .gray
        }
    }

    private func isPersonalUse(_ event: HOSEvent) -> Bool {
        // Check if the event is Personal Use
        return event.dutyType == .personalUse
    }
    
    private func isYardMove(_ event: HOSEvent) -> Bool {
        // Check if the event is Yard Move
        return event.dutyType == .yardMode
    }

    var body: some View {
        Canvas { context, size in
            let sortedEvents = events.sorted { $0.x < $1.x }
            guard !sortedEvents.isEmpty else { return }

            var lastPoint: CGPoint? = nil

            for event in sortedEvents {
                guard
                    let startMin = minutesSinceMidnight(event.x),
                    let endMin = minutesSinceMidnight(event.event_end_time)
                else { continue }
                
                // Map Personal Use and Yard Move to OFF_DUTY level (row 0)
                let level: Int
                if isPersonalUse(event) || isYardMove(event) {
                    level = levelMap["OF"] ?? 0
                } else {
                    level = levelMap[getStatusLabel(event.dutyType)] ?? 0
                }

                let startX = CGFloat(startMin) * (hourWidth / 60)
                let endX = CGFloat(endMin) * (hourWidth / 60)
                let y = yPositionForLevel(level)

                var segmentPath = Path()

                if let last = lastPoint {
                    // horizontal from last point to this start
                    segmentPath.move(to: last)
                    segmentPath.addLine(to: CGPoint(x: startX, y: last.y))
                    //  vertical to new level if changed
                    if last.y != y {
                        segmentPath.addLine(to: CGPoint(x: startX, y: y))
                    }
                    //horizontal segment for current event
                    segmentPath.addLine(to: CGPoint(x: endX, y: y))
                    } else {
                    //  segment
                    segmentPath.move(to: CGPoint(x: startX, y: y))
                    segmentPath.addLine(to: CGPoint(x: endX, y: y))
                    }

                lastPoint = CGPoint(x: endX, y: y)
                // Draw the line with appropriate color and style
                if isPersonalUse(event) {
                    context.stroke(
                        segmentPath,
                        with: .color(.orange),
                        style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [5, 3])
                    )
                } else if isYardMove(event) {
                    context.stroke(
                        segmentPath,
                        with: .color(.blue),
                        style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [5, 3])
                    )
                } else {
                    context.stroke(
                        segmentPath,
                        with: .color(event.color),
                        style: StrokeStyle(lineWidth: 2, lineCap: .round)
                    )
                }
            }
        }
    }
}




// Add safe array access extension
extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// MARK: - Chart View
struct HOSEventsChart: View {
    let events: [HOSEvent]
    let rowHeight: CGFloat = 35  // Restored original row height
    
    private let dutyLabels = ["OF", "SB", "D", "ON"]
    private let levelMap = ["OF": 0, "SB": 1, "D": 2, "ON": 3]
    
    // Calculate durations for each duty type
    private func calculateDurations() -> [String: TimeInterval] {
        var durations: [String: TimeInterval] = [:]
        for event in events {
            let duration = event.event_end_time.timeIntervalSince(event.x)
            
            // Group Personal Use and Yard Move with OFF_DUTY
            let label: String
            if event.dutyType == .personalUse || event.dutyType == .yardMode {
                label = "OF"  // Group with OFF_DUTY
            } else {
                label = getStatusLabel(event.dutyType)
            }
            
            durations[label, default: 0] += duration
            print("***************** Duration for \(event.dutyType) -> \(label): \(formatDuration(duration))")
        }
        
        // Debug: Print final durations
        for (label, duration) in durations {
            print(" Total \(label): \(formatDuration(duration))")
        }
        
        return durations
    }
    
    // Format duration as HH:mm
    private func formatDuration(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval / 3600)
        let minutes = Int((timeInterval.truncatingRemainder(dividingBy: 3600)) / 60)
        return String(format: "%02d:%02d", hours, minutes)
    }
    
    private func getStatusLabel(_ dutyType: DriverStatusType) -> String {
        switch dutyType {
        case .onDuty: return "ON"
        case .onDrive: return "D"
        case .sleep: return "SB"
        case .offDuty: return "OF"
        default: return "OF"
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width
            let labelWidth: CGFloat = 25  // Reduced label width
            let durationWidth: CGFloat = 40  // Reduced duration width
            let rightPadding: CGFloat = 5  // Reduced padding
            let availableWidth = totalWidth - labelWidth - durationWidth - rightPadding
            let hourWidth = availableWidth / 24  // Distribute width evenly
            
            HStack(spacing: 5) {
                // Left labels
                VStack(alignment: .trailing, spacing: 0) {
                    // Spacer for hours
                    Color.clear
                        .frame(height: 15)  // Reduced height for hour labels
                    
                    ForEach(dutyLabels, id: \.self) { label in
                        Text(label)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.blue)
                            .frame(height: rowHeight)
                    }
                }
                .frame(width: labelWidth)
                
                // Main graph area
                VStack(spacing: 0) {
                    // Hours row
                    HStack(spacing: 0) {
                        ForEach(0..<24) { hour in
                            Text(String(format: "%02d", hour))
                                .font(.system(size: 5, weight: .medium))
                                .foregroundColor(.blue)
                                .frame(width: hourWidth, alignment: .center)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .frame(height: 15)
                    
                    // Grid and events
                    ZStack {
                        Rectangle()
                            .fill(Color.white)
                        
                        // Grid lines
                        GridLinesView(width: hourWidth * 24, height: rowHeight * 4, hourWidth: hourWidth)
                        
                        // Event blocks
                        DutyLinePathView(events: events, levelMap: levelMap, rowHeight: rowHeight, hourWidth: hourWidth)
                    }
                    .frame(height: rowHeight * 4)
                    .overlay(
                        Rectangle()
                            .stroke(Color.black, lineWidth: 1)
                    )
                }
                .frame(width: hourWidth * 24)
                
                // Duration labels
                VStack(alignment: .leading, spacing: 0) {
                    // Spacer for hours
                    Color.clear
                        .frame(height: 15)  //Reduced height for hour labels
                    
                    let durations = calculateDurations()
                    ForEach(dutyLabels, id: \.self) { label in
                        Text(formatDuration(durations[label] ?? 0))
                            .font(.system(size: 8))
                            .foregroundColor(.black)
                            .frame(height: rowHeight)
                    }
                }
                .frame(width: durationWidth)
                
                if rightPadding > 0 {
                    Spacer()
                        .frame(width: rightPadding)
                }
            }
        }
        .frame(height: (rowHeight * 4) + 17)  // Adjusted total height with smaller hour label space
    }
}

// MARK: - Main Container View
struct HOSEventsChartScreen: View {
    let events: [HOSEvent]

    var body: some View {
        VStack(spacing: 6) {  //MARK: -  Reduced spacing
            Text("Hours Of Service")
                .font(.title3)
                .bold()
            
            Text("Time in Hours")
                .font(.caption)
                .foregroundColor(.gray)

            
            //MARK: -    HOSEventsChart(events: viewModel.events)
            HOSEventsChart(events: events)
                .padding(.horizontal, 4)
           
        }
        .padding(8)  // Reduced padding
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 1)
    }
    
}

extension Date {
    func toLocalString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
}





























































































































