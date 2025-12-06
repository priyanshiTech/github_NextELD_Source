//
//  AppRoute.swift
//  NextEld
//
//  Created by Priyanshi on 07/05/25.
//

import Foundation
import SwiftUI


enum ApplicationRoot: Hashable {
    
    case splashScreen
    case login
    case scanner(moveToHome: Bool = false)
    case SessionExpireUIView
    case DisclaimerView
    
}

enum AppRoute: Hashable {
    
    enum LoginFlow: Hashable {
        
        case forgetPassword(tittle: String)
        case forgetUser(tittle: String)
    }
    
    enum HomeFlow: Hashable {
        case Home
        case DailyLogs(tittle: String)
        case AddDvirPriTrip
        case DotInspection(tittle: String)
        case CoDriverLogin
        case AddVichleMode
        case CompanyInformationView
        case InformationPacket
        case RulesView
        case Settings
        case TermsAndCondition
        case SupportView
        case FirmWare_Update
        case ADDVehicle
        case NewDriverLogin(title: String , email: String)
        case CertifySelectedView(tittle: String)
        
    }
    
    enum HomeDashboardFlow: Hashable {
        case BlockView
        
    }
    
    enum AddDVIRFlow: Hashable {
        case trailerScreen
        case ShippingDocment
        case AddVehicleForDVIR
    }
    
    enum DvirFlow: Hashable{
        case AddDvirScreenView
        case emailLogs(tittle: String)
        case DvirHostory(tittle: String)
        
        case UploadDefectView
        
    }
    enum LogsFlow: Hashable {
        case DailyLogs(title: String)
        case EmailLogs(title: String)
        case RecapHours(title: String)
        case continueDriveTableView
        case DatabaseCertifyView
        case CertifySelectedView(title: String)
        case LogsDetails(title: String, entry: WorkEntry)
        case EyeViewData(title: String, entry: WorkEntry)
        case driverLogListView
        case DvirDataListView
        case AddDvirPriTrip
        case DvirHostory(title: String)
        case DataTransferView
    }
   // case scanner
    
    enum DatabaseFlow: Hashable {
        case DatabaseCertifyView
        case DriverLogListView
        case DvirDataListView
        case ContinueDriveTableView
        case EyeViewData(tittle: String , entry : WorkEntry )
    }

    enum BluetoothDeviceFlow: Hashable {
        case NT11Connection
        case PT30Connection
    }
    
    //MARK: -  Cases of Add dvirPri trip
    case scanner
    // Side Menu Screens
    case RecapHours(tittle: String)
    case DataTransferView
    //  With associated value
    case LogsDetails(title: String, entry: WorkEntry)
    //Vichle Mode
    case Logout
    

    
}


