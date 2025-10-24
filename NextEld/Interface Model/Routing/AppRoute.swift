//
//  AppRoute.swift
//  NextEld
//
//  Created by Priyanshi on 07/05/25.
//

import Foundation
import SwiftUI


import Foundation
import SwiftUI

enum ApplicationRoot {
    case splashScreen
    case login
    case scanner
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
        case scanner
        case Settings
        case SupportView
        case FirmWare_Update
        case ADDVehicle
        case CertifySelectedView(tittle: String)
 
        
    }
    
    enum DvirFlow: Hashable{
        case AddDvirScreenView
        case emailLogs(tittle: String)
        case DvirHostory(tittle: String)
        case trailerScreen
        case ShippingDocment
        case AddVehicleForDVIR
        
    }
   // case scanner
    
    enum DatabaseFlow: Hashable {
        
        case DatabaseCertifyView
        case DriverLogListView
        case DvirDataListView
        case ContinueDriveTableView
    }


    
    //MARK: -  Cases of Add dvirPri trip

    case NT11Connection
    case PT30Connection
    // Side Menu Screens
    
    
    case RecapHours(tittle: String)
    


    
    case DataTransferView


    //  With associated value
    case LogsDetails(title: String, entry: WorkEntry)
    case EyeViewData(tittle: String , entry : WorkEntry )
   
    case NewDriverLogin(title: String , email: String)
    //Vichle Mode

    case Logout
    

    
}


