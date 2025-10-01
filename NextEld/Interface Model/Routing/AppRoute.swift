//
//  AppRoute.swift
//  NextEld
//
//  Created by Priyanshi on 07/05/25.
//

import Foundation
import SwiftUI

enum AppRoute: Hashable {

    case SplashScreen
    case ForgetPassword(tittle: String)
    case ForgetUser(tittle: String)
    case Home
    case Scanner
    case Login
    case CertifySelectedView(tittle: String)
    case DatabaseCertifyView
    case AddDvirPriTrip
    //MARK: -  Cases of Add dvirPri trip
    
    case trailerScreen
    case ShippingDocment
    case DvirHostory(tittle: String)
    case NT11Connection
    case PT30Connection
    // Side Menu Screens
    case DailyLogs(tittle: String)
    case emailLogs(tittle: String)
    case RecapHours(tittle: String)
    case ContinueDriveTableView
    case AddDvirScreenView(
        selectedVehicle: String,
        selectedRecord: DvirRecord
    )
    case AddVehicleForDVIR
    case  ADDVehicle
    case DotInspection(tittle: String)
    case DataTransferView

    //  With associated value
    case LogsDetails(title: String, entry: WorkEntry)
    case EyeViewData(tittle: String , entry : WorkEntry )
    case CoDriverLogin
    case NewDriverLogin(title: String , email: String)
    //Vichle Mode
    case AddVichleMode
    case CompanyInformationView
    case InformationPacket
    case RulesView
    case Settings
    case SupportView
    case Logout
    case FirmWare_Update
    case DriverLogListView
    case DvirDataListView
    
}



struct RootView: View {
    
    @EnvironmentObject var navManager: NavigationManager
    @State private var presentSideMenu: Bool = false
    @State private var selectedSideMenuTab: Int = 0
    @State private var selectedVehicle: String = ""
    @State private var VehicleID: Int = 0

    @State private var emailAuto: String = ""
    @State private var language: String = ""
    @State private var isLogoutPresented: Bool = false
    @State private var isCycleCompleted: Bool = false
    @State private var hasCheckedSession = false
    @EnvironmentObject var loginVM: LoginViewModel
    @StateObject var session = SessionManager()
    @State private var isLoggedIn = SessionManagerClass.shared.isLoggedIn()
   

    
    @available(iOS 16.0, *)
    var body: some View {
        
        NavigationStack(path: $navManager.path) {
            Group {
                    SplashView()
            }
            .onAppear {
                checkAutoLogin()  //Auto login check when view appears
            }
           // SplashView()
            .navigationDestination(for: AppRoute.self) { route in
                
                switch route {
                case .SplashScreen:
                    SplashView()
                case .ForgetPassword(let title):
                    ForgetPasswordView(title: title)
                case .ForgetUser(let title):
                    ForgetUserName(title: title)
                case .Scanner:
                    DeviceScannerView(tittle: "", checkboxClick: false, macaddress: "")
                case .Login:
                    LoginScreen(isLoggedIn: $isLoggedIn)  //Correct
                case .Home:
                    HomeScreenView(presentSideMenu: $presentSideMenu, selectedSideMenuTab: $selectedSideMenuTab, session: session)
                case .NT11Connection:
                    NT11ConnectionView()
                case .PT30Connection:
                    PT30ConnectionView()
                case .DailyLogs(let title):
                    DailyLogView(title: title, entry: WorkEntry(date: Date(), hoursWorked: 0))
                    
//                case .DailyLogs(let title):
//                    DailyLogView(title: title, entry: WorkEntry(date: Date(), hoursWorked: 0), logs: [])
                    
                case .emailLogs( let tittle):
                    EmailLogs(title: tittle)
                case .RecapHours(let tittle):
                    HoursRecap(tittle: tittle)
                case .LogsDetails(let title, let entry):
                    LogsDetails(title: title, entry: entry)
                case .CertifySelectedView(let tittle ):
                    CertifySelectedView( vehiclesc:  $selectedVehicle, VechicleID: $VehicleID, title: tittle)
                case .AddDvirPriTrip:
                    EmailDvir(
                        tittle: "Email DVIR",
                        updateRecords: DvirDatabaseManager.shared.fetchAllRecords(), // or your source of records
                        onSelect: { selectedRecord in
                            print(" Selected Record: \(selectedRecord)")
                            // Optional: navigate or update state
                        }
                    )

                case .DvirHostory( let title ):
                    DVIRHistory(title: title)
                    
                case .DotInspection(let titlle):
                    DotInspection( title: titlle)
                    
                case .EyeViewData(let title, let entry):
                    EyeViewData(title: title, entry: entry)
                    
                case .AddDvirScreenView:
                    AddDvirScreenView(
              
                           selectedVehicle: $selectedVehicle,
                           selectedVehicleId: $VehicleID,
                           
                        selectedRecord: DvirRecord(
                            
                            id: nil,
                            driver: "",
                            time: "",
                            date: "",
                            odometer: 0.0,
                            company: "",
                            location: "",
                            vehicleID: "",
                            trailer: "",
                            truckDefect: "",
                            trailerDefect: "",
                            vehicleCondition: "",
                            notes: "", engineHour: 0,
                            signature: nil
                        ),
                    )

                    
                case .ADDVehicle:
                    ADDVehicle(selectedVehicleNumber: $selectedVehicle, VechicleID:  $VehicleID)

                case .CoDriverLogin:
                    CoDriverLogin()
                    
//                case .NewDriverLogin:
//                    NewDriverLogin(isLoggedIn: $isLoggedIn, tittle: "Co-Driver Log-In", email: emailAuto)
                    
                case .NewDriverLogin(let title, let email):
                    NewDriverLogin(isLoggedIn: $isLoggedIn, tittle: title, UserName: email)
                        .id(email)
                    
                case .AddVichleMode:
                    AddVichleMode(selectedVehicle: $selectedVehicle)
                    
                case .CompanyInformationView:
                    CompanyInformationView()
                    
                    
                case .InformationPacket:
                    InformationPacket()
                    
                case .RulesView:
                    RulesView()
                    
                case .Settings:
                    SettingsLanguageView()
                    
                case .SupportView:
                    SupportView()
                    
                case .Logout:
                    LogOut()
                    
                case .FirmWare_Update:
                    FirmWare_Update()
                    
                case .DriverLogListView:
                    DriverLogListView()
                    
                case .trailerScreen:
                    TrailerView(tittle:"Trailer")
                    
                case .DvirDataListView:
                    DvirListView()
                    
                case .ShippingDocment:
                    ShippingDocView(tittle: "Shipping Document")
                    
                case .DatabaseCertifyView:
                    DatabaseCertifyView()
                    
                case .DataTransferView:
                    DataTransferInspectionView()
                    
                case .AddVehicleForDVIR:
                    AddVehicleForDvir(selectedVehicleNumber: $selectedVehicle, VechicleID: $VehicleID)
                case .ContinueDriveTableView:
                    ContinueDriveTableView()
                }
                
            }
            
            
            
        }
        
    }
    func checkAutoLogin() {
        if SessionManagerClass.shared.isLoggedIn() {
            isLoggedIn = true
            print(" Auto-login: token found. Redirecting to Home.")
        } else {
            isLoggedIn = false
            print(" Auto-login: token not found. Showing Login.")
        }
    }
    
}



























