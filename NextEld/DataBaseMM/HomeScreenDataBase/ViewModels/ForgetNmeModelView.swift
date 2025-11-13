//
//  ForgetNmeModelView.swift
//  NextEld
//
//  Created by priyanshi  on 02/07/25.
//

import Foundation
@MainActor
final class ForgetUsernameViewModel: ObservableObject {
    @Published var email = ""
    @Published var message = ""
    @Published var showAlert = false
    @Published var isSessionExpired: Bool = false
    var appRootManager: AppRootManager?

    func submitForgetUsername() async -> Bool {
        isSessionExpired = false
        print("Sending Forget Username Request with email: \(email)")
        let request = ForgetPasswordRequest(username: email) // or update field to match actual API

        do {
            let response: ForgetUsernameResponse = try await NetworkManager.shared.post(.ForgetUserName, body: request)
            print("API Call Succeeded")
            print(" Message: \(response.message)")
            print(" Token value: \(response.token ?? "nil")")
            if let tokenValue = response.token?.lowercased(), tokenValue == "false" {
                SessionManagerClass.shared.clearToken()
                isSessionExpired = true
                print(" Session expired detected in ForgetUsernameViewModel")
                appRootManager?.currentRoot = .SessionExpireUIView
                return false
            }
            if let result = response.result {
                print(" Username Found: \(result.username)")
            }

            message = response.message
            showAlert = true
            return true
        } catch {
            print(" API Call Failed: \(error)")
            message = "Something went wrong: \(error.localizedDescription)"
            showAlert = true
            return false
        }
    }
}
