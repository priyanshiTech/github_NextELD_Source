//
//  VoilationsAlert's.swift
//  NextEld
//
//  Created by Priyanshi  on 01/07/25.
//

import Foundation
import SwiftUI

    
struct TimerAlert: Identifiable {
    var id = UUID()
    var title: String
    var message: String
    var backgroundColor: Color = .yellow
    var isViolation: Bool = false // for styling later if needed
}
struct CommonTimerAlertView: View {
    let violationData: ViolationData
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()

            VStack(spacing: 16) {
                Text(violationData.getTitle())
                    .font(.title2)
                    .bold()
                    .foregroundColor(.black)

                Text(violationData.getWarningText())
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(.horizontal)

                Button(action: onDismiss) {
                    Text("OK")
                        .bold()
                        .padding(.vertical, 10)
                        .padding(.horizontal, 30)
                        .background(Color.white)
                        .cornerRadius(8)
                        .foregroundColor(Color(uiColor: .wine))
                }
            }
            .padding()
            .background(violationData.getBackground())
            .cornerRadius(20)
            .padding(.horizontal, 30)
        }
    }
}
