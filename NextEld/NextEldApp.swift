//
//  NextEldApp.swift
//  NextEld
//
//  Created by Priyanshi on 05/05/25.
//

import SwiftUI

@main
struct NextEldApp: App {

    @StateObject private var rootManager = AppRootManager()
    @StateObject private var networkMonitor = NetworkMonitor()
    

    var body: some Scene {
        WindowGroup {
            switch rootManager.currentRoot {
            case .login:
                LoginScreen()
            case .splashScreen:
                SplashView()
            case .scanner:
                DeviceScannerView(checkboxClick: true, macaddress: "")
            }
        }
        .environmentObject(rootManager)
        .environmentObject(networkMonitor)
        
    }
}































/*
 @main
 struct NextEldApp: App {
     // Create all state objects here
     @StateObject private var navManager = NavigationManager()
     @StateObject private var session = SessionManager()
     @StateObject private var loginVM: LoginViewModel
     @StateObject private var networkMonitor = NetworkMonitor()
     @StateObject var trailerVM = TrailerViewModel()
     @StateObject var shippingVM = ShippingDocViewModel()
     @StateObject var addVechicleVm = VehicleViewModel()
     @StateObject var vehicleVM = VehicleConditionViewModel()
     @StateObject var hoseEventsChartViewModel = HOSEventsChartViewModel()
     @StateObject var dutyStatusManager = DutyStatusManager()
     @StateObject var locationManager = LocationManager()
     @StateObject private var DVClocationManager = DeviceLocationManager()
     //@StateObject private var rootManager = AppRootManager()
     init() {
         let session = SessionManager()
         self._session = StateObject(wrappedValue: session)
         self._loginVM = StateObject(wrappedValue: LoginViewModel(session: session))
     }

     var body: some Scene {
         WindowGroup {
             RootView()
                 .environmentObject(navManager)            // must exist
                 .environmentObject(loginVM)
                 .environmentObject(session)
                 .environmentObject(networkMonitor)
                 .environmentObject(trailerVM)
                 .environmentObject(addVechicleVm)
                 .environmentObject(vehicleVM)
                 .environmentObject(hoseEventsChartViewModel)
                 .environmentObject(shippingVM)
                 .environmentObject(dutyStatusManager)
                 .environmentObject(locationManager)
                 .environmentObject(DVClocationManager)
         }
     }
 }

*/
