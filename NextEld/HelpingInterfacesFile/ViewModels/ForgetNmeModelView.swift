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

    func submitForgetUsername() async {
        print("Sending Forget Username Request with email: \(email)")
        let request = ForgetPasswordRequest(username: email) // or update field to match actual API

        do {
            let response: ForgetUsernameResponse = try await NetworkManager.shared.post(.ForgetUserName, body: request)
            print("API Call Succeeded")
            print(" Message: \(response.message)")
            if let result = response.result {
                print("👤 Username Found: \(result.username)")
            }

            message = response.message
        } catch {
            print(" API Call Failed: \(error)")
            message = "Something went wrong: \(error.localizedDescription)"
        }

        showAlert = true
    }
}
