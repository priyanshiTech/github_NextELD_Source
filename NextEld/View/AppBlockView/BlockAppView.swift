//
//  BlockAppView.swift
//  NextEld
//
//  Created by priyanshi on 01/12/25.
//

import SwiftUI

struct BlockAppView: View {
    @ObservedObject var homeViewModel: HomeViewModel
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var navManager: NavigationManager
    
    init(homeViewModel: HomeViewModel) {
        _homeViewModel = ObservedObject(wrappedValue: homeViewModel)
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 30) {

                // Close Button
                HStack {
                    Spacer()
                    Button(action: {
                        // Unblock screen when close button is tapped
                        homeViewModel.unBlockScreen()
                        // Pop navigation directly
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            if !navManager.path.isEmpty {
                                navManager.path.removeLast()
                            }
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.red)
                            .padding(.trailing, 20)
                            .padding(.top, 10)
                    }
                }

                Spacer()
                // Logo
                Image("AppICONs")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)

                Text("Drive Mode Active")
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.top, 10)

                // Timers - Using TimeBox component (same as home screen)
                HStack(spacing: 0) {
                    if let driveTimer = homeViewModel.onDriveTimer {
                        TimeBox(timer: driveTimer, type: .onDrive, title: .init("Drive"))
                    } else {
                        // Fallback timer if not available
                        TimeBox(timer: CountdownTimer(startTime: AppStorageHandler.shared.onDriveTime ?? 0), type: .onDrive, title: .init("Drive"))
                    }
                    
                    if let onDutyTimer = homeViewModel.onDutyTimer {
                        TimeBox(timer: onDutyTimer, type: .onDuty, title: .init("On-Duty"))
                    } else {
                        // Fallback timer if not available
                        TimeBox(timer: CountdownTimer(startTime: AppStorageHandler.shared.onDutyTime ?? 0), type: .onDuty, title: .init("On-Duty"))
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 16))

                Spacer()

                // Device/Engine ID
//                Text("ENG-5412.1")
//                    .font(.system(size: 16))
//                    .foregroundColor(Color.white)
//                    .padding(.vertical, 10)
//                    .padding(.horizontal, 20)
//                    .background(Color.gray.opacity(0.3))
//                    .clipShape(Capsule())
//                    .padding(.bottom, 40)
            }
        }
        .onDisappear {
            // If the view disappears while the view model still thinks it is shown,
            // ensure we reset the block flag so navigation can re-trigger later.
            if homeViewModel.showBlockScreen {
                homeViewModel.unBlockScreen()
            }
        }
    }
}

struct DriveModeActiveView_Previews: PreviewProvider {
    static var previews: some View {
        BlockAppView(homeViewModel: HomeViewModel())
    }
}
