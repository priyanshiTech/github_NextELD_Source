//
//  SplashView.swift
//  NextEld
//
//  Created by Priyanshi on 07/05/25.
//

import SwiftUI

struct SplashView: View {
    @StateObject var navManager: NavigationManager = .init()
    @EnvironmentObject var appRootManager: AppRootManager
    @State private var offSetImage: CGFloat = 300
    @State private var fadeOut: Bool = false
    @StateObject private var tokenVM = APITokenUpdateViewModel()

    var body: some View {
            VStack {
                Text("Excel Eld")
                    .padding(0.0)
                    .scaledToFit()
                    .foregroundColor(.white)
                    .font(.title)
                    .bold()
                    .frame(width: 200, height: 250)
                    .offset(y: offSetImage)
            }
            
        
        .navigationBarBackButtonHidden()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .wine))
        .ignoresSafeArea()
        .environmentObject(navManager)
        .onAppear {
            // Reset navigation state on appear to prevent stale state
            navManager.reset()
            
            // Run animation
            withAnimation(.easeOut(duration: 2.0)) {
                offSetImage = 0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    fadeOut = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        handleNavigation()
                    }

                }
            }
            //  Decide navigation after splash delay
        }
//        .navigationDestination(for: AppRoute.HomeFlow.self) { type in
//            switch type {
//            case .Home:
//                HomeScreenView()
//            case .AddVichleMode:
//                AddVichleMode(selectedVehicle: .constant(""), selectedVehicleId: .constant(0))
//            default:
//                EmptyView()
//            }
//        }
        
    }
    
    private func handleNavigation() {
        // Reset navigation path to prevent stale state
        navManager.reset()
        
        if let savedToken = SessionManagerClass.shared.getToken(), !savedToken.isEmpty, AppStorageHandler.shared.driverId != nil {
            Task { @MainActor in
                // Add timeout to prevent hanging (5 seconds max)
                let apiTask = Task {
                    await tokenVM.callSplashUpdateAPI()
                }
                
                let timeoutTask = Task {
                    try? await Task.sleep(nanoseconds: 5_000_000_000) // 5 seconds
                }
                
                // Race between API call and timeout
                var apiSuccess: Bool? = nil
                
                await withTaskGroup(of: Bool?.self) { group in
                    group.addTask {
                        let result = await apiTask.value
                        return result
                    }
                    
                    group.addTask {
                        await timeoutTask.value
                        return nil // Timeout signal
                    }
                    
                    // Get first completed result
                    if let firstResult = await group.next() {
                        if let boolResult = firstResult {
                            apiSuccess = boolResult
                        } else {
                            // Timeout occurred
                            print(" ⚠️ Splash API timeout - proceeding with existing data")
                            apiSuccess = false
                        }
                        group.cancelAll()
                    }
                }
                
                // Use result if available, otherwise proceed with existing data
                let success = apiSuccess ?? false
                
                let vehicleNo = AppStorageHandler.shared.vehicleNo ?? ""
                if vehicleNo.isEmpty || vehicleNo.lowercased() == "none" {
                    print(" Vehicle No is missing → navigating to AddVehicle screen")
                    appRootManager.currentRoot = .scanner(moveToHome: false)
                    // Navigate to Add Vehicle after a short delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        navManager.navigate(to: AppRoute.HomeFlow.AddVichleMode)
                    }
                } else {
                    appRootManager.currentRoot = .scanner(moveToHome: false)
                }
            }
        } else {
            appRootManager.currentRoot = .login
        }
    }
}
//#Preview {
//    RootView()
//        .environmentObject(NavigationManager())
//
//}


