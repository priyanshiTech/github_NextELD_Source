//
//  DeleteViewModel.swift
//  NextEld
//DELETE API FOR WHOLE APP
//  Created by Priyanshi on 22/07/25.
//
import Foundation
import SwiftUI

@MainActor
class DeleteViewModel: ObservableObject {
    @Published var apiMessage: String = ""
    @Published var isSessionExpired: Bool = false
    var appRootManager: AppRootManager?

    func deleteAllDataOnVersionClick(driverId: Int) async -> Bool {
        isSessionExpired = false
        do {
            let response: DeleteDriverResponse = try await NetworkManager.shared.post(
                .getAllDatadelete,
                body: DeleteAllDriverStatusRequest(driverId: driverId)
            )
            
            
 //        print(" Delete API Response token: \(response.token ?? "nil")")
//            if let tokenValue = response.token?.lowercased(), tokenValue == "false" {
//                
//                isSessionExpired = true
//                // print(" Session expired detected during delete")
//                // print(" appRootManager is \(appRootManager != nil ? "set" : "nil")")
//                appRootManager?.currentRoot = .SessionExpireUIView
//                return false
//            }

            if response.status == "SUCCESS" {
                self.apiMessage = response.message ?? "Deleted successfully"

                //MARK: -   Delete all local DB data
               return true
            } else {
                self.apiMessage = response.message ?? "Failed to delete"
                return false
            }

        } catch {
            self.apiMessage = "Error: \(error.localizedDescription)"
            return false
        }
    }
}
