//
//  BlockAppView.swift
//  NextEld
//
//  Created by priyanshi on 01/12/25.
//

import SwiftUI

struct BlockAppView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 30) {
                HStack {
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.red)
                            .padding(.trailing, 20)
                            .padding(.top, 10)
                    }
                }

                Spacer()

                Image("AppICONs")     // Add your logo asset here
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)

                Text("Drive Mode Active")
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.top, 10)

                // Timers
                HStack(spacing: 0) {
                    timerBox(title: "Drive", time: "00:00:00")
                    timerBox(title: "On-Duty", time: "00:00:00")
                    
                 
                        
                     }
                }
                .clipShape(RoundedRectangle(cornerRadius: 16))

                Spacer()
                // Device/Engine ID
                Text("ENG-5412.1")
                    .font(.system(size: 16))
                    .foregroundColor(Color.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color.gray.opacity(0.3))
                    .clipShape(Capsule())
                    .padding(.bottom, 40)
            }
        }
    }

    // MARK: - Component
    func timerBox(title: String, time: String) -> some View {
        VStack(spacing: 5) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)

            Text(time)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color(UIColor.wine))
    }


#Preview {
    BlockAppView()
}

