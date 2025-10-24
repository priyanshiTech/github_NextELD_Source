//
//  HomeFlowView.swift
//  NextEld
//
//  Created by priyanshi on 08/10/25.
//

import SwiftUI

struct HomeFlowView: View {
    @Binding var presentSideMenu: Bool
    @Binding var selectedSideMenuTab: Int
    let session: SessionManager
    @EnvironmentObject var navManager: NavigationManager
    
    var body: some View {
        HomeScreenView(
            presentSideMenu: $presentSideMenu,
            selectedSideMenuTab: $selectedSideMenuTab,
            session: session
        )
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
        .navigationDestination(for: AppRoute.VehicleFlow.self) { route in
            switch route {
            case .ADDVehicle:
                ADDVehicle(selectedVehicleNumber: .constant(""), VechicleID: .constant(0))
            case .AddVichleMode:
                AddVichleMode(selectedVehicle: .constant(""), selectedVehicleId: .constant(0))
            case .AddVehicleForDVIR:
                AddVehicleForDvir(selectedVehicleNumber: .constant(""), VechicleID: .constant(0))
            case .AddDvirScreenView(let selectedVehicle, let selectedRecord, let isFromHome):
                AddDvirScreenView(
                    selectedVehicle: .constant(selectedVehicle),
                    selectedVehicleId: .constant(0),
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
                CertifySelectedView(vehiclesc: .constant(""), VechicleID: .constant(0), title: title)
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
