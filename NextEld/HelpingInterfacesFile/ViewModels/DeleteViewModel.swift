//
//  DeleteViewModel.swift
//  NextEld
//
//  Created by Priyanshi on 22/07/25.
//
import Foundation
import SwiftUI

@MainActor
class DeleteViewModel: ObservableObject {
    @Published var apiMessage: String = ""

    func deleteAllDataOnVersionClick(driverId: Int) async {
        do {
            let response: DeleteDriverResponse = try await NetworkManager.shared.post(
                .getAllDatadelete,
                body: DeleteAllDriverStatusRequest(driverId: driverId)
            )

            if response.status == "SUCCESS" {
                self.apiMessage = response.message ?? "Deleted successfully"

                //MARK: -   Delete all local DB data
                DatabaseManager.shared.deleteAllLogs()
            } else {
                self.apiMessage = response.message ?? "Failed to delete"
            }

        } catch {
            self.apiMessage = "Error: \(error.localizedDescription)"
        }
    }
}
