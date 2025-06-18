//
//  SideMenuRow.swift
//  NextEld
//
//  Created by priyanshi on 12/05/25.
//

import Foundation

enum SideMenuRowType: Int, CaseIterable{
    
    case DailyLogs
    case DvirPriTrip
    case DotInspection
    case coDriver
    case Vehicle
    case companyInformation
    case InformationPocket
    case Rules
    case ELDConnection
    case settings
    case support
    case FirmWareUpdate
    case logout
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
        case .companyInformation:
            return "Company Info"
        case .InformationPocket:
            return "Information-Pocket"
        case .Rules:
            return   "Rules"
        case .settings:
            return "Settings"
        case .support:
            return "Support"
        case .ELDConnection:
            return "ELD Connection"
        case .FirmWareUpdate:
            return "FirmWare Update"
        case .logout:
            return  "Logout"
//        case .emailLogs:
//                return "Daily Logs"
//        case .RecapHour:
//            return "Recap Hour"
        }
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
//        case .emailLogs: return "email_icon"
//        case .RecapHour: return "alarm_icon"
        }
    }
}
