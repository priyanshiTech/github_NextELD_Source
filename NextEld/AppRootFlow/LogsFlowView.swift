//
//  LogsFlowView.swift
//  NextEld
//
//  Created by priyanshi on 08/10/25.
//

import SwiftUI

struct LogsFlowView: View {
    @Binding var selectedVehicle: String
    @Binding var vehicleID: Int
    @EnvironmentObject var navManager: NavigationManager
    
    var body: some View {
        // Default logs view
        Text("Logs Flow")
        // ALL navigation destinations for ALL AppRoute types
            .navigationDestination(for: AppRoute.LoginFlow.self) { route in
                switch route {
                case .login:
                    LoginScreen(isLoggedIn: .constant(false))
                case .ForgetPassword(let title):
                    ForgetPasswordView(title: title)
                case .ForgetUser(let title):
                    ForgetUserName(title: title)
                case .newDriverLogin(let title, let email):
                    NewDriverLogin(isLoggedIn: .constant(false), tittle: title, UserName: email)
                case .CoDriverLogin:
                    CoDriverLogin()
                }
            }
            .navigationDestination(for: AppRoute.HomeFlow.self) { route in
                switch route {
                case .SplashScreen:
                    SplashView()
                case .home:
                    HomeScreenView(
                        presentSideMenu: .constant(false),
                        selectedSideMenuTab: .constant(0),
                        session: SessionManager()
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
            .navigationDestination(for: AppRoute.VehicleFlow.self) { route in
                switch route {
                case .ADDVehicle:
                    ADDVehicle(selectedVehicleNumber: $selectedVehicle, VechicleID: $vehicleID)
                case .AddVichleMode:
                    AddVichleMode(selectedVehicle: $selectedVehicle, selectedVehicleId: $vehicleID)
                case .AddVehicleForDVIR:
                    AddVehicleForDvir(selectedVehicleNumber: $selectedVehicle, VechicleID: $vehicleID)
                case .AddDvirScreenView(let selectedVehicle, let selectedRecord, let isFromHome):
                    AddDvirScreenView(
                        selectedVehicle: $selectedVehicle,
                        selectedVehicleId: $vehicleID,
                        selectedRecord: selectedRecord,
                        isFromHome: isFromHome
                    )
                case .PT30Connection:
                    PT30ConnectionView()
                case .NT11Connection:
                    NT11ConnectionView()
                case .trailerScreen:
                    TrailerView(tittle: "Trailer")
                case .ShippingDocment:
                    ShippingDocView(tittle: "Shipping Document")
                case .DotInspection(let title):
                    DotInspection(title: title)
                }
            }
            .navigationDestination(for: AppRoute.LogsFlow.self) { route in
                switch route {
                case .DailyLogs(let title):
                    DailyLogView(title: title, entry: WorkEntry(date: Date(), hoursWorked: 0))
                case .EmailLogs(let title):
                    EmailLogs(title: title)
                case .RecapHours(let title):
                    HoursRecap(tittle: title)
                case .continueDriveTableView:
                    ContinueDriveTableView()
                case .DatabaseCertifyView:
                    DatabaseCertifyView()
                case .CertifySelectedView(let title):
                    CertifySelectedView(vehiclesc: $selectedVehicle, VechicleID: $vehicleID, title: title)
                case .LogsDetails(let title, let entry):
                    LogsDetails(title: title, entry: entry)
                case .EyeViewData(let title, let entry):
                    EyeViewData(title: title, entry: entry)
                case .driverLogListView:
                    DriverLogListView()
                case .DvirDataListView:
                    DvirListView()
                case .AddDvirPriTrip:
                    EmailDvir(
                        tittle: "Email DVIR",
                        updateRecords: DvirDatabaseManager.shared.fetchAllRecords(),
                        onSelect: { _ in }
                    )
                case .DvirHostory(let title):
                    DVIRHistory(title: title)
                case .DataTransferView:
                    DataTransferInspectionView()
                }
            }
            .navigationDestination(for: AppRoute.InfoFlow.self) { route in
                switch route {
                case .CompanyInformationView:
                    CompanyInformationView()
                case .InformationPacket:
                    InformationPacket()
                case .RulesView:
                    RulesView()
                }
            }
    }
}
