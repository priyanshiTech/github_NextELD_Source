//
//  TimerBoxViewFile.swift
//  NextEld
//
//  Created by priyanshi   on 06/10/25.
//

import Foundation
import SwiftUI

struct TimeBox: View {
    @ObservedObject var timer: CountdownTimer  = .init(startTime: 0)
    let type: TimerType
    let title: String
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
                            Text(" / \(AppStorageHandler.shared.cycleDays ?? 0 - (AppStorageHandler.shared.days ?? 1)) Days")
                                .foregroundColor(.white)
                                .font(.footnote)
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
        .frame(height: 35)
        .padding()
        .background(Color(uiColor: .wine))
        .cornerRadius(10)
        .frame(maxWidth: .infinity)
    }
}


