//
//  TopbarView.swift
//  NextEld
//
//  Created by priyanshi   on 06/10/25.
//

import Foundation
import SwiftUI

// MARK: - Subviews

struct TopBarView: View {
    @Binding var presentSideMenu: Bool
    @EnvironmentObject var navManager: NavigationManager
    var labelValue: String
    @Binding var showDeviceSelector: Bool
    @StateObject private var deleteViewModel = DeleteViewModel()
    
    
    var body: some View {
        
        ZStack {
            Color.white
                .frame(height: 50)
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
            
            HStack {
                
                IconButton(iconName: "line.horizontal.3", action: {
                    presentSideMenu.toggle()
                    print("Hamburger tapped, presentSideMenu is now: \(presentSideMenu)")
                },
                iconColor: .black, iconSize: 20)
                .padding(.leading, 8)
                Spacer()
                
                // Right: Bluetooth
                Button(action: {
                    showDeviceSelector = true
                }) {
                    Image("bluuu")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                .padding(.trailing, 8)
            }
            
            Menu {
                
                Button("ELD Log") {
                    navManager.navigate(to: AppRoute.DatabaseFlow.DriverLogListView) // Example
                }
                Button("Continue Drive") {
                    navManager.navigate(to: AppRoute.DatabaseFlow.ContinueDriveTableView)
                }
                Button("Add Dvir List") {
                    navManager.navigate(to: AppRoute.DatabaseFlow.DvirDataListView)
                }
                
                Button("Certify Log") {
                    navManager.navigate(to: AppRoute.DatabaseFlow.DatabaseCertifyView)
                }
            } label: {
                Text(labelValue)
                    .font(.system(size: 20))
                    .bold()
                    .foregroundColor(Color(UIColor.wine))
            }
            .buttonStyle(PlainButtonStyle())

        }
    }
}

