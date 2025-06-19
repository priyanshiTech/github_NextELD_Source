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
                .background(Color.blue)

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
































//
//struct PT30ConnectionView: View {
//    @State private var showPopup = false
//    @EnvironmentObject var navManager: NavigationManager
//    @State private var showDeviceList = false
//    var title: String = "ELD Connection"
//
//    var body: some View {
//        ZStack {
//            VStack(spacing: 0) {
//
//                HStack {
//                    Button(action: { navManager.goBack() }) {
//                        Image(systemName: "arrow.left")
//                            .foregroundColor(.white)
//                    }
//                    Spacer()
//                    Text(title)
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .fontWeight(.semibold)
//                    Spacer()
//                }
//                .padding()
//                .background(Color.blue)
//
//
//                Spacer()
//            }
//
//
//            VStack {
//                Spacer()
//                HStack {
//                    Spacer()
//                    Button("CONNECT") {
//                      //  ble.startScan()
//                        showPopup = true
//                    }
//                    .padding(.horizontal, 24)
//                    .padding(.vertical, 14)
//                    .foregroundColor(.black)
//                    .background(Color(UIColor.colorFabConnect))
//                    .clipShape(Capsule())
//                    .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 4)
//                    .padding(.bottom, 24)
//                    .padding(.trailing, 20)
//                }
//
//            }
//            .fullScreenCover(isPresented: $showDeviceList) {
//                    DeviceListWrapper()
//                        .edgesIgnoringSafeArea(.all)
//                }
//            }.navigationBarBackButtonHidden(true)
//        }
//
//    }



















































































//import SwiftUI
//struct PT30ConnectionView: View {
//    @State private var showPopup = false
//    @StateObject private var ble = BLEManager.shared
//    @EnvironmentObject var navManager: NavigationManager
//
//    var body: some View {
//        ZStack {
//            header
//            mainContent
//            connectButton
//            devicePopup
//        }
//        .navigationBarBackButtonHidden(true)
//        .onChange(of: ble.connectedPeripheral) { newPeripheral in
//            if newPeripheral != nil {
//                navManager.navigate(to: AppRoute.PT30DeviceDataView)
//            }
//        }
//    }
//
//    var header: some View {
//        HStack {
//            Button { navManager.goBack() } label: {
//                Image(systemName: "arrow.left").foregroundColor(.white)
//            }
//            Spacer()
//            Text("ELD Connection")
//                .font(.headline)
//                .foregroundColor(.white)
//                .fontWeight(.semibold)
//            Spacer()
//        }
//        .padding()
//        .background(Color.blue)
//    }
//
//    var mainContent: some View {
//        VStack {
//            if ble.connectedPeripheral != nil {
//                Text("Connected ✅").padding()
//            } else {
//                Text(ble.status).padding()
//                Spacer()
//            }
//        }
//    }
//
//    var connectButton: some View {
//        VStack {
//            Spacer()
//            HStack {
//                Spacer()
//                Button("CONNECT") {
//                    ble.startScan()
//                    showPopup = true
//                }
//                // styling...
//            }
//        }
//    }
//
//    var devicePopup: some View {
//        Group {
//            if showPopup {
//                Color.black.opacity(0.4)
//                    .ignoresSafeArea()
//                    .onTapGesture { showPopup = false }
//                popupContent
//            }
//        }
//    }
//
//    var popupContent: some View {
//        VStack(spacing: 16) {
//            Text("Select a device:").font(.headline)
//            List(ble.devices) { device in
//                Button {
//                    ble.connect(device)
//                    showPopup = false
//                } label: {
//                    HStack {
//                        Text(device.peripheral.name ?? "Unknown")
//                        Spacer()
//                        Text("\(device.rssi)")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                    }
//                    .padding(.vertical, 8)
//                }
//            }
//            .frame(height: 250)
//
//            Button("SCAN AGAIN") {
//                ble.startScan()
//            }
//            // styling...
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(16)
//        .frame(width: 320)
//        .shadow(radius: 10)
//    }
//}
//
