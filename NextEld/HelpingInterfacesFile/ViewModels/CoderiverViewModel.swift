//
//  CoderiverViewModel.swift
//  NextEld
//
//  Created by priyanshi on 13/08/25.
//
import Foundation
import Foundation

struct ClientEmployeeToken: Codable {
    let clientId: Int
    let employeeId: Int
    let tokenNo: String
}

// MARK: - ViewModel
@MainActor
class CertifyViewModel: ObservableObject {
    @Published var certifyRecords: [CodriverEmployee] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    func fetchCertifyData(driverId: Int, employeeID: Int, tokenNo: String) async {
        isLoading = true
        errorMessage = nil

        let requestBody = ClientEmployeeToken(
            clientId: driverId,
            employeeId: employeeID,
            tokenNo: tokenNo
        )

        do {
            let response: CodriverModel = try await networkManager.post(
                .CodriverListInfo,
                body: requestBody
            )

            if let records = response.result, !records.isEmpty {
                self.certifyRecords = records
            } else {
                self.errorMessage = "No certify data found."
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}


