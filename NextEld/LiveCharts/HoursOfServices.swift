//
//  HoursOfServices.swift
//  NextEld
//
//  Created by AroGeek11 on 08/05/25.


import Foundation
import SwiftUI
import Charts

/*struct DutyEvent: Identifiable, Decodable {
    let id = UUID()
    let date: String
    let x: String
    let event_end_time: String
    let label: String
    let dutyType: String

    var startDate: Date {
        ISO8601DateFormatter().date(from: x.replacingOccurrences(of: " ", with: "T")) ?? Date()
    }

    var endDate: Date {
        ISO8601DateFormatter().date(from: event_end_time.replacingOccurrences(of: " ", with: "T")) ?? Date()
    }

    var yValue: Double {
        switch label {
        case "OFF_DUTY": return 3.5
        case "SLEEP": return 2.5
        case "DRIVE": return 1.5
        case "START_DUTY": return 0.5
        default: return 3.5
        }
    }
}*/


struct ChartDataPoint: Identifiable {
    let id = UUID()
    let time: Date
    let value: Double
    let upperValue: Double
    let lowerValue: Double
}
class LiveChartViewModel: ObservableObject {
    @Published var dataPoints: [ChartDataPoint] = []
    private var timer: Timer?

    init() {
        startTimer()
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            // Main value between 20 and 80 to keep it within bounds
            let mainValue = Double.random(in: 20...80)
            // Upper and lower values with smaller range
            let upperValue = mainValue + Double.random(in: 5...10)
            let lowerValue = mainValue - Double.random(in: 5...10)
            
            let newPoint = ChartDataPoint(
                time: Date(),
                value: mainValue,
                upperValue: min(upperValue, 95), // Ensure it stays within bounds
                lowerValue: max(lowerValue, 5)   // Ensure it stays within bounds
            )
            
            DispatchQueue.main.async {
                self.dataPoints.append(newPoint)
                
                // Limit the number of points shown
                if self.dataPoints.count > 30 {
                    self.dataPoints.removeFirst()
                }
            }
        }
    }

    deinit {
        timer?.invalidate()
    }
}
struct LiveChartView: View {
    @StateObject private var viewModel = LiveChartViewModel()

    var body: some View {
        Chart {
            ForEach(viewModel.dataPoints) { point in
                // Upper line (thinner)
                LineMark(
                    x: .value("Time", point.time),
                    y: .value("Upper", point.upperValue)
                )
                .foregroundStyle(.orange.opacity(0.5))
                .lineStyle(StrokeStyle(lineWidth: 1))
                
                // Main line (thicker)
                LineMark(
                    x: .value("Time", point.time),
                    y: .value("Value", point.value)
                )
                .foregroundStyle(.orange)
                .lineStyle(StrokeStyle(lineWidth: 2))
                
                // Lower line (thinner)
                LineMark(
                    x: .value("Time", point.time),
                    y: .value("Lower", point.lowerValue)
                )
                .foregroundStyle(.orange.opacity(0.5))
                .lineStyle(StrokeStyle(lineWidth: 1))
            }
        }
        .chartYScale(domain: 0...100)
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 5))
        }
        .chartYAxis {
            AxisMarks(values: .automatic(desiredCount: 5))
        }
        .padding()
    }
}
