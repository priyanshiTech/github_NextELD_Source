//
//  SideMenuRow.swift
//  NextEld
//
//  Created by priyanshi on 12/05/25.
//

import Foundation
import SwiftUICore
import UIKit

struct AppInfo {
    static var version: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }
    
    static var build: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    }
}


enum SideMenuRowType: Int, CaseIterable{
    
    case DailyLogs
    case DvirPriTrip
    case DotInspection
    case coDriver
    case Vehicle
    case ELDConnection
    case Sync
    case companyInformation
    case InformationPocket
    case Rules
    case settings
    case support
    case FirmWareUpdate
    case logout
    case version

    // MARK: -  Daily Logs conected Pages
//    case emailLogs
//    case RecapHour
    
    var title: String {
        
        switch self {
            
        case .DailyLogs:
            return "Daily-Logs"
        case .DvirPriTrip:
            return "Dvir - Pri Trip"
        case .DotInspection:
            return "Dot Inspection"
        case .coDriver:
            return "Co-Driver"
        case .Vehicle:
            return "Vehicle"
        case .ELDConnection:
            return "ELD Connection"
        case .companyInformation:
            return "Company Info"
        case .InformationPocket:
            return "Information-Pocket"
        case .Rules:
            return "Rules"
        case .settings:
            return "Settings"
        case .support:
            return "Support"
     
        case .FirmWareUpdate:
            return "FirmWare Update"
        case .logout:
            return  "Logout"

        case .version:
            return "Version \(UIDevice.current.systemVersion) "
       
        case .Sync:
            return "Sync"
        }
        // (\(AppInfo.buildNumber))"
         
         //        case .emailLogs:
         //                return "Daily Logs"
         //        case .RecapHour:
       // return "Recap Hour"
         //
    }

    var iconName: String {
        
        switch self {
        case .DailyLogs: return "daily_log_ic"
        case .DvirPriTrip: return "dvir_trip"
        case .DotInspection: return "dot_ic"
        case .coDriver: return "person_icon"
        case .Vehicle: return "equipment_ic"
        case .companyInformation: return "company_ic"
        case .InformationPocket: return "user_menual"
        case .Rules: return "rukle"
        case .settings: return "settings_ic"
        case .support: return "contact_uc"
        case .ELDConnection: return "eld_connection_ic"
        case .FirmWareUpdate: return "firmawre_update"
        case .logout: return "logout_ic"
        case .version: return "AppleIcon"
        case .Sync: return "refresh"
            
            //        case .emailLogs: return "email_icon"
            //        case .RecapHour: return "alarm_icon"
        }
    }
}
