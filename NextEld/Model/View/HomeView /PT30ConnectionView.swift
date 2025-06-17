//  PT30ConnectionView.swift
//  NextEld
//  Created by priyanshi on 04/06/25.

import SwiftUI
import MapKit

struct PT30ConnectionView: View {
    @EnvironmentObject var navManager: NavigationManager
    var tittle: String = "ELD Connection"
    
    @State private var isPasswordShowing: Bool = false
    @StateObject private var locationManager = LocationManager()
    @StateObject private var bluetoothVM = BluetoothViewModel()
    @State private var showInMiles = true
    @State private var showInCelsius = true
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 22.7196, longitude: 75.8577),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    @State private var showDeviceList = false
    
    var body: some View {
        VStack(spacing: 0) {
            Color(.blue)
                .ignoresSafeArea()
                .frame(height: 2)
            
            // Header
            HStack {
                Button(action: {
                    locationManager.stopUpdatingLocation()
                    navManager.goBack()
                }) {
                    Image(systemName: "arrow.left")
                        .bold()
                        .foregroundColor(.white)
                        .imageScale(.large)
                }
                
                Text(tittle)
                    .font(.headline)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPasswordShowing.toggle()
                        if isPasswordShowing {
                            locationManager.requestLocationPermission()
                            locationManager.startUpdatingLocation()
                        } else {
                            locationManager.stopUpdatingLocation()
                        }
                    }
                }) {
                    Image(systemName: isPasswordShowing ? "eye.fill" : "eye.slash.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                }
                .padding(.horizontal)
            }
            .padding()
            .background(Color.blue)
            .frame(height: 50)
            .zIndex(2)
            

            .background(Color.clear)
            .navigationBarBackButtonHidden()
     
            }
        }
    }

