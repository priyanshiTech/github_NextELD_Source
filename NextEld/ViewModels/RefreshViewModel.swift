//
//  RefreshViewModel.swift
//  NextEld
//
//  Created by priyanshi  on 04/08/25.

import Foundation

@MainActor
class RefreshViewModel: ObservableObject {
    
    
    @Published var loginResponse: TokenModelLog?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    var latestDriverLog: ServerDriverLog? {
        loginResponse?.result?.driverLog?.last
      }

    func refresh() async {
        NotificationCenter.default.post(name: .refreshStarted, object: nil)
        isLoading = true
        errorMessage = nil

        let requestBody = EmployeeToken(
            employeeId: AppStorageHandler.shared.driverId ?? 0,
            tokenNo: AppStorageHandler.shared.authToken ?? "",
        )

        print("Request Body: \(requestBody)")

        do {
            let response: TokenModelLog = try await NetworkManager.shared.post(
                .getRefershAlldata,
                body: requestBody
            )
            self.loginResponse = response
            applyRefreshResponse(response)
            isLoading = false
            
            // Broadcast refresh success
            NotificationCenter.default.post(
                name: .refreshCompleted,
                object: nil,
                userInfo: ["status": "success",
                           "message": response.message ?? "Data refreshed successfully"]
            )
            
        } catch {
            self.errorMessage = error.localizedDescription
            isLoading = false
            print("Network error: \(error.localizedDescription)")
            
            NotificationCenter.default.post(
                name: .refreshCompleted,
                object: nil,
                userInfo: ["status": "error",
                           "message": error.localizedDescription]
            )
        }
    }
    
    private func applyRefreshResponse(_ response: TokenModelLog) {
        guard let result = response.result else { return }
        
        if let token = response.token {
            SessionManagerClass.shared.saveToken(token)
            UserDefaults.standard.set(token, forKey: "authToken")
            AppStorageHandler.shared.authToken = token
        }
        
        if let email = result.email {
            UserDefaults.standard.set(email, forKey: "userEmail")
        }
        
        if let driverId =
            result.driverLog?.first?.driverId ??
            result.loginLogoutLog?.first?.driverId ??
            result.employeeId {
            AppStorageHandler.shared.driverId = driverId
            AppStorageHandler.shared.employeeId = driverId
        }
        
        if let empId = result.employeeId {
            
            AppStorageHandler.shared.employeeId = empId
        }
        
        if let driverName = result.driverLog?.first?.driverName {
            AppStorageHandler.shared.driverName = driverName
        } else if let firstName = result.firstName,
                  let lastName = result.lastName {
            AppStorageHandler.shared.driverName = "\(firstName) \(lastName)"
        }
        
        if let clientId = result.clientId {
            AppStorageHandler.shared.clientId = clientId
        }
        
        if let clientName = result.clientName {
            AppStorageHandler.shared.company = clientName
        }
        
        if let loginDateTime = result.loginDateTime {
            AppStorageHandler.shared.loginDateTime = loginDateTime
        }
        
        if let timeZone = result.timezone {
            AppStorageHandler.shared.timeZone = timeZone
        }
        
        if let timeZoneOffset = result.timezoneOffSet {
            AppStorageHandler.shared.timeZoneOffset = timeZoneOffset
        }
        
        if let vehicleId = result.vehicleId {
            AppStorageHandler.shared.vehicleId = vehicleId
        }
        
        if let vehicleNo = result.vehicleNo {
            AppStorageHandler.shared.vehicleNo = vehicleNo
        }
        
        if let origin = result.driverLog?.first?.origin {
            AppStorageHandler.shared.origin = origin
        }
        
        if let latitude = result.driverLog?.first?.lattitude {
            SharedInfoManager.shared.lattitude = latitude
        }
        
        if let longitude = result.driverLog?.first?.longitude {
            SharedInfoManager.shared.longitude = longitude
        }
        
        if let dutyType = result.driverLog?.first?.logType {
            AppStorageHandler.shared.logType = dutyType
        }
        
        if let cycleTime = result.rules?.first?.cycleTime {
            AppStorageHandler.shared.cycleTime = cycleTime
        }
        
        if let cycleDays = result.rules?.first?.cycleDays {
            AppStorageHandler.shared.cycleDays = cycleDays
        }
        
        if let onDutyTime = result.rules?.first?.onDutyTime {
            AppStorageHandler.shared.onDutyTime = Double(onDutyTime)
        }
        
        if let onDriveTime = result.rules?.first?.onDriveTime {
            AppStorageHandler.shared.onDriveTime = Double(onDriveTime)
        }
        
        if let onSleepTime = result.rules?.first?.onSleepTime {
            AppStorageHandler.shared.onSleepTime = Double(onSleepTime)
        }
        
        if let continueDrive = result.rules?.first?.continueDriveTime {
            AppStorageHandler.shared.continueDriveTime = Double(continueDrive)
        }
        
        if let breakTime = result.rules?.first?.breakTime {
            AppStorageHandler.shared.breakTime = breakTime
        }
        
        if let cycleRestart = result.rules?.first?.cycleRestartTime {
            AppStorageHandler.shared.cycleRestartTime = cycleRestart
        }
        
        if let warningOnDuty1 = result.rules?.first?.warningOnDutyTime1 {
            AppStorageHandler.shared.warningOnDutyTime1 = warningOnDuty1
        }
        
        if let warningOnDuty2 = result.rules?.first?.warningOnDutyTime2 {
            AppStorageHandler.shared.warningOnDutyTime2 = warningOnDuty2
        }
        
        if let warningOnDrive1 = result.rules?.first?.warningOnDriveTime1 {
            AppStorageHandler.shared.warningOnDriveTime1 = warningOnDrive1
        }
        
        if let warningOnDrive2 = result.rules?.first?.warningOnDriveTime2 {
            AppStorageHandler.shared.warningOnDriveTime2 = warningOnDrive2
        }
        
        if let warningBreak1 = result.rules?.first?.warningBreakTime1 {
            AppStorageHandler.shared.warningBreakTime1 = warningBreak1
        }
        
        if let warningBreak2 = result.rules?.first?.warningBreakTime2 {
            AppStorageHandler.shared.warningBreakTime2 = warningBreak2
        }
        
        // Feature flags
        AppStorageHandler.shared.personalUseActive = result.personalUse
        AppStorageHandler.shared.yardMovesActive = result.yardMoves
        AppStorageHandler.shared.exempt = result.exempt
        
        // Save driver logs to database
        if let logs = result.driverLog, !logs.isEmpty {
            DatabaseManager.shared.saveDriverLogsToSQLite(from: logs)
        }
    }
}

extension Notification.Name {
    static let refreshStarted = Notification.Name("refreshStarted")
    static let refreshCompleted = Notification.Name("refreshCompleted")
}
