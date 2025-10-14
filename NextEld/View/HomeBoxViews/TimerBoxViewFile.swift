//
//  TimerBoxViewFile.swift
//  NextEld
//
//  Created by priyanshi   on 06/10/25.
//

import Foundation
import SwiftUI

struct TimeBox: View {
    let type: TimerType
    let title: String
    let time: String
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
                            Text(" / 7 Days")
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
                    Text(time)
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


