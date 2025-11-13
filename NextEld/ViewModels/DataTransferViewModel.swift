//
//  DataTransferViewModel.swift
//  NextEld
//
//  Created by priyanshi   on 11/11/25.
//

import Foundation
@MainActor
class DataTransferViewModel: ObservableObject {
    @Published var certifyRecords: [DataTraModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var signature: String?
    @Published var  dataTransferTypes = ["Email", "Web Service"]
    @Published var fromDate: Date = Date()
    @Published var toDate: Date = Date()
    @Published var dataTransferType: String = "Email"
    @Published var email: String = ""
    @Published var comments: String = ""
    @Published var showFromDatePicker = false
    @Published var showToDatePicker = false
    @Published var showDataTransferTypePicker = false
    @Published var fromDateSelected = false
    @Published var toDateSelected = false
    @Published var showAlert = false
    @Published var alertMessage = ""

    private let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    func transferData(email: String, fromDate: String , toDate: String) async {
        isLoading = true
        errorMessage = nil
        signature = nil

        let requestBody = DataTraModel(
            driverId: AppStorageHandler.shared.driverId ?? 0,
            email: email,
            fromDate: fromDate,
            toDate: toDate
        )

        do {
            let response: DataTransferResponse = try await networkManager.post(
                .dataTransferAPI,
                body: requestBody
            )

            self.signature = response.signature
        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }
    
     func apiDateString(for date: Date, isStartOfDay: Bool) -> String {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? TimeZone.current
        let adjustedDate: Date
        if isStartOfDay {
            adjustedDate = calendar.startOfDay(for: date)
        } else {
            adjustedDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: date) ?? date
        }
        let formatter = DateFormatter()
        formatter.timeZone = calendar.timeZone
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: adjustedDate)
    }
    
     func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
    
     func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

struct DataTransferResponse: Codable {
    let signature: String?
}


