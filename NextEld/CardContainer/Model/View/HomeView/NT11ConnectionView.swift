//  HomeScreenView.swift
//  NextEld
//  Created by priyanshi on 04/06/25.



import SwiftUI
import MapKit


struct NT11ConnectionView: View {
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
    
    private var isConnected: Bool {
        bluetoothVM.connectedDevice != nil
    }
    
    private var statusColor: Color {
        isConnected ? .green : .red
    }
    
    private var statusText: String {
        isConnected ? "Connected" : "Disconnected"
    }
    
    private var backgroundColor: Color {
        isConnected ? Color.green.opacity(0.1) : Color.red.opacity(0.1)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Color(.blue)
                .ignoresSafeArea()
                .frame(height: 2)
            
            // Header
            headerView
            
            ScrollView {
                VStack(spacing: 20) {
                    // Map (only shown when connected or eye button is active)
                    if isPasswordShowing {
                        mapView
                    }
                    
                    // Connection Status
                    connectionStatusView
                    
                    // Scan Button (if not connected)
                    if !showDeviceList && !isConnected {
                        scanButton
                    }
                    
                    if showDeviceList && !isConnected {
                        deviceListView
                    }
                    
                    dataView
                    
                    Spacer()
                }
                .onAppear {
                    bluetoothVM.startScanning()
                }
            }
            .background(Color.clear)
            .navigationBarBackButtonHidden()
            .onDisappear {
                locationManager.stopUpdatingLocation()
            }
            .onAppear {
                locationManager.requestLocationPermission()
            }
            .onChange(of: bluetoothVM.connectedDevice) { newValue in
                if newValue != nil {
                    isPasswordShowing = true
                    showDeviceList = false
                }
            }
        }
    }
    
    private var headerView: some View {
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
    }
    
    private var mapView: some View {
        ZStack {
            if locationManager.locationError != nil {
                locationErrorView
            } else {
                HalfScreenMapView(locationManager: locationManager)
            }
        }
        .transition(.opacity)
        .zIndex(1)
    }
    
    private var locationErrorView: some View {
        VStack {
            Image(systemName: "location.slash.fill")
                .font(.system(size: 40))
                .foregroundColor(.red)
                .padding()
            
            Text(locationManager.locationError ?? "Location error")
                .multilineTextAlignment(.center)
                .foregroundColor(.red)
                .padding()
            
            Button("Open Settings") {
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
            .foregroundColor(.blue)
            .padding()
        }
        .frame(height: 200)
    }
    
    private var connectionStatusView: some View {
        VStack(spacing: 15) {
            Text("NT11 Connection")
                .font(.title2)
                .bold()
            
            HStack(spacing: 10) {
                Image(systemName: "dot.radiowaves.left.and.right")
                    .foregroundColor(statusColor)
                    .font(.title2)
                
                Text(statusText)
                    .foregroundColor(statusColor)
                    .font(.headline)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(10)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 2)
        .padding(.horizontal)
    }
    
    private var scanButton: some View {
        Button(action: {
            bluetoothVM.startScanning()
            showDeviceList = true
        }) {
            Text("Start Scan")
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: 150)
                .background(Color.blue)
                .cornerRadius(12)
        }
        .padding(.horizontal)
    }
    
    private var deviceListView: some View {
        VStack {
            Text("Scan result (tap to connect)")
            VStack(spacing: 10) {
                ForEach(bluetoothVM.discoveredDevices.filter { $0.name != nil }, id: \.identifier) { device in
                    deviceRow(device)
                }
            }
            .padding(.top)
        }
    }
    
    private func deviceRow(_ device: CBPeripheral) -> some View {
        HStack {
            Text(device.name ?? "Unknown")
            Spacer()
            Text("\(device.rssi) dBm")
                .foregroundColor(device.rssi > -60 ? .green : (device.rssi > -80 ? .orange : .red))
                .font(.subheadline)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
        }
        .padding(.horizontal)
        .onTapGesture {
            bluetoothVM.connect(to: device)
        }
    }
    
    private var dataView: some View {
        UniversalScrollView {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Date: \(bluetoothVM.parsedData.date)")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.gray)
                    Spacer()
                }
                Group {
                    ToggleRow(title: "Speed (GPS)", value: bluetoothVM.parsedData.speed, isMiles: showInMiles)
                    Divider()
                    ToggleRow(title: "Vehicle Speed", value: bluetoothVM.parsedData.vehicleSpeed, isMiles: showInMiles)
                    Divider()
                    DataRow(title: "RPM", value: bluetoothVM.parsedData.rpm, unit: "")
                    Divider()
                    ToggleRow(title: "Coolant Temp", value: bluetoothVM.parsedData.coolantTemp, isCelsius: showInCelsius)
                    Divider()
                    ToggleRow(title: "Fuel Temp", value: bluetoothVM.parsedData.fuelTemp, isCelsius: showInCelsius)
                    Divider()
                    ToggleRow(title: "Oil Temp", value: bluetoothVM.parsedData.oilTemp, isCelsius: showInCelsius)
                    Divider()
                    ToggleRow(title: "Odometer", value: bluetoothVM.parsedData.odometer, isMiles: showInMiles)
                    Divider()
                    DataRow(title: "Fuel Level", value: "75", unit: "")
                    Divider()
                }
                Group {
                    DataRow(title: "Mac Address", value: bluetoothVM.parsedData.macAddress, unit: "")
                    Divider()
                    DataRow(title: "Firmware Version", value: bluetoothVM.parsedData.firmwareVersion, unit: "")
                    Divider()
                    DataRow(title: "Hardware Version", value: bluetoothVM.parsedData.hardwareVersion, unit: "")
                }
            }
            .padding(.horizontal)
        }
    }
}

