
import SwiftUI

// MARK: - Data Model
struct HOSEvent: Identifiable {
    let id: Int
    let x: Date
    let event_end_time: Date
    let label: String
    let dutyType: String
    var color: Color {
        switch dutyType {
        case "OFF_DUTY": return Color(red: 0.2, green: 0.6, blue: 1.0)  // Light blue
        case "SLEEP": return Color(red: 0.0, green: 0.4, blue: 0.8)     // Dark blue
        case "DRIVE": return Color(red: 1.0, green: 0.6, blue: 0.0)     // Orange
        case "ON_DUTY": return Color(red: 0.9, green: 0.5, blue: 0.0)   // Dark orange
        default: return Color(red: 0.7, green: 0.7, blue: 0.7)          // Gray
        }
    }
}


class HOSEventsChartViewModel: ObservableObject {
    @Published var events: [HOSEvent] = []
    @Published var refreshTrigger = UUID()

    private var timer: Timer?

    init(initialEvents: [HOSEvent]? = nil) {
        if let events = initialEvents {
            self.events = events
        } else {
            loadEventsFromDatabase()
        }

        // MARK: -  Start live refresh
        startLiveUpdateTimer()
    }

    func loadEventsFromDatabase() {
        var logs = DatabaseManager.shared.fetchDutyEventsForToday()
        logs.sort { $0.startTime < $1.startTime }

        // 🟧 Add dummy OFF_DUTY if needed
        if let first = logs.first {
            let startOfDay = Calendar.current.startOfDay(for: Date())
            if first.startTime > startOfDay {
                logs.insert(DutyLog(
                    id: -999,
                    status: "OFF_DUTY",
                    startTime: startOfDay,
                    endTime: first.startTime
                ), at: 0)
            }
        }

        self.events = logs.map { log in
            let normalizedStatus = normalizeStatus(log.status)
            return HOSEvent(
                id: log.id,
                x: log.startTime,
                event_end_time: log.endTime ?? Date(), //  for last active event
                label: normalizedStatus,
                dutyType: normalizedStatus
            )
        }

        refreshTrigger = UUID()
    }

    // MARK: - Timer that updates the last event's end_time every second
    func startLiveUpdateTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            guard !self.events.isEmpty else { return }

            var updatedEvents = self.events
            var last = updatedEvents.removeLast()

            // Live update end_time of last event if it's today
            if Calendar.current.isDateInToday(last.x) {
                last = HOSEvent(
                    id: last.id,
                    x: last.x,
                    event_end_time: Date(), //  NOW
                    label: last.label,
                    dutyType: last.dutyType
                )
                updatedEvents.append(last)

                DispatchQueue.main.async {
                    self.events = updatedEvents
                    self.refreshTrigger = UUID() //  Redraw chart
                }
            }
        }
    }

    private func normalizeStatus(_ status: String) -> String {
        switch status.uppercased() {
        case "ON-DUTY": return "ON_DUTY"
        case "OFF-DUTY": return "OFF_DUTY"
        case "SLEEP": return "SLEEP"
        case "DRIVE": return "DRIVE"
        default: return "OFF_DUTY"
        }
    }
}
                          

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




//struct DutyLinePathView: View {
//    let events: [HOSEvent]
//    let levelMap: [String: Int]
//    let rowHeight: CGFloat
//    let hourWidth: CGFloat
//
//    private func yPositionForLevel(_ level: Int) -> CGFloat {
//        CGFloat(level) * rowHeight + rowHeight / 2
//    }
//
//    func minutesSinceMidnight(_ date: Date) -> Int? {
//        let calendar = Calendar.current
//        let components = calendar.dateComponents([.hour, .minute], from: date)
//        guard let hour = components.hour, let minute = components.minute else { return nil }
//        return (hour * 60) + minute
//    }
//
//    private func normalizeLabel(_ label: String) -> String {
//        switch label {
//        case "ON_DUTY": return "ON"
//        case "DRIVE": return "D"
//        case "SLEEP": return "SB"
//        case "OFF_DUTY": return "OF"
//        default: return "OF"
//        }
//    }
//
//    private func colorForDutyType(_ dutyType: String) -> Color {
//        switch dutyType {
//        case "ON_DUTY": return .blue
//        case "OFF_DUTY": return .orange
//        case "SLEEP": return .gray
//        case "DRIVE": return .green
//        default: return .black
//        }
//    }
//
//    var body: some View {
//        Canvas { context, size in
//            let sortedEvents = events.sorted { $0.x < $1.x }
//            guard !sortedEvents.isEmpty else { return }
//
//            var lastPoint: CGPoint? = nil
//            var lastLevel: Int? = nil
//
//            for event in sortedEvents {
//                guard
//                    let startMin = minutesSinceMidnight(event.x),
//                    let endMin = minutesSinceMidnight(event.event_end_time),
//                    let level = levelMap[normalizeLabel(event.label)]
//                else { continue }
//
//                let startX = CGFloat(startMin) * (hourWidth / 60)
//                let endX = CGFloat(endMin) * (hourWidth / 60)
//                let y = yPositionForLevel(level)
//                let color = colorForDutyType(event.dutyType)
//
//                var segmentPath = Path()
//
//                if let last = lastPoint {
//                    // Step 1: horizontal from last point to this start
//                    segmentPath.move(to: last)
//                    segmentPath.addLine(to: CGPoint(x: startX, y: last.y))
//
//                    // Step 2: vertical to new level if changed
//                    if last.y != y {
//                        segmentPath.addLine(to: CGPoint(x: startX, y: y))
//                    }
//
//                    // Step 3: horizontal segment for current event
//                    segmentPath.addLine(to: CGPoint(x: endX, y: y))
//                } else {
//                    // First segment
//                    segmentPath.move(to: CGPoint(x: startX, y: y))
//                    segmentPath.addLine(to: CGPoint(x: endX, y: y))
//                }
//
//                lastPoint = CGPoint(x: endX, y: y)
//                lastLevel = level
//
//                context.stroke(segmentPath, with: .color(color), style: StrokeStyle(lineWidth: 2, lineCap: .round))
//            }
//        }
//    }
//}

