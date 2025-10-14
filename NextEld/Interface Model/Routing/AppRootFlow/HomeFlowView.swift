//
//  HomeFlowView.swift
//  NextEld
//
//  Created by priyanshi   on 09/10/25.
//

import Foundation
import SwiftUI

struct HomeFlowView: View {
    @Binding var presentSideMenu: Bool
    @Binding var selectedSideMenuTab: Int
    @ObservedObject var session: SessionManager

    var body: some View {
        NavigationStack {
            HomeScreenView(
                presentSideMenu: $presentSideMenu,
                selectedSideMenuTab: $selectedSideMenuTab,
                session: session
            )
            .navigationDestination(for: AppRoute.HomeFlow.self) { route in
                switch route {
                case .SplashScreen:
                    SplashView()
                case .home:
                    HomeScreenView(
                        presentSideMenu: $presentSideMenu,
                        selectedSideMenuTab: $selectedSideMenuTab,
                        session: session
                    )
                case .Scanner:
                    DeviceScannerView(tittle: "", checkboxClick: false, macaddress: "")
                case .Settings:
                    SettingsLanguageView()
                case .SupportView:
                    SupportView()
                case .logout:
                    LogOut()
                case .firmWareUpdate:
                    FirmWare_Update()
                }
            }
        }
    }
}
