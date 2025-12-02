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
    @State private var selectedVehicleNumber: String = AppStorageHandler.shared.vehicleNo ?? ""
    @State private var selectedVehicleId: Int = AppStorageHandler.shared.vehicleId ?? 0
    

    var body: some View {
        
        NavigationStack(path: $navManager.path) {
            ZStack {
                Color(uiColor: .wine)   // Background always wine
                    .ignoresSafeArea()
                VStack {
                    Text("All Star Elogs")
                        .padding(0.0)
                        .scaledToFit()
                        .foregroundColor(.white)
                        .font(.title)
                        .bold()
                        .frame(width: 200, height: 250)
                        .offset(y: offSetImage)
                }
                .navigationDestination(for: AppRoute.HomeFlow.self) { route in
                    switch route {
                    case .AddVichleMode:
                        AddVichleMode(
                            selectedVehicle: $selectedVehicleNumber,
                            selectedVehicleId: $selectedVehicleId
                        )
                    case .ADDVehicle:
                        ADDVehicle(
                            selectedVehicleNumber: $selectedVehicleNumber,
                            VechicleID: $selectedVehicleId
                        )
                    default:
                        EmptyView()
                    }
                }
            }
            .navigationBarBackButtonHidden()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(uiColor: .wine))
            .ignoresSafeArea()
            .environmentObject(navManager)
            .onAppear {
                // Set appRootManager in ViewModel
                tokenVM.appRootManager = appRootManager
                
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
        }
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
                    try? await Task.sleep(nanoseconds: 5_000_000_000) //5 seconds
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
                            print("  Splash API timeout - proceeding with existing data")
                            apiSuccess = false
                        }
                        group.cancelAll()
                    }
                }
                
                // Check if session expired - if yes, don't navigate anywhere else
                if tokenVM.isSessionExpired {
                    print(" Session expired detected - staying on SessionExpireUIView")
                    return // Don't proceed with any navigation
                }
                // Use result if available, otherwise proceed with existing data
                let _ = apiSuccess ?? false
                handlePostSplashNavigation()
            }
        } else {
            appRootManager.currentRoot = .login
            
        }
    }
    
    @MainActor
    private func handlePostSplashNavigation() {
        let disclaimerValue = AppStorageHandler.shared.disclaimerRead ?? 0
        if disclaimerValue == 0 {
            appRootManager.currentRoot = .DisclaimerView
            return
        }
        
        if hasValidVehicleInfo() {
            appRootManager.currentRoot = .scanner(moveToHome: false)
        } else {
            navManager.reset()
            navManager.navigate(to: AppRoute.HomeFlow.AddVichleMode)
        }
    }
    
    private func hasValidVehicleInfo() -> Bool {
        if let vehicleId = AppStorageHandler.shared.vehicleId, vehicleId != 0 {
            return true
        }
        
        if let vehicleNumber = AppStorageHandler.shared.vehicleNo?
            .trimmingCharacters(in: .whitespacesAndNewlines),
           !vehicleNumber.isEmpty,
           vehicleNumber.lowercased() != "none" {
            return true
        }
        
        return false
    }
}
//#Preview {
//    RootView()
//        .environmentObject(NavigationManager())
//
//}


