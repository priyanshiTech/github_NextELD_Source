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
    case AddDvirPriTrip
    case DvirHostory(tittle: String)
    case NT11Connection
    case PT30Connection
    // Side Menu Screens
    case DailyLogs(tittle: String)
    case emailLogs(tittle: String)
    case RecapHours(tittle: String)
    // case AddDvirScreenView
    case AddDvirScreenView(selectedVehicle: String)
    case  ADDVehicle
    case DotInspection(tittle: String)
    //  With associated value
    case LogsDetails(title: String, entry: WorkEntry)
    case EyeViewData(tittle: String)
    case CoDriverLogin
    case NewDriverLogin(title: String)
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
    
}



struct RootView: View {
    
    @EnvironmentObject var navManager: NavigationManager
    @State private var presentSideMenu: Bool = false
    @State private var selectedSideMenuTab: Int = 0
    @State private var selectedVehicle: String = ""
    @State private var language: String = ""
    @State private var isLogoutPresented: Bool = false
    @State private var isCycleCompleted: Bool = false
    @State private var hasCheckedSession = false
    @EnvironmentObject var loginVM: LoginViewModel
    @StateObject var session = SessionManager()
    @State private var isLoggedIn = SessionManagerClass.shared.isLoggedIn()
    
    
    var body: some View {
        
        NavigationStack(path: $navManager.path) {
           
            Group {
                if isLoggedIn == false {
                    SplashView()
                  
                } else {
                    DeviceScannerView(tittle: "", checkboxClick: false, macaddress: "")
                }
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
                    DailyLogView(title: title, entry: WorkEntry(date: Date(), hoursWorked: 0)) // ←default/fake data
                case .emailLogs( let tittle):
                    EmailLogs(title: tittle)
                case .RecapHours(let tittle):
                    HoursRecap(tittle: tittle)
                case .LogsDetails(let title, let entry):
                    LogsDetails(title: title, entry: entry)
                case .CertifySelectedView(let tittle):
                    CertifySelectedView(title: tittle)
                    
                case .AddDvirPriTrip:
                    EmailDvir( tittle: "")
                    
                case .DvirHostory( let title ):
                    DVIRHistory(title: title)
                    
                case .DotInspection(let titlle):
                    DotInspection( title: titlle)
                    
                case .EyeViewData:
                    EyeViewData(tittle: "Daily Logs", selectedDate: Date())
                    
                case .AddDvirScreenView:
                    AddDvirScreenView(selectedVehicle: $selectedVehicle)
                    
                case .ADDVehicle:
                    ADDVehicle(selectedVehicleNumber: $selectedVehicle)
                    
                case .CoDriverLogin:
                    CoDriverLogin()
                    
                case .NewDriverLogin:
                    NewDriverLogin()
                    
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



























