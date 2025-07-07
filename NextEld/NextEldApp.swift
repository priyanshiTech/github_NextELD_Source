//
//  NextEldApp.swift
//  NextEld
//
//  Created by Priyanshi on 05/05/25.
//

import SwiftUI

import SwiftUI

@main
struct NextEldApp: App {
    @StateObject private var navManager = NavigationManager()
    @StateObject private var session = SessionManager()
    @StateObject private var loginVM = LoginViewModel(session: SessionManager()) // temp placeholder

    var body: some Scene {
        WindowGroup {
            // 🔁 Create shared LoginVM with same session
            let sharedLoginVM = LoginViewModel(session: session)

            RootView()
                .environmentObject(navManager)
                .environmentObject(session)
                .environmentObject(sharedLoginVM)
        }
    }
}


//
//@main
//struct NextEldApp: App {
//    @StateObject private var navManager = NavigationManager()
//
//
//    var body: some Scene {
//        WindowGroup {
//            RootView()
//                .environmentObject(navManager)
//        
//        }
//    }
//}

