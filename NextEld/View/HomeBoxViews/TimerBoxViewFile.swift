//
//  TimerBoxViewFile.swift
//  NextEld
//
//  Created by priyanshi   on 06/10/25.
//

import Foundation
import SwiftUI
import Combine

struct TimeBox: View {
    @ObservedObject var timer: CountdownTimer  = .init(startTime: 0)
    static let updateDayNotification: PassthroughSubject<Void, Never> = .init()
    let type: TimerType
    let title: LocalizedStringKey
    @State private var cycleDays = ""
//    @ObservedObject var timer: CountdownTimer
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    if type == .cycleTimer {
                        // Only apply style for Cycle
                        (
                            Text("Cycle")
                                .foregroundColor(.white)
                                .bold()
                            +
                            Text(cycleDays)
                                .foregroundColor(.white)
                                .font(.caption2)
                        )
                    } else {
                        // Normal case
                        Text(title)
                            .foregroundColor(.white)
                            .bold()
                    }
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    //Text(formatTime(timer.remainingTime))
                    Text(timer.remainingTime.timeString)
                        .foregroundColor(.white)
                        .bold()
                }
            }
        }
        .onAppear {
          cycleDays = "/\((AppStorageHandler.shared.cycleDays ?? 0) - AppStorageHandler.shared.days) Days Remaining"
        }
        .onReceive(TimeBox.updateDayNotification, perform: { value in
            cycleDays = "/\((AppStorageHandler.shared.cycleDays ?? 0) - AppStorageHandler.shared.days) Days Remaining"
        })
        .frame(height: 35)
        .padding()
        .background(Color(uiColor: .wine))
        .cornerRadius(10)
        .frame(maxWidth: .infinity)
    }
}


