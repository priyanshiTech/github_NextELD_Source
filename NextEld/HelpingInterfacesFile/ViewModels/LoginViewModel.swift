//
//  LoginViewModel.swift
//  NextEld
//
//  Created by Priyanshi on 19/06/25.
//
import SwiftUI
import Foundation

struct LoginRequestModel: Encodable , Decodable {
    let username: String
    let password: String
    let mobileDeviceId: String
    let isCoDriver: Bool
}


@MainActor
class LoginViewModel: ObservableObject {
    @Published var token: String?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    let session: SessionManager
    
    init(session: SessionManager) {
        self.session = session
    }
    
    //  NOW RETURNS Bool
    func login(email: String, password: String) async -> Bool {
        print(" Starting login...")
        isLoading = true
        errorMessage = nil
        
        let requestBody = LoginRequestModel(
            username: email,
            password: password,
            mobileDeviceId: "jay12345",
            isCoDriver: true
        )
        saveUserData(requestBody)
        print("Request Body: \(requestBody)")
        
        do {
            let response: TokenModelLog = try await NetworkManager.shared.post(
                .login,
                body: requestBody
            )
            print(" API Response: \(response)")
            
            if let token = response.token {
                self.token = token
                print(" Token received: \(token)")
                
                //Save token in Keychain / UserDefaults
                SessionManagerClass.shared.saveToken(token)
                UserDefaults.standard.set(token, forKey: "authToken")
                UserDefaults.standard.set(email, forKey: "userEmail")
                //MARK: -  Save employeeid
                if let driverId =
                    response.result?.driverLog?.first?.driverId ??
                    response.result?.loginLogoutLog?.first?.driverId ??
                    response.result?.employeeId {
                    
                    UserDefaults.standard.set(driverId, forKey: "driverId")
                    print(" Saved driverId: \(driverId)")
                } else {
                    print(" No driverId found in any field")
                }
                
                
                if let empId = response.result?.employeeId {
                    UserDefaults.standard.set(empId, forKey: "employeeId")
                }
                //MARK: - ClientId
                if let clintId = response.result?.clientId {
                    UserDefaults.standard.set(clintId, forKey: "clientId")
                }
                //MARK: -  value get from Rule module in Login Times
                
                if let cycleTime =  response.result?.rules?.first?.cycleTime{
                    UserDefaults.standard.set(cycleTime, forKey: "cycleTime")
                    print(" Saved to cycle Time: \(cycleTime)")
                }
                if let cycleDays = response.result?.rules?.first?.cycleDays{
                    UserDefaults.standard.set(cycleDays, forKey: "cycleDays")
                }
                if let cycleRestartTime = response.result?.rules?.first?.cycleDays{
                    UserDefaults.standard.set(cycleRestartTime, forKey: "cycleRestartTime")
                }
                if let onDutyTime = response.result?.rules?.first?.onDutyTime{
                    UserDefaults.standard.set(onDutyTime, forKey: "onDutyTime")
                    print(" Saved to onDutyTime: \(onDutyTime)")
                }
                if let onDriveTime = response.result?.rules?.first?.onDriveTime{
                    UserDefaults.standard.set(onDriveTime, forKey: "onDriveTime")
                    print(" Saved to conDriveTimee: \(onDriveTime)")
                }
                if let onSleepTime = response.result?.rules?.first?.onSleepTime{
                    UserDefaults.standard.set(onSleepTime, forKey: "onSleepTime")
                }
                if let continueDriveTime =  response.result?.rules?.first?.continueDriveTime{
                    UserDefaults.standard.set(continueDriveTime, forKey: "continueDriveTime")
                }
                
                
                
                
                //MARK: -
                // Save Driver Name
                if let driverName = response.result?.driverLog?.first?.driverName {
                    print(" API Returned driverName: \(driverName)")
                    UserDefaults.standard.set(driverName, forKey: "driverName")
                    UserDefaults.standard.synchronize()
                    print(" Saved to UserDefaults: \(driverName)")
                }
                else if let firstName = response.result?.firstName,
                        let lastName = response.result?.lastName {
                    let fullName = "\(firstName) \(lastName)"
                    UserDefaults.standard.set(fullName, forKey: "driverName")
                    print(" Saved from TokenResult: \(fullName)")
                } else {
                    print("No driverName found anywhere, not saving")
                }
                
                if let loginDateTime = response.result?.loginDateTime {
                    UserDefaults.standard.set(loginDateTime, forKey: "LoginDateTime")
                }
                
                
                // Save Timezone
                if let timeZone = response.result?.timezone {
                    UserDefaults.standard.set(timeZone, forKey: "timezone")
                }
                if let timeZoneOffSet = response.result?.timezoneOffSet {
                    UserDefaults.standard.set(timeZoneOffSet, forKey: "timezoneOffSet")
                }
                //Save Timers
                if let onDutyTime = response.result?.rules?.first?.onDutyTime {
                    UserDefaults.standard.set(onDutyTime, forKey: "onDutyTime")
                }
                
                if let onDriveTime = response.result?.rules?.first?.onDriveTime {
                    UserDefaults.standard.set(onDriveTime, forKey: "onDriveTime")
                }

                if let onSleepTime = response.result?.rules?.first?.onSleepTime{
                    DriverInfo.setonSleepTime(Double(onSleepTime))
                }
                
                //Save Shift
                if let shiftValue = response.result?.driverLog?.first?.shift {
                    UserDefaults.standard.set(shiftValue, forKey: "shift")
                    print(" Saved shift: \(shiftValue)")
                }
                
                if let dateIs =  response.result?.driverLog?.first?.days{
                    UserDefaults.standard.set(dateIs, forKey: "days")
                    print(" Saved current day: \(dateIs)")
                }
                
                if let firstLog = response.result?.driverCertifiedLog.first {
                    let coDriverId = firstLog.coDriverId
                    UserDefaults.standard.set(coDriverId, forKey: "coDriverId")
                    print("Saved coDriverId:", coDriverId)
                }
                
                //Save Location (if available)
                if let location = response.result?.driverLog?.first?.customLocation {
                    UserDefaults.standard.set(location, forKey: "customLocation")
                    print(" Saved location: \(location)")
                }
                
                //Save Latitude
                if let latitude = response.result?.driverLog?.first?.lattitude {
                    UserDefaults.standard.set(latitude, forKey: "lattitude")
                    print(" Saved latitude: \(latitude)")
                }
                
                //Save Longitude
                if let longitude = response.result?.driverLog?.first?.longitude {
                    UserDefaults.standard.set(longitude, forKey: "longitude")
                    print(" Saved longitude: \(longitude)")
                }
                
        
                
                if let DutyType =  response.result?.driverLog?.first?.logType{
                    UserDefaults.standard.set(DutyType , forKey: "logType")
                    print(" Saved Logtype: \(DutyType)")
                }
                
                if let VechicleID = response.result?.driverLog?.first?.vehicleId{
                    let vehicleId = UserDefaults.standard.integer(forKey: "vehicleId") // works for Int
                    print(" Saved VechicleID: \(VechicleID)")
                }
                
                if let originAddres = response.result?.driverLog?.first?.origin{
                    UserDefaults.standard.set(originAddres, forKey: "origin")
                    print(" Saved Origin: \(originAddres)")
                }
                
                if let vechicle =  response.result?.driverLog?.first?.truckNo{
                    UserDefaults.standard.set(vechicle, forKey: "truckNo")
                    print(" Saved vechicle: \(vechicle)")
                }
                
                if let voilation = response.result?.driverLog?.first?.isVoilation{
                    UserDefaults.standard.set(voilation , forKey: "isVoilation")
                    print(" Saved voilation: \(voilation)")
                }
                
                if let  trailer  =  response.result?.driverLog?.first?.trailers{
                    UserDefaults.standard.set(trailer, forKey: "trailer")
                }
                
                
                if let breakTime =  response.result?.rules?.first?.breakTime{
                    UserDefaults.standard.set(breakTime, forKey: "breakTime")
                }
                if let cycleRestartTime =  response.result?.rules?.first?.cycleRestartTime{
                    UserDefaults.standard.set(cycleRestartTime, forKey: "cycleRestartTime")
                }
                    if let warningOnDutyTime1 =  response.result?.rules?.first?.warningOnDutyTime1{
                        UserDefaults.standard.set(warningOnDutyTime1, forKey: "warningOnDutyTime1")
                    }
                    if let warningOnDutyTime2 =  response.result?.rules?.first?.warningOnDutyTime2{
                        UserDefaults.standard.set(warningOnDutyTime2, forKey: "warningOnDutyTime2")
                    }
                    if let warningOnDriveTime1 =  response.result?.rules?.first?.warningOnDriveTime1{
                        UserDefaults.standard.set(warningOnDriveTime1, forKey: "warningOnDriveTime1")
                    }
                    if let warningOnDriveTime2 =  response.result?.rules?.first?.warningOnDriveTime2{
                        UserDefaults.standard.set(warningOnDriveTime2, forKey: "warningOnDriveTime2")
                    }
                    if let warningBreakTime1 =  response.result?.rules?.first?.warningBreakTime1{
                        UserDefaults.standard.set(warningBreakTime1, forKey: "warningBreakTime1")
                    }
                    if let warningBreakTime2 =  response.result?.rules?.first?.warningBreakTime2{
                        UserDefaults.standard.set(warningBreakTime2, forKey: "warningBreakTime2")
                    }
                    
                    session.logIn(token: token)
                }
                
                // Save logs to DB
                if let logs = response.result?.driverLog {
                    DatabaseManager.shared.saveDriverLogsToSQLite(from: logs)
                }
                
                isLoading = false
                
                print(" Login finished successfully")
                return true
                
            } catch {
                self.errorMessage = error.localizedDescription
                print(" Network error: \(error.localizedDescription)")
                isLoading = false
                return false
            }
        }
        
        func saveUserData(_ user: LoginRequestModel) {
            if let encoded = try? JSONEncoder().encode(user) {
                UserDefaults.standard.set(encoded, forKey: "userData")
                print(" User data saved in UserDefaults: \(user)")
            }
        }
        func loadUserData() -> LoginRequestModel? {
            if let data = UserDefaults.standard.data(forKey: "userData"),
               let decoded = try? JSONDecoder().decode(LoginRequestModel.self, from: data) {
                print(" Loaded user data from UserDefaults: \(decoded)")
                return decoded
            }
            print(" No saved user data found in UserDefaults")
            return nil
        }
        
        func autoLoginIfPossible() async {
            guard let savedUser = loadUserData() else {
                print("No saved user data found.")
                return
            }
            
            print(" Auto-login with saved data: \(savedUser.username)")
            await login(email: savedUser.username, password: savedUser.password)
        }
        
        
        private func urlEncodedForm(from dict: [String: String]) -> Data? {
            var components = URLComponents()
            components.queryItems = dict.map { URLQueryItem(name: $0.key, value: $0.value) }
            return components.query?.data(using: .utf8)
        }
    }
    













































