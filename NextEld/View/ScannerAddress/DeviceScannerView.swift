//
//  DeviceScannerView.swift
//  NextEld
//
//  Created by Priyanshi on 06/05/25.
//

import SwiftUI

struct DeviceScannerView: View {
    
   // @EnvironmentObject var navManager: NavigationManager
    @StateObject var navManager: NavigationManager = NavigationManager()

    @State private var showScanner = false
    @State private var scannedCode: String?
    @State var tittle = ""
    @State var checkboxClick : Bool
    @State var macaddress: String
    
    @StateObject private var deviceStatusVM = DeviceStatusViewModel(
         networkManager: NetworkManager()
     )
    var body: some View {
        NavigationStack(path: $navManager.path) {
            VStack (spacing: 0) {
                ZStack(alignment: .topLeading){
                    Color(uiColor: .wine)
                        .edgesIgnoringSafeArea(.top)
                        .frame(height:20)
                }
                HStack {
                    Button(action: {
                        
                        // navManager.navigate(to: AppRoute.vehicleFlow(.ADDVehicle))
                        navManager.navigate(to: AppRoute.HomeFlow.ADDVehicle)
                        
                    }) {
                        Image(systemName: "arrow.right.arrow.left")
                            .foregroundColor(.white)
                            .imageScale(.large)
                    }
                    Text (tittle.isEmpty ? "(No Vehicle Selected)" : tittle)
                    //(tittle)
                    
                        .font(.headline)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                    Spacer()
                }
                
                .padding()
                .background(Color(uiColor: .wine).shadow(radius: 1))
                .frame(height: 40, alignment: .topLeading)
                
                
                
                Spacer()
                VStack(alignment:.leading){
                    
                    Text("Select your Device Type and Enter The ELD Mac address Listed On The Device")
                        .lineLimit(nil)
                        .font(.system(size: 17))
                        .foregroundColor(.gray)
                        .padding()
                    
                    HStack {
                        CheckboxButton()
                        Text("PT - 30")
                        
                    }
                    .padding()
                    HStack {
                        CheckboxButton()
                        Text("NT - 11")
                        Spacer()
                        
                        Button(action: {showScanner = true}, label: {
                            Image("qr-scan")
                                .padding()
                        })
                    }
                    .padding()
                    HStack{
                        Image("")
                            .foregroundColor(Color(uiColor: .wine))
                        TextField("Type Mac address Here", text: $macaddress)
                    }
                    .padding()
                    .frame(height: 50)
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .padding()
                    Spacer()
                }
                VStack(alignment: .center){
                    
                    Button("Connect") { }
                        .bold()
                        .frame(width: 300 , height: 40)
                        .buttonStyle(.bordered)
                        .background(Color(uiColor: .wine))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                    
                    Button {
                        
                        Task {
                            await deviceStatusVM.updateDeviceStatus(status: "Disconnected")
                            
                            if deviceStatusVM.responseMessage != nil {
                                
                                // navManager.navigate(to: AppRoute.homeFlow(.home))
                                navManager.navigate(to: AppRoute.HomeFlow.Home)
                                
                            }
                        }
                    } label: {
                        if deviceStatusVM.isLoading {
                            ProgressView()
                                .frame(width: 300, height: 40)
                                .background(Color.black)
                                .cornerRadius(10)
                                .padding()
                        } else {
                            Text("Continue Disconnect")
                                .bold()
                                .frame(width: 300, height: 40)
                                .buttonStyle(.bordered)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding()
                        }
                    }
                    
                    //  Show API response/error feedback
                    if let error = deviceStatusVM.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .padding()
                    }
                    if let success = deviceStatusVM.responseMessage {
                        Text(success)
                            .foregroundColor(.green)
                            .padding()
                    }
                    Spacer()
                }
                Spacer()
                    .onAppear {
                        //  Load vehicle from UserDefaults
                        if let savedVehicle = UserDefaults.standard.string(forKey: "vehicleNo") {
                            tittle = savedVehicle
                            print("Loaded vehicle title: \(savedVehicle)")
                        }
                    }
            }
            
            //MARK:  to Show a Mac Address
            .fullScreenCover(isPresented: $showScanner) {
                _ScannerQR(macaddress: $macaddress)
                    .environmentObject(navManager)
            }
            
            .navigationDestination(for: AppRoute.HomeFlow.self) { route in
                switch route {
                case .Home:
                    HomeScreenView()
                case .DailyLogs(let title):
                    DailyLogView(title: title, entry: WorkEntry(date: Date(), hoursWorked: 0))
                case .AddDvirPriTrip:
                    EmailDvir(
                         tittle: "Email DVIR",
                        updateRecords: DvirDatabaseManager.shared.fetchAllRecords(), // or your source of records
                        onSelect: { selectedRecord in
                            print(" Selected Record: \(selectedRecord)")
                            // Optional: navigate or update state
                        }
                    )
                case .DotInspection(let title):
                        DotInspection(title: title)
                case .CoDriverLogin:
                    CoDriverLogin()
                case .AddVichleMode:
                    AddVichleMode(selectedVehicle: .constant(""), selectedVehicleId: .constant(0))
                case .CompanyInformationView:
                    CompanyInformationView()
                case .InformationPacket:
                    InformationPacket()
                case .RulesView:
                    RulesView()
                case .scanner:
                    DeviceScannerView(checkboxClick: true, macaddress: "")
                case .Settings:
                    SettingsLanguageView()
                case .SupportView:
                    SupportView()
                case .FirmWare_Update:
                    FirmWare_Update()
                case .ADDVehicle:
                    ADDVehicle(selectedVehicleNumber: .constant(""), VechicleID:  .constant(0))
                case .CertifySelectedView(let title):
                    CertifySelectedView( vehiclesc:  .constant(""), VechicleID: .constant(0), title: title)
          
                }
            }
        }
        .navigationBarHidden(true)
        .environmentObject(navManager)
    }
}
