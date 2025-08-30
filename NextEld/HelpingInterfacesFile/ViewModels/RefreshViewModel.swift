//
//  RefreshViewModel.swift
//  NextEld
//
//  Created by priyanshi  on 04/08/25.
//
import Foundation


@MainActor
class RefreshViewModel: ObservableObject {
    @Published var loginResponse: TokenModelLog?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    
    
    var latestDriverLog: DriverLog? {
        loginResponse?.result?.driverLog?.last
      }

    func refresh() async {
        isLoading = true

        let requestBody = EmployeeToken(
            employeeId:   DriverInfo.driverId ?? 0,
            tokenNo: DriverInfo.authToken
        )

        print("Request Body: \(requestBody)")

        do {
            let response: TokenModelLog = try await NetworkManager.shared.post(
                .getRefershAlldata,
                body: requestBody
            )
         //   print("API Response: \(response)")
            self.loginResponse = response

        } catch {
            self.errorMessage = error.localizedDescription
            print("Network error: \(error.localizedDescription)")
        }

        isLoading = false
    }
}
