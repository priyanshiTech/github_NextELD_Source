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
        if let savedToken = SessionManagerClass.shared.getToken(), !savedToken.isEmpty  , AppStorageHandler.shared.driverId != nil {
            //  If token exists → call splash API
            Task {
                let success = await tokenVM.callSplashUpdateAPI()
                if success {
                    appRootManager.currentRoot = .scanner(moveToHome: true)
                }  else {
                    let vehicleNo = AppStorageHandler.shared.vehicleNo ?? ""
                    if vehicleNo.isEmpty || vehicleNo.lowercased() == "none" {
                        // Navigate to Add Vehicle screen
                        print(" Vehicle No is missing → navigating to AddVehicle screen")
                        navManager.navigate(to: AppRoute.HomeFlow.AddVichleMode)
                    }
                    else {
                        appRootManager.currentRoot = .scanner(moveToHome: false)
                    }
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