struct DutyLinePathView: View {
    let events: [HOSEvent]
    let levelMap: [String: Int]
    let rowHeight: CGFloat
    let hourWidth: CGFloat

    private func yPositionForLevel(_ level: Int) -> CGFloat {
        CGFloat(level) * rowHeight + rowHeight / 2
    }

    func minutesSinceMidnight(_ date: Date) -> Int? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        guard let hour = components.hour, let minute = components.minute else { return nil }
        return (hour * 60) + minute
    }

    private func normalizeLabel(_ label: String) -> String {
        switch label {
        case "ON_DUTY": return "ON"
        case "DRIVE": return "D"
        case "SLEEP": return "SB"
        case "OFF_DUTY": return "OF"
        default: return "OF"
        }
    }

    private func colorForDutyType(_ dutyType: String) -> Color {
        switch dutyType {
        case "ON_DUTY": return .blue
        case "OFF_DUTY": return .orange
        case "SLEEP": return .gray
        case "DRIVE": return .green
        default: return .black
        }
    }

    private func isPersonalUse(_ event: HOSEvent) -> Bool {
        // ✅ Customize this condition as per your database flag
        // Example: If dutyType == "OFF_DUTY" and label contains "Personal Use"
        return event.dutyType == "OFF_DUTY" && event.label.localizedCaseInsensitiveContains("Personal")
    }

    var body: some View {
        Canvas { context, size in
            let sortedEvents = events.sorted { $0.x < $1.x }
            guard !sortedEvents.isEmpty else { return }

            var lastPoint: CGPoint? = nil

            for event in sortedEvents {
                guard
                    let startMin = minutesSinceMidnight(event.x),
                    let endMin = minutesSinceMidnight(event.event_end_time),
                    let level = levelMap[normalizeLabel(event.label)]
                else { continue }

                let startX = CGFloat(startMin) * (hourWidth / 60)
                let endX = CGFloat(endMin) * (hourWidth / 60)
                let y = yPositionForLevel(level)

                var segmentPath = Path()

                if let last = lastPoint {
                    // Step 1: horizontal from last point to this start
                    segmentPath.move(to: last)
                    segmentPath.addLine(to: CGPoint(x: startX, y: last.y))

                    // Step 2: vertical to new level if changed
                    if last.y != y {
                        segmentPath.addLine(to: CGPoint(x: startX, y: y))
                    }

                    // Step 3: horizontal segment for current event
                    segmentPath.addLine(to: CGPoint(x: endX, y: y))
                } else {
                    // First segment
                    segmentPath.move(to: CGPoint(x: startX, y: y))
                    segmentPath.addLine(to: CGPoint(x: endX, y: y))
                }

                lastPoint = CGPoint(x: endX, y: y)

                // ✅ Use dashed blue style for Personal Use, otherwise normal
                if isPersonalUse(event) {
                    context.stroke(
                        segmentPath,
                        with: .color(.blue),
                        style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [5, 3])
                    )
                } else {
                    context.stroke(
                        segmentPath,
                        with: .color(colorForDutyType(event.dutyType)),
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
            let label = normalizeLabel(event.dutyType)
            durations[label, default: 0] += duration
        }
        return durations
    }
    
    // Format duration as HH:mm
    private func formatDuration(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval / 3600)
        let minutes = Int((timeInterval.truncatingRemainder(dividingBy: 3600)) / 60)
        return String(format: "%02d:%02d", hours, minutes)
    }
    
    private func normalizeLabel(_ label: String) -> String {
        switch label {
        case "ON_DUTY": return "ON"
        case "SLEEP": return "SB"
        case "DRIVE": return "D"
        case "OFF_DUTY": return "OF"
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
    
    
    @EnvironmentObject var viewModel: HOSEventsChartViewModel
    
    
    var body: some View {
        VStack(spacing: 6) {  //MARK: -  Reduced spacing
            Text("Hours Of Service")
                .font(.title3)
                .bold()
            
            Text("Time in Hours")
                .font(.caption)
                .foregroundColor(.gray)

            
            //MARK: -    HOSEventsChart(events: viewModel.events)
            HOSEventsChart(events: viewModel.events)
                .id(viewModel.refreshTrigger) //Force redraw when UUID changes
                .padding(.horizontal, 4)
            
            HStack {
                
                Text("CanvasSF Trial")
                Spacer()
                Text("CanvasSF.com")
                
            }
            .font(.caption2)
            .foregroundColor(.gray)
        }
        .padding(8)  // Reduced padding
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 1)
        .onAppear {
            
            viewModel.loadEventsFromDatabase()
            
            
        }
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

































































































































// MARK: - Data Model
/*struct HOSEvent: Identifiable {
    let id: Int
    let x: Date
    let event_end_time: Date
    let label: String
    let dutyType: String
    var color: Color {
        switch dutyType {
        case "OFF_DUTY": return Color(red: 0.2, green: 0.6, blue: 1.0)  // Light blue
        case "SLEEP": return Color(red: 0.0, green: 0.4, blue: 0.8)     // Dark blue
        case "DRIVE": return Color(red: 1.0, green: 0.6, blue: 0.0)     // Orange
        case "ON_DUTY": return Color(red: 0.9, green: 0.5, blue: 0.0)   // Dark orange
        default: return Color(red: 0.7, green: 0.7, blue: 0.7)          // Gray
        }
    }
}
class HOSEventsChartViewModel: ObservableObject {
    @Published var events: [HOSEvent] = []
    @Published var refreshTrigger = UUID()
    
    
    init(initialEvents: [HOSEvent]? = nil) {
        if let events = initialEvents {
            self.events = events
        } else {
            loadEventsFromDatabase()
        }
    }
    
    func loadEventsFromDatabase() {
        var logs = DatabaseManager.shared.fetchDutyEventsForToday()
        
        print("📊 Logs fetched from DB: \(logs.count)")
        
        // Sort logs to find earliest
        logs.sort { $0.startTime < $1.startTime }
        self.refreshTrigger = UUID()
        
        // Add dummy OFF_DUTY from 00:00 to first log's startTime if needed
        if let first = logs.first {
            let startOfDay = Calendar.current.startOfDay(for: Date())
            if first.startTime > startOfDay {
                let dummy = DutyLog(
                    id: -999,
                    status: "OFF_DUTY",
                    startTime: startOfDay,
                    endTime: first.startTime
                )
                logs.insert(dummy, at: 0)
            }
        }
        
        self.events = logs.map { log in
            let normalizedStatus = normalizeStatus(log.status)
            

            
            let offset = UserDefaults.standard.string(forKey: "userTimezoneOffset") ?? "+05:30"
            let adjustedStartTime = log.startTime
            let adjustedEndTime = log.endTime


            
            print("⏱ Adjusted: \(adjustedStartTime) → \(adjustedEndTime)")
            
            return HOSEvent(
                id: log.id,
                x: adjustedStartTime,
                event_end_time: adjustedEndTime,
                label: normalizedStatus,
                dutyType: normalizedStatus
            )
        }
    }
    
    private func normalizeStatus(_ status: String) -> String {
        switch status.uppercased() {
        case "ON-DUTY": return "ON_DUTY"
        case "OFF-DUTY": return "OFF_DUTY"
        case "SLEEP": return "SLEEP"
        case "DRIVE": return "DRIVE"
        default: return "OFF_DUTY"
        }
    }
}



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

// MARK: - Duty Line Path View
struct DutyLinePathView: View {
    let events: [HOSEvent]
    let levelMap: [String: Int]
    let rowHeight: CGFloat
    let hourWidth: CGFloat
    
    private func yPositionForLevel(_ level: Int) -> CGFloat {
        var position: CGFloat = 0
        for i in 0..<level {
            position += rowHeight
        }
        return position + (rowHeight / 2)
    }
    
    private func colorForDutyType(_ dutyType: String) -> Color {
        switch dutyType {
        case "SLEEP":
            return Color(red: 55/255, green: 65/255, blue: 81/255) // gray-blue
        case "OFF_DUTY":
            return Color(red: 250/255, green: 204/255, blue: 21/255) // yellow
        case "ON_DUTY":
            return Color(red: 37/255, green: 99/255, blue: 235/255) // blue
        case "DRIVE":
            return Color(red: 0.0, green: 0.8, blue: 0.0) // green
        default:
            return Color.gray
        }
    }
    
    
    
    var body: some View {
        Canvas { context, size in
            // Sort all events by time
            let sortedEvents = events.sorted { $0.x < $1.x }
            guard !sortedEvents.isEmpty else { return }
            
            for (index, event) in sortedEvents.enumerated() {
                guard let level = levelMap[normalizeLabel(event.label)] else { continue }
                let eventColor = colorForDutyType(event.dutyType)
                
                // Draw the main event line
                if let startX = minutesSinceMidnight(event.x),
                   let endX = minutesSinceMidnight(event.event_end_time) {
                    let y = yPositionForLevel(level)
                    let startXPos = CGFloat(startX) * (hourWidth / 60.0)
                    let endXPos = CGFloat(endX) * (hourWidth / 60.0)
                    
                    let eventPath = Path { path in
                        path.move(to: CGPoint(x: startXPos, y: y))
                        path.addLine(to: CGPoint(x: endXPos, y: y))
                    }
                    print("⏱ Event from \(event.x) to \(event.event_end_time)")
                    context.stroke(eventPath, with: .color(eventColor), style: StrokeStyle(
                        lineWidth: 2,
                        lineCap: .round,
                        lineJoin: .round
                    ))
                }
            }
        }
        
        
    }
    
    func minutesSinceMidnight(_ date: Date) -> Int? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        
        guard let hour = components.hour, let minute = components.minute else {
            return nil
        }
        
        return (hour * 60) + minute
    }
    
    private func normalizeLabel(_ label: String) -> String {
        switch label {
        case "ON_DUTY": return "ON"
        case "DRIVE": return "D"
        case "SLEEP": return "SB"
        case "OFF_DUTY": return "OF"
        default: return "OF"
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
            let label = normalizeLabel(event.dutyType)
            durations[label, default: 0] += duration
        }
        return durations
    }
    
    // Format duration as HH:mm
    private func formatDuration(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval / 3600)
        let minutes = Int((timeInterval.truncatingRemainder(dividingBy: 3600)) / 60)
        return String(format: "%02d:%02d", hours, minutes)
    }
    
    private func normalizeLabel(_ label: String) -> String {
        switch label {
        case "ON_DUTY": return "ON"
        case "SLEEP": return "SB"
        case "DRIVE": return "D"
        case "OFF_DUTY": return "OF"
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
                    .frame(height: 15)  // Reduced height for hour labels
                    
                    // Grid and events
                    ZStack {
                        // Background
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
                        .frame(height: 15)  // Reduced height for hour labels
                    
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
    
    
    @EnvironmentObject var viewModel: HOSEventsChartViewModel
    
    
    var body: some View {
        VStack(spacing: 6) {  // Reduced spacing
            Text("Hours Of Service")
                .font(.title3)
                .bold()
            
            Text("Time in Hours")
                .font(.caption)
                .foregroundColor(.gray)
            
            
            
            //   HOSEventsChart(events: viewModel.events)
            HOSEventsChart(events: viewModel.events)
                .id(viewModel.refreshTrigger) //  Force redraw when UUID changes
            
                .padding(.horizontal, 4)
            
            
            
            HStack {
                
                Text("CanvasJS Trial")
                Spacer()
                Text("CanvasJS.com")
                
            }
            .font(.caption2)
            .foregroundColor(.gray)
        }
        .padding(8)  // Reduced padding
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 1)
        .onAppear {
            
            viewModel.loadEventsFromDatabase()
            
            
        }
    }
    
}

extension Date {
    func toLocalString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
}*/









































































































































// MARK: - View Model
/*class HOSEventsChartViewModel: ObservableObject {
    @Published var events: [HOSEvent] = []
    
    init(initialEvents: [HOSEvent]? = nil) {
        if let events = initialEvents {
            self.events = events
        } else {
            createStaticEvents()    //MARK: - Static Value
            //loadEventsFromDatabase()    //MARK: -  Dynamic Value

        }
    }
    
  private func createStaticEvents() {
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        
        // Create static events for a typical day
        events = [
            // Morning OFF_DUTY period
            HOSEvent(
                id: 1,
                x: startOfDay,
                event_end_time: calendar.date(byAdding: .hour, value: 6, to: startOfDay)!,
                label: "OFF_DUTY",
                dutyType: "OFF_DUTY"
            ),
            
            // Morning ON_DUTY period
            HOSEvent(
                id: 2,
                x: calendar.date(byAdding: .hour, value: 6, to: startOfDay)!,
                event_end_time: calendar.date(byAdding: .hour, value: 7, to: startOfDay)!,
                label: "ON_DUTY",
                dutyType: "ON_DUTY"
            ),
            
            // Morning DRIVE period
            HOSEvent(
                id: 3,
                x: calendar.date(byAdding: .hour, value: 7, to: startOfDay)!,
                event_end_time: calendar.date(byAdding: .hour, value: 11, to: startOfDay)!,
                label: "DRIVE",
                dutyType: "DRIVE"
            ),
            
            // Mid-day ON_DUTY period
            HOSEvent(
                id: 4,
                x: calendar.date(byAdding: .hour, value: 11, to: startOfDay)!,
                event_end_time: calendar.date(byAdding: .hour, value: 12, to: startOfDay)!,
                label: "ON_DUTY",
                dutyType: "ON_DUTY"
            ),
            
            // Afternoon DRIVE period
            HOSEvent(
                id: 5,
                x: calendar.date(byAdding: .hour, value: 12, to: startOfDay)!,
                event_end_time: calendar.date(byAdding: .hour, value: 16, to: startOfDay)!,
                label: "DRIVE",
                dutyType: "DRIVE"
            ),
            
            // Evening ON_DUTY period
            HOSEvent(
                id: 6,
                x: calendar.date(byAdding: .hour, value: 16, to: startOfDay)!,
                event_end_time: calendar.date(byAdding: .hour, value: 17, to: startOfDay)!,
                label: "ON_DUTY",
                dutyType: "ON_DUTY"
            ),
            
            // Night OFF_DUTY period
            HOSEvent(
                id: 7,
                x: calendar.date(byAdding: .hour, value: 17, to: startOfDay)!,
                event_end_time: calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startOfDay)!,
                label: "OFF_DUTY",
                dutyType: "OFF_DUTY"
            )
        ]
    }
}*/

//*************************************************************************************************************************************************************************************
//  Change this to internal or public
/*   func loadEventsFromDatabase() {
    var logs = DatabaseManager.shared.fetchDutyEventsForToday()
    
    print("📊 Logs fetched from DB: \(logs.count)")
    
    
    for log in logs {
        print("→ \(log.status) from \(log.startTime) to \(log.endTime)")
        //MARK: -  to show a Line8Continue
        // Sort logs to find earliest
        logs.sort { $0.startTime < $1.startTime }
        self.refreshTrigger = UUID()
        // ⏱ Add dummy OFF_DUTY from 00:00 to first log's startTime if needed
        if let first = logs.first {
            let startOfDay = Calendar.current.startOfDay(for: Date())
            if first.startTime > startOfDay {
                let dummy = DutyLog(
                    id: -999, // dummy ID
                    status: "OFF_DUTY",
                    startTime: startOfDay,
                    endTime: first.startTime
                )
                logs.insert(dummy, at: 0)
            }
        }
        
    }

    self.events = logs.map { log in
        let normalizedStatus = normalizeStatus(log.status)
        
        let localStartTime = log.startTime
        let localEndTime = log.endTime


        
        print(" Final Local Start: \(localStartTime)")
        print("END Time:  \(localEndTime)")

        return HOSEvent(
            id: log.id,
            x: localStartTime,
            event_end_time: localEndTime,
            label: normalizedStatus,
            dutyType: normalizedStatus
        )
    }
}*/




/*
 
 /*    func minutesSinceMidnight(_ date: Date) -> Int? {
         let calendar = Calendar.current
         let localDate = date //  already local
         let components = calendar.dateComponents([.hour, .minute], from: localDate)

         guard let hour = components.hour, let minute = components.minute else {
             return nil
         }

         return (hour * 60) + minute
         
     }*/

 
 
 // Draw all lines with their respective colors
//            for (index, event) in sortedEvents.enumerated() {
//                guard let level = levelMap[normalizeLabel(event.label)] else { continue }
//                let eventColor = colorForDutyType(event.dutyType)
//
//                // Draw connecting lines if not the first event
//                if index > 0,
//                   let previousEvent = sortedEvents[safe: index - 1],
//                   let previousLevel = levelMap[normalizeLabel(previousEvent.label)],
//                   let previousEndX = minutesSinceMidnight(previousEvent.event_end_time),
//                   let currentStartX = minutesSinceMidnight(event.x),
//                   previousEndX <= currentStartX {  //  Only draw forward
//
//                    let previousY = yPositionForLevel(previousLevel)
//                    let currentY = yPositionForLevel(level)
//                    let previousEndXPos = CGFloat(previousEndX) * (hourWidth / 60.0)
//                    let currentStartXPos = CGFloat(currentStartX) * (hourWidth / 60.0)
//
//                    // Draw vertical connecting line
//                    let verticalPath = Path { path in
//                        path.move(to: CGPoint(x: previousEndXPos, y: previousY))
//                        path.addLine(to: CGPoint(x: previousEndXPos, y: currentY))
//                    }
//                    context.stroke(verticalPath, with: .color(eventColor), style: StrokeStyle(
//                        lineWidth: 2,
//                        lineCap: .round,
//                        lineJoin: .round
//                    ))
//
//                    // Draw horizontal line
//                    if previousEndXPos != currentStartXPos {
//                        let horizontalPath = Path { path in
//                            path.move(to: CGPoint(x: previousEndXPos, y: currentY))
//                            path.addLine(to: CGPoint(x: currentStartXPos, y: currentY))
//                        }
//                        context.stroke(horizontalPath, with: .color(eventColor), style: StrokeStyle(
//                            lineWidth: 2,
//                            lineCap: .round,
//                            lineJoin: .round
//                        ))
//                    }
//                }
//            }
 
 // MARK: - View Model
 /*class HOSEventsChartViewModel: ObservableObject {
     @Published var events: [HOSEvent] = []
     
     init(initialEvents: [HOSEvent]? = nil) {
         if let events = initialEvents {
             self.events = events
         } else {
             createStaticEvents()    //MARK: - Static Value
             //loadEventsFromDatabase()    //MARK: -  Dynamic Value

         }
     }
     
   private func createStaticEvents() {
         let calendar = Calendar.current
         let now = Date()
         let startOfDay = calendar.startOfDay(for: now)
         
         // Create static events for a typical day
         events = [
             // Morning OFF_DUTY period
             HOSEvent(
                 id: 1,
                 x: startOfDay,
                 event_end_time: calendar.date(byAdding: .hour, value: 6, to: startOfDay)!,
                 label: "OFF_DUTY",
                 dutyType: "OFF_DUTY"
             ),
             
             // Morning ON_DUTY period
             HOSEvent(
                 id: 2,
                 x: calendar.date(byAdding: .hour, value: 6, to: startOfDay)!,
                 event_end_time: calendar.date(byAdding: .hour, value: 7, to: startOfDay)!,
                 label: "ON_DUTY",
                 dutyType: "ON_DUTY"
             ),
             
             // Morning DRIVE period
             HOSEvent(
                 id: 3,
                 x: calendar.date(byAdding: .hour, value: 7, to: startOfDay)!,
                 event_end_time: calendar.date(byAdding: .hour, value: 11, to: startOfDay)!,
                 label: "DRIVE",
                 dutyType: "DRIVE"
             ),
             
             // Mid-day ON_DUTY period
             HOSEvent(
                 id: 4,
                 x: calendar.date(byAdding: .hour, value: 11, to: startOfDay)!,
                 event_end_time: calendar.date(byAdding: .hour, value: 12, to: startOfDay)!,
                 label: "ON_DUTY",
                 dutyType: "ON_DUTY"
             ),
             
             // Afternoon DRIVE period
             HOSEvent(
                 id: 5,
                 x: calendar.date(byAdding: .hour, value: 12, to: startOfDay)!,
                 event_end_time: calendar.date(byAdding: .hour, value: 16, to: startOfDay)!,
                 label: "DRIVE",
                 dutyType: "DRIVE"
             ),
             
             // Evening ON_DUTY period
             HOSEvent(
                 id: 6,
                 x: calendar.date(byAdding: .hour, value: 16, to: startOfDay)!,
                 event_end_time: calendar.date(byAdding: .hour, value: 17, to: startOfDay)!,
                 label: "ON_DUTY",
                 dutyType: "ON_DUTY"
             ),
             
             // Night OFF_DUTY period
             HOSEvent(
                 id: 7,
                 x: calendar.date(byAdding: .hour, value: 17, to: startOfDay)!,
                 event_end_time: calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startOfDay)!,
                 label: "OFF_DUTY",
                 dutyType: "OFF_DUTY"
             )
         ]
     }
 }*/


 // MARK: - Data Model
 struct HOSEvent: Identifiable {
     let id: Int
     let x: Date
     let event_end_time: Date
     let label: String
     let dutyType: String
     var color: Color {
         switch dutyType {
         case "OFF_DUTY": return Color(red: 0.2, green: 0.6, blue: 1.0)  // Light blue
         case "SLEEP": return Color(red: 0.0, green: 0.4, blue: 0.8)     // Dark blue
         case "DRIVE": return Color(red: 1.0, green: 0.6, blue: 0.0)     // Orange
         case "ON_DUTY": return Color(red: 0.9, green: 0.5, blue: 0.0)   // Dark orange
         default: return Color(red: 0.7, green: 0.7, blue: 0.7)          // Gray
         }
     }
 }
 class HOSEventsChartViewModel: ObservableObject {
     @Published var events: [HOSEvent] = []

     init(initialEvents: [HOSEvent]? = nil) {
         if let events = initialEvents {
             self.events = events
         } else {
             loadEventsFromDatabase()
         }
     }

     //  Change this to internal or public
     func loadEventsFromDatabase() {
         var logs = DatabaseManager.shared.fetchDutyEventsForToday()
         
         print("📊 Logs fetched from DB: \(logs.count)")
         for log in logs {
             print("→ \(log.status) from \(log.startTime) to \(log.endTime)")
             //MARK: -  to show a Line8Continue
             // Sort logs to find earliest
             logs.sort { $0.startTime < $1.startTime }

             // ⏱ Add dummy OFF_DUTY from 00:00 to first log's startTime if needed
 //            if let first = logs.first {
 //                let startOfDay = Calendar.current.startOfDay(for: Date())
 //                if first.startTime > startOfDay {
 //                    let dummy = DutyLog(
 //                        id: -999, // dummy ID
 //                        status: "OFF_DUTY",
 //                        startTime: startOfDay,
 //                        endTime: first.startTime
 //                    )
 //                    logs.insert(dummy, at: 0)
 //                }
 //            }
             
         }
         


         self.events = logs.map { log in
             let normalizedStatus = normalizeStatus(log.status)
             return HOSEvent(
                 id: log.id,
                 x: log.startTime,
                 event_end_time: log.endTime,
                 label: normalizedStatus,
                 dutyType: normalizedStatus
             )
         }
         
   

     }

     private func normalizeStatus(_ status: String) -> String {
         switch status.uppercased() {
         case "ON-DUTY": return "ON_DUTY"
         case "OFF-DUTY": return "OFF_DUTY"
         case "SLEEP": return "SLEEP"
         case "DRIVE": return "DRIVE"
         default: return "OFF_DUTY"
         }
     }
 }


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

 // MARK: - Duty Line Path View
 struct DutyLinePathView: View {
     let events: [HOSEvent]
     let levelMap: [String: Int]
     let rowHeight: CGFloat
     let hourWidth: CGFloat
     
     private func yPositionForLevel(_ level: Int) -> CGFloat {
         var position: CGFloat = 0
         for i in 0..<level {
             position += rowHeight
         }
         return position + (rowHeight / 2)
     }
     
     private func colorForDutyType(_ dutyType: String) -> Color {
         switch dutyType {
         case "SLEEP":
             return Color(red: 55/255, green: 65/255, blue: 81/255) // gray-blue
         case "OFF_DUTY":
             return Color(red: 250/255, green: 204/255, blue: 21/255) // yellow
         case "ON_DUTY":
             return Color(red: 37/255, green: 99/255, blue: 235/255) // blue
         case "DRIVE":
             return Color(red: 0.0, green: 0.8, blue: 0.0) // green
         default:
             return Color.gray
         }
     }


     
     var body: some View {
         Canvas { context, size in
             // Sort all events by time
             let sortedEvents = events.sorted { $0.x < $1.x }
             guard !sortedEvents.isEmpty else { return }
             
             // Draw all lines with their respective colors
             for (index, event) in sortedEvents.enumerated() {
                 guard let level = levelMap[normalizeLabel(event.label)] else { continue }
                 let eventColor = colorForDutyType(event.dutyType)
                 
                 // Draw connecting lines if not the first event
                 if index > 0,
                    let previousEvent = sortedEvents[safe: index - 1],
                    let previousLevel = levelMap[normalizeLabel(previousEvent.label)],
                    let previousEndX = minutesSinceMidnight(previousEvent.event_end_time),
                    let currentStartX = minutesSinceMidnight(event.x) {
                     
                     let previousY = yPositionForLevel(previousLevel)
                     let currentY = yPositionForLevel(level)
                     let previousEndXPos = CGFloat(previousEndX) * (hourWidth / 60.0)
                     let currentStartXPos = CGFloat(currentStartX) * (hourWidth / 60.0)
                     
                     // Draw vertical connecting line with current event's color
                     let verticalPath = Path { path in
                         path.move(to: CGPoint(x: previousEndXPos, y: previousY))
                         path.addLine(to: CGPoint(x: previousEndXPos, y: currentY))
                     }
                     context.stroke(verticalPath, with: .color(eventColor), style: StrokeStyle(
                         lineWidth: 2,
                         lineCap: .round,
                         lineJoin: .round
                     ))
                     
                     // Draw horizontal line if needed with current event's color
                     if previousEndXPos != currentStartXPos {
                         let horizontalPath = Path { path in
                             path.move(to: CGPoint(x: previousEndXPos, y: currentY))
                             path.addLine(to: CGPoint(x: currentStartXPos, y: currentY))
                         }
                         context.stroke(horizontalPath, with: .color(eventColor), style: StrokeStyle(
                             lineWidth: 2,
                             lineCap: .round,
                             lineJoin: .round
                         ))
                     }
                 }
                 
                 // Draw the main event line
                 if let startX = minutesSinceMidnight(event.x),
                    let endX = minutesSinceMidnight(event.event_end_time) {
                     let y = yPositionForLevel(level)
                     let startXPos = CGFloat(startX) * (hourWidth / 60.0)
                     let endXPos = CGFloat(endX) * (hourWidth / 60.0)
                     
                     let eventPath = Path { path in
                         path.move(to: CGPoint(x: startXPos, y: y))
                         path.addLine(to: CGPoint(x: endXPos, y: y))
                     }
                     
                     context.stroke(eventPath, with: .color(eventColor), style: StrokeStyle(
                         lineWidth: 2,
                         lineCap: .round,
                         lineJoin: .round
                     ))
                 }
             }
         }
     }
     
     private func minutesSinceMidnight(_ date: Date) -> Int? {
         let calendar = Calendar.current
         let components = calendar.dateComponents([.hour, .minute], from: date)
         guard let hour = components.hour,
               let minute = components.minute else { return nil }
         return hour * 60 + minute
     }
     
     private func normalizeLabel(_ label: String) -> String {
         switch label {
         case "ON_DUTY": return "ON"
         case "DRIVE": return "D"
         case "SLEEP": return "SB"
         case "OFF_DUTY": return "OF"
         default: return "OF"
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
             let label = normalizeLabel(event.dutyType)
             durations[label, default: 0] += duration
         }
         return durations
     }
      
     // Format duration as HH:mm
     private func formatDuration(_ timeInterval: TimeInterval) -> String {
         let hours = Int(timeInterval / 3600)
         let minutes = Int((timeInterval.truncatingRemainder(dividingBy: 3600)) / 60)
         return String(format: "%02d:%02d", hours, minutes)
     }
     
     private func normalizeLabel(_ label: String) -> String {
         switch label {
         case "ON_DUTY": return "ON"
         case "SLEEP": return "SB"
         case "DRIVE": return "D"
         case "OFF_DUTY": return "OF"
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
                     .frame(height: 15)  // Reduced height for hour labels
                     
                     // Grid and events
                     ZStack {
                         // Background
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
                         .frame(height: 15)  // Reduced height for hour labels
                     
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

     
     @EnvironmentObject var viewModel: HOSEventsChartViewModel

     
     var body: some View {
         VStack(spacing: 6) {  // Reduced spacing
             Text("Hours Of Service")
                 .font(.title3)
                 .bold()
             
             Text("Time in Hours")
                 .font(.caption)
                 .foregroundColor(.gray)
             
            
             
             HOSEventsChart(events: viewModel.events)
                 .padding(.horizontal, 4)
            
                 
             
             HStack {
                 
                 Text("CanvasJS Trial")
                 Spacer()
                 Text("CanvasJS.com")
          
             }
             .font(.caption2)
             .foregroundColor(.gray)
         }
         .padding(8)  // Reduced padding
         .background(Color.white)
         .cornerRadius(8)
         .shadow(radius: 1)
         .onAppear {
                 
                    viewModel.loadEventsFromDatabase()
           

                }
     }
 }

 // MARK: - Preview Provider
 struct HOSEventsChartScreen_Previews: PreviewProvider {
     static let formatter: DateFormatter = {
         let formatter = DateFormatter()
         formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
         return formatter
     }()
     
     static let mockEvents: [HOSEvent] = [
         HOSEvent(id: 1, x: formatter.date(from: "2024-05-26 00:00:00")!, event_end_time: formatter.date(from: "2024-05-26 16:00:00")!, label: "OFF_DUTY", dutyType: "OFF_DUTY"),
         HOSEvent(id: 2, x: formatter.date(from: "2024-05-26 16:00:00")!, event_end_time: formatter.date(from: "2024-05-26 16:17:00")!, label: "ON_DUTY", dutyType: "ON_DUTY"),
         HOSEvent(id: 3, x: formatter.date(from: "2024-05-26 16:17:00")!, event_end_time: formatter.date(from: "2024-05-26 19:00:00")!, label: "DRIVE", dutyType: "DRIVE"),
         HOSEvent(id: 4, x: formatter.date(from: "2024-05-26 19:00:00")!, event_end_time: formatter.date(from: "2024-05-26 23:59:59")!, label: "OFF_DUTY", dutyType: "OFF_DUTY")
     ]
     
     static var previews: some View {
         HOSEventsChartScreen()
     }
 }


*/
