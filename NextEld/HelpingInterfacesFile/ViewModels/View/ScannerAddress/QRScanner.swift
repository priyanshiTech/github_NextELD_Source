//
//  ScannerQR.swift
//  NextEld
//
//  Created by Priyanshi on 10/06/25.
//
//
//import SwiftUI
//import AVFoundation

//struct _ScannerQR: View {
//    @EnvironmentObject var navmanager: NavigationManager
//    var tittle: String = "Scan QR"
//    @Binding var macaddress: String
//    @State private var scannedCode: String? = nil
//    @State private var isScanning = true
//
//    var body: some View {
//        ZStack {
//            if isScanning {
//                            QRCodeScannerView { code in
//                                self.macaddress = code         // <- Assign to bound variable
//                                self.scannedCode = code
//                                self.isScanning = false
//                                navmanager.navigate(to: AppRoute.Scanner)
//                            }
//                        }
//            QRCodeScannerView { code in
//                self.macaddress = code
//                self.scannedCode = code
//                self.isScanning = false
//            }
//
//
//            VStack(spacing: 0) {
//                // Top Bar
//                HStack {
//                    Button(action: {
//                        navmanager.goBack()
//                    }) {
//                        Image(systemName: "arrow.left")
//                            .foregroundColor(.white)
//                            .imageScale(.large)
//                    }
//
//                    Text(tittle)
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .fontWeight(.semibold)
//
//                    Spacer()
//                }
//                .padding(.horizontal)
//                .frame(height: 50)
//                .background(Color.blue)
//                .zIndex(1)
//
//                Spacer()
//            }
//
//            // White scanner frame box
//            RoundedRectangle(cornerRadius: 12)
//                .stroke(Color.white, lineWidth: 2)
//                .frame(width: 250, height: 250)
//        }
//        .edgesIgnoringSafeArea(.all)
//        .navigationBarBackButtonHidden()
//    }
//}
import SwiftUI

struct _ScannerQR: View {
    @EnvironmentObject var navmanager: NavigationManager
    @Environment(\.presentationMode) var presentationMode // <-- Needed to dismiss view
    
    @Binding var macaddress: String
    @State private var scannedCode: String? = nil
    @State private var isScanning = true

    var tittle: String = "Scan QR"

    var body: some View {
        ZStack {
            if isScanning {
                QRCodeScannerView { code in
                    self.macaddress = code // ← Update parent view
                    self.scannedCode = code
                    self.isScanning = false
                    
                    // Delay slightly before dismiss to allow UI update
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
                        Color.black.opacity(0.5)
                            .mask {
                                Rectangle()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .frame(width: 250, height: 250)
                                            .blendMode(.destinationOut)
                                    )
                                    .compositingGroup()
                            }
                            .edgesIgnoringSafeArea(.all)

                        // Scanner frame box
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white, lineWidth: 2)
                            .frame(width: 250, height: 250)

            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .imageScale(.large)
                    }

                    Text(tittle)
                        .font(.headline)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)

                    Spacer()
                }
                .padding(.horizontal)
                .frame(height: 50)
                .background(Color(uiColor: .wine))
                .zIndex(1)

                Spacer()
            }

            // Optional: white border box to guide QR scanning
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white, lineWidth: 2)
                .frame(width: 250, height: 250)
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden()
    }
}
