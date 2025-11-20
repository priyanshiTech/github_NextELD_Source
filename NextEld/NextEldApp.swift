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
    @AppStorage("selectedLanguageCode") private var selectedLanguageCode: String = "en"
    

    var body: some Scene {
        WindowGroup {
            Group {
                switch rootManager.currentRoot {
                case .login:
                    LoginScreen()
                    
                case .splashScreen:
                    SplashView()
                    
                case .scanner(let moveToHome):
                    DeviceScannerView(checkboxClick: true, macaddress: "", moveToHome: moveToHome)
                    
                case .SessionExpireUIView:
                    SessionExpireUIView()
                    
                case .DisclaimerView:
                    DisclamerView()
                }
            }
            .preferredColorScheme(.light)
            .environment(\.locale, Locale(identifier: selectedLanguageCode))
        }
        .environmentObject(rootManager)
        .environmentObject(networkMonitor)
    }
}
