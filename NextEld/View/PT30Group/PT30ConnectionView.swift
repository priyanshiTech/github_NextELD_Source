//  PT30ConnectionView.swift
//  NextEld
//  Created by priyanshi on 04/06/25.

import SwiftUI

struct PT30ConnectionView: View {
    @State private var showDeviceList = false
    @EnvironmentObject var navManager: NavigationManager
    let title = "ELD Connection"

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button { navManager.goBack() } label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                    Spacer()
                }
                .padding()
                .background(Color(uiColor: .wine))

                Spacer()
            }
            // CONNECT button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button("CONNECT") {
                        showDeviceList = true
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 14)
                    .foregroundColor(.black)
                    .background(Color(UIColor.colorFabConnect))
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 4)
                    .padding(.bottom, 24)
                    .padding(.trailing, 20)
                }
            }
        }
        .fullScreenCover(isPresented: $showDeviceList) {
            DeviceListWrapper()
                .edgesIgnoringSafeArea(.all)
        }
        .navigationBarBackButtonHidden(true)
    }
}













