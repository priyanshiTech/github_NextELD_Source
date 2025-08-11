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

            }
        }

        var method: String {
            switch self {
            case .login, .ForgetPassword , .ForgetUserName ,  .update_dvir_data , .viewdriveringstatusbydate:
                return "POST"
            case .ForSavingOfflineData , .getAllDatadelete , .dispatchadd_dvir_data , .getRefershAlldata:
                return "POST"

            }
        }
    }
}






//MARK: -

final class NetworkManager {
    static let shared = NetworkManager()
    public init() {}

    func post<T: Decodable, U: Encodable>(_ endpoint: API.Endpoint, body: U) async throws -> T {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = endpoint.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

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

