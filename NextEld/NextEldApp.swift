//
//  NextEldApp.swift
//  NextEld
//
//  Created by AroGeek11 on 05/05/25.
//

import SwiftUI

@main
struct NextEldApp: App {
    
    @StateObject private var navManager = NavigationManager()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(navManager) // Injecting at the top level
        }
    }
}
