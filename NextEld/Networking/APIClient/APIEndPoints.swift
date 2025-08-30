//
//  APIEndPoints.swift
//  NextEld
//
//  Created by priyanshi on 18/06/25.
//
import Foundation
import SwiftUI
import Foundation


enum API {
    
    static let baseURL = URL(string: "https://gbt-usa.com/eld_log/")!
    static let baseURLTwo = URL(string: "http://165.232.183.179:4002/api/")!

    enum Endpoint {
        case login
        case ForgetPassword
        case ForgetUserName
        case ForSavingOfflineData
        case getAllDatadelete
        case dispatchadd_dvir_data
        case update_dvir_data
        case getRefershAlldata
        case viewdriveringstatusbydate
        case CompanyDriverInformation
        case HelpSupportInfo
        case CodriverListInfo
        case certifyDriver
        case LoginLogAPI   //MARK: -  LogLogin
        case LogoutAPI
        case DefectAPIModel
        case EmailDVirAPI
        case VchicleList
        case ForRulesAPI
        case MacAddress
        case ConnectdDisConnectedAPI
        case FirmWareUPdates

        
        var url: URL {
            switch self {
            case .login:
                return API.baseURL.appendingPathComponent("auth/login")
                
            case . ForgetPassword:
                return API.baseURL.appendingPathComponent("auth/forgot_password")
                
            case .ForgetUserName:
                return API.baseURL.appendingPathComponent("auth/forgot_username")
                
            case .ForSavingOfflineData:
                return API.baseURL.appendingPathComponent("dispatch/add_drivering_status_offline")
                
            case .getAllDatadelete:
                return API.baseURL.appendingPathComponent("dispatch/delete_all_driver_status_by_id")
                
            case .dispatchadd_dvir_data:
                return API.baseURL.appendingPathComponent("dispatch/add_dvir_data")
                
            case .update_dvir_data:
                return API.baseURL.appending(components: "dispatch/update_dvir_data")
                
            case .getRefershAlldata:
                return API.baseURL.appendingPathComponent("auth/login_data_by_employee_id")
                
            case .viewdriveringstatusbydate:
                return API.baseURL.appendingPathComponent("dispatch/view_drivering_status_by_date")
                
            case .CompanyDriverInformation:
                return API.baseURL.appendingPathComponent("master/view_driver_information")
                
            case .HelpSupportInfo:
                //return API.baseURL.appendingPathComponent("dispatch/add_eld_support")
                return API.baseURLTwo.appendingPathComponent("driver/messageToSupport")
                
            case .CodriverListInfo:
                return API.baseURL.appendingPathComponent("master/view_employee_by_client")
            case .certifyDriver:
                return API.baseURL.appendingPathComponent("dispatch/add_certified_log")
            case .LoginLogAPI:
                return API.baseURL.appendingPathComponent("auth/update_login_with_login_log")
            case .LogoutAPI:
                return API.baseURL.appendingPathComponent("auth/logout_api")
            case .DefectAPIModel:
                return API.baseURL.appendingPathComponent("master/view_defect")
            case .EmailDVirAPI:
                return API.baseURL.appendingPathComponent("dispatch/view_dvir_data")
            case .VchicleList:
                return API.baseURL.appendingPathComponent("master/view_active_vehicle")
            case .ForRulesAPI:
                return API.baseURL.appendingPathComponent("master/view_employee")
            case .MacAddress:
                return API.baseURL.appendingPathComponent("master/add_mac_address")
            case .ConnectdDisConnectedAPI:
                return API.baseURL.appendingPathComponent("master/add_device_status")
            case .FirmWareUPdates:
                return  API.baseURL.appendingPathComponent("dispatch/view_last_eld_ota")
            }
        }

        var method: String {
            
            switch self {
                
            case .login, .ForgetPassword , .ForgetUserName ,  .update_dvir_data , .viewdriveringstatusbydate , .HelpSupportInfo , .CodriverListInfo, .LoginLogAPI , .ForRulesAPI , .ConnectdDisConnectedAPI:
                return "POST"
            case .ForSavingOfflineData , .getAllDatadelete , .dispatchadd_dvir_data , .getRefershAlldata , .CompanyDriverInformation, .certifyDriver , .LogoutAPI  , .DefectAPIModel, .EmailDVirAPI , .VchicleList ,  .MacAddress , .FirmWareUPdates:
                return "POST"
           
  
            }
        }
    }
}

//MARK: -  for Curl


private func printCurlCommand(for request: URLRequest) {
    guard let url = request.url else { return }
    var curlCommand = "curl"

    // HTTP method
    if let method = request.httpMethod {
        curlCommand += " -X \(method)"
    }

    // Headers
    if let headers = request.allHTTPHeaderFields {
        for (key, value) in headers {
            curlCommand += " -H '\(key): \(value)'"
        }
    }

    // Body
    if let httpBody = request.httpBody,
       let bodyString = String(data: httpBody, encoding: .utf8),
       !bodyString.isEmpty {
        curlCommand += " -d '\(bodyString.replacingOccurrences(of: "'", with: "\\'"))'"
    }

    // URL
    curlCommand += " '\(url.absoluteString)'"

    print("\n📡 Generated cURL Command:")
    print(curlCommand)
}


//MARK: -

final class NetworkManager {
    static let shared = NetworkManager()
    public init() {}

    func post<T: Decodable, U: Encodable>(_ endpoint: API.Endpoint, body: U) async throws -> T {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = endpoint.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        printCurlCommand(for: request)
        
        let encodedBody = try JSONEncoder().encode(body)
        request.httpBody = encodedBody

        print("🌍 URL: \(endpoint.url)")
        print("📝 Method: \(endpoint.method)")
        print("📤 Content-Type: application/json")
        if let bodyString = String(data: encodedBody, encoding: .utf8) {
            print("**************** JSON Body: \(bodyString)")
        }

        let (data, response) = try await URLSession.shared.data(for: request)
        

        if let httpResponse = response as? HTTPURLResponse {
            print("___________ Status Code: \(httpResponse.statusCode)")
        }

        if let string = String(data: data, encoding: .utf8) {
            print("$$$$$$$$$$$$$$$______Response Body: \(string)")
        }

        return try JSONDecoder().decode(T.self, from: data)
    }

}

