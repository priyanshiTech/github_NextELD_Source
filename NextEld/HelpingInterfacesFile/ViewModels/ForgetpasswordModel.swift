//
//  ForgetpasswordModel.swift
//  NextEld
//
//  Created by Priyanshi   on 02/07/25.
//

import Foundation
import SwiftUI
@MainActor

struct ForgetPasswordResponse: Codable {
    let result: ForgetPasswordResult?
    let arrayData: String?
    let status: String
    let message: String
    let token: String?
}
struct ForgetPasswordRequest: Encodable {
    let username: String
}

@MainActor
final class ForgetPasswordViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var message: String = ""
    @Published var showAlert = false

    func submitForgetPassword() async {
        let request = ForgetPasswordRequest(username: username)

        print("📤 Sending Forget Password Request with username: \(username)")

        do {
            
            let response: ForgetPasswordResponse = try await NetworkManager.shared.post(.ForgetPassword, body: request)
            print(" API Call Succeeded")
            print(" Status: \(response.status)")
            print(" Message: \(response.message)")

            if let result = response.result {
                print(" Username: \(result.username)")
                print(" Email: \(result.email)")
                print(" Mobile No: \(result.mobileNo)")
                print(" Employee ID: \(result.employeeId)")
                print(" Token No: \(result.tokenNo)")
                print(" Login Time: \(result.loginDateTime)")
                print(" Logout Time: \(result.logoutDateTime)")
                print(" Is Co-Driver: \(result.isCoDriver)")
            }

            message = response.message
        } catch {
            print(" API Call Failed with error: \(error)")
            message = "Something went wrong: \(error.localizedDescription)"
        }

        showAlert = true
    }
}
