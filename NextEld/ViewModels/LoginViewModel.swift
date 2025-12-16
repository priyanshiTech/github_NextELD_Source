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
    
    
    //  NOW RETURNS Bool
    func login(email: String, password: String) async -> Bool {
        // print(" Starting login...")
        isLoading = true
        errorMessage = nil
        
        let requestBody = LoginRequestModel(
            username: email,
            password: password,
            mobileDeviceId: "",
            isCoDriver: true
        )
        saveUserData(requestBody)
         print("Request Body: \(requestBody)")
        
        do {
            // Get raw JSON response first to extract driverDvirLog
            var request = URLRequest(url: API.Endpoint.login.url)
            request.httpMethod = API.Endpoint.login.method
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let encodedBody = try JSONEncoder().encode(requestBody)
            request.httpBody = encodedBody
            
            let (data, responseData) = try await URLSession.shared.data(for: request)
            
            // Print raw response for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📄 Raw Response JSON: \(jsonString.prefix(1000))...") // Print first 1000 chars
            }
            
            // Parse raw JSON to get driverDvirLog and driverCertifiedLog before decoding
            var driverDvirLogArray: [[String: Any]]? = nil
            var driverCertifiedLogArray: [[String: Any]]? = nil
            if let jsonDict = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let resultDict = jsonDict["result"] as? [String: Any] {
                // Extract DVIR logs
                if let driverDvirLog = resultDict["driverDvirLog"] as? [[String: Any]] {
                    driverDvirLogArray = driverDvirLog
                    print("Found \(driverDvirLog.count) server DVIR records in login response")
                }
                // Extract Certify logs
                if let driverCertifiedLog = resultDict["driverCertifiedLog"] as? [[String: Any]] {
                    driverCertifiedLogArray = driverCertifiedLog
                    print(" Found \(driverCertifiedLog.count) server Certify records in login response")
                }
            }
            
            // Decode response to TokenModelLog
            let response: TokenModelLog = try JSONDecoder().decode(TokenModelLog.self, from: data)
            // print(" API Response: \(response)")
            if response.status == "FAIL" || response.token == nil {
                // Login failed - set error message and return false
                self.errorMessage = response.message ?? "Login failed: Invalid credentials"
                // print("  Login failed: \(self.errorMessage ?? "Unknown error")")
                // print(" Response status: \(response.status ?? "No status")")
                isLoading = false
                return false
            }
            
            //  Only proceed if we have a valid token
            if let token = response.token {
                self.token = token
                // print(" Token received: \(token)")
                
                //Save token in Keychain / UserDefaults
                SessionManagerClass.shared.saveToken(token)
                UserDefaults.standard.set(token, forKey: "authToken")
                UserDefaults.standard.set(email, forKey: "userEmail")
                //MARK: -  Save employeeid
                
                if let driverId =
                    response.result?.driverLog?.first?.driverId ??
                    response.result?.loginLogoutLog?.first?.driverId ??
                    response.result?.employeeId {
                    AppStorageHandler.shared.driverId = driverId
                    //UserDefaults.standard.set(driverId, forKey: "driverId")
                    // print(" Saved driverId: \(driverId)")
                } else {
                    // print(" No driverId found in any field")
                }
                
                if let empId = response.result?.employeeId {
                    //UserDefaults.standard.set(empId, forKey: "employeeId")
                    AppStorageHandler.shared.employeeId = empId
                    
                    
                }
                
                if let disclaimer = response.result?.disclaimerRead {
                    AppStorageHandler.shared.disclaimerRead = disclaimer
                    //UserDefaults.standard.set(clintId, forKey: "clientId")
                }
                
                //MARK: - ClientId
                if let clintId = response.result?.clientId {
                    AppStorageHandler.shared.clientId = clintId
                    //UserDefaults.standard.set(clintId, forKey: "clientId")
                }
                
                if let clientName = response.result?.clientName {
                    AppStorageHandler.shared.company = clientName
                    // print("company Name  : \(clientName)")
                }
                
                //MARK: -  value get from Rule module in Login Times
                
                if let cycleTime =  response.result?.rules?.first?.cycleTime{
                   // UserDefaults.standard.set(cycleTime, forKey: "cycleTime")
                    AppStorageHandler.shared.cycleTime = cycleTime
                    // print(" Saved to cycle Time: \(cycleTime)")
                }
                
                if let cycleDays = response.result?.rules?.first?.cycleDays{
                   // UserDefaults.standard.set(cycleDays, forKey: "cycleDays")
                    AppStorageHandler.shared.cycleDays = cycleDays
                }
                
                if let cycleRestartTime = response.result?.rules?.first?.cycleDays{
                    //UserDefaults.standard.set(cycleRestartTime, forKey: "cycleRestartTime")
                    AppStorageHandler.shared.cycleRestartTime = cycleRestartTime }
                
                if let onDutyTime = response.result?.rules?.first?.onDutyTime{
                      
                    AppStorageHandler.shared.onDutyTime = Double(onDutyTime)
                   // UserDefaults.standard.set(onDutyTime, forKey: "onDutyTime")
                    // print(" Saved to onDutyTime: \(onDutyTime)")
                }
                
                if let onDriveTime = response.result?.rules?.first?.onDriveTime{
                    //UserDefaults.standard.set(onDriveTime, forKey: "onDriveTime")
                    AppStorageHandler.shared.onDriveTime = Double(onDriveTime)
                    // print(" Saved to conDriveTimee: \(onDriveTime)")
                }
                
                if let onSleepTime = response.result?.rules?.first?.onSleepTime{
                    AppStorageHandler.shared.onSleepTime = Double(onSleepTime)
                    //UserDefaults.standard.set(onSleepTime, forKey: "onSleepTime")
                }
                
                if let continueDriveTime =  response.result?.rules?.first?.continueDriveTime{
                    //UserDefaults.standard.set(continueDriveTime, forKey: "continueDriveTime")
                    AppStorageHandler.shared.continueDriveTime = Double(continueDriveTime)
                }
                
                
                //MARK: -
                // Save Driver Name
                if let driverName = response.result?.driverLog?.first?.driverName {
                 //UserDefaults.standard.set(driverName, forKey: "driverName")
                    AppStorageHandler.shared.driverName = driverName
                   // UserDefaults.standard.synchronize()
                    // print(" Saved to UserDefaults: \(driverName)")
                }
                
                else if let firstName = response.result?.firstName,
                        let lastName = response.result?.lastName {
                    AppStorageHandler.shared.driverName  = "\(firstName) \(lastName)"
                   // UserDefaults.standard.set(fullName, forKey: "driverName")
                   
                } else {
                    // print("No driverName found anywhere, not saving")
                }
                
                if let loginDateTime = response.result?.loginDateTime {
                    AppStorageHandler.shared.loginDateTime = loginDateTime
                }
                
                // Save Timezone
                if let timeZone = response.result?.timezone {
                    AppStorageHandler.shared.timeZone = timeZone
                }
                
                if let timeZoneOffSet = response.result?.timezoneOffSet {
                    AppStorageHandler.shared.timeZoneOffset = timeZoneOffSet
                }

                
                //Save Shift
                if let shiftValue = response.result?.driverLog?.first?.shift {
                    AppStorageHandler.shared.shift = shiftValue
                    // print(" Saved shift: \(shiftValue)")
                }
                
                if let dateIs =  response.result?.driverLog?.first?.days{
                    AppStorageHandler.shared.days = dateIs
                    // print(" Saved current day: \(dateIs)")
                }
                
                if let firstLog = response.result?.driverCertifiedLog?.first,
                   let coDriverId = firstLog.coDriverId {
                    AppStorageHandler.shared.coDriverId = coDriverId
                }
                
                //Save Location (if available)
//                    if let location = response.result?.driverLog?.first?.customLocation {
//                        SharedInfoManager.shared.customLocation = location
//                    // print(" Saved location: \(location)")
//                    }
                
                //Save Latitude
                    if let latitude = response.result?.driverLog?.first?.lattitude {
                    //UserDefaults.standard.set(latitude, forKey: "lattitude")
                        SharedInfoManager.shared.lattitude = latitude
                    // print(" Saved latitude: \(latitude)")
                    }
                
                //Save Longitude
                    if let longitude = response.result?.driverLog?.first?.longitude {
                   // UserDefaults.standard.set(longitude, forKey: "longitude")
                        SharedInfoManager.shared.longitude = longitude
                    // print(" Saved longitude: \(longitude)")
                    }
                
                    if let DutyType =  response.result?.driverLog?.first?.logType{
                    //UserDefaults.standard.set(DutyType , forKey: "logType")
                        AppStorageHandler.shared.logType = DutyType
                
                    // print(" Saved Logtype: \(DutyType)")
                    }
                
                   if let VechicleID = response.result?.vehicleId{
                    //UserDefaults.standard.set(VechicleID , forKey: "vehicleId")// works for Int
                       AppStorageHandler.shared.vehicleId = VechicleID
                    // print(" Saved VechicleID: \(VechicleID)")
                    }
                
                    if let originAddres = response.result?.driverLog?.first?.origin{
                  //  UserDefaults.standard.set(originAddres, forKey: "origin")
                        AppStorageHandler.shared.origin = originAddres
                    // print(" Saved Origin: \(originAddres)")
                    }
                
                    if let vechicle =  response.result?.driverLog?.first?.truckNo{
                  //  UserDefaults.standard.set(vechicle, forKey: "truckNo")
                        AppStorageHandler.shared.vehicleNo = vechicle
                     // print(" Saved vechicle: \(vechicle)")
                    }
                
                    if let vechicleNo =  response.result?.vehicleNo{
                     //UserDefaults.standard.set(vechicleNo, forKey: "vehicleNo")
                        AppStorageHandler.shared.vehicleNo = vechicleNo
                     // print(" Saved vechicle: \(vechicleNo)")
                    }
                
                    if let voilation = response.result?.driverLog?.first?.isVoilation{
                   UserDefaults.standard.set(voilation , forKey: "isVoilation")
                    // print(" Saved voilation: \(voilation)")
                    }
                
                    if let  trailer  =  response.result?.driverLog?.first?.trailers{
                    UserDefaults.standard.set(trailer, forKey: "trailer")
                    }

                    if let breakTime =  response.result?.rules?.first?.breakTime{
                     //UserDefaults.standard.set(breakTime, forKey: "breakTime")
                        AppStorageHandler.shared.breakTime = breakTime
                    }
                
                   if let cycleRestartTime =  response.result?.rules?.first?.cycleRestartTime{
                    // UserDefaults.standard.set(cycleRestartTime, forKey: "cycleRestartTime")
                       AppStorageHandler.shared.cycleRestartTime = cycleRestartTime
                    }
                    if let warningOnDutyTime1 =  response.result?.rules?.first?.warningOnDutyTime1{
                       // UserDefaults.standard.set(warningOnDutyTime1, forKey: "warningOnDutyTime1")
                        AppStorageHandler.shared.warningOnDutyTime1 = warningOnDutyTime1
                    }
                
                    if let warningOnDutyTime2 =  response.result?.rules?.first?.warningOnDutyTime2{
                       // UserDefaults.standard.set(warningOnDutyTime2, forKey: "warningOnDutyTime2")
                        AppStorageHandler.shared.warningOnDutyTime2 = warningOnDutyTime2
                    }
                    if let warningOnDriveTime1 =  response.result?.rules?.first?.warningOnDriveTime1{
                       // UserDefaults.standard.set(warningOnDriveTime1, forKey: "warningOnDriveTime1")
                        AppStorageHandler.shared.warningOnDriveTime1 = warningOnDriveTime1
                    }
                    if let warningOnDriveTime2 =  response.result?.rules?.first?.warningOnDriveTime2{
                        //UserDefaults.standard.set(warningOnDriveTime2, forKey: "warningOnDriveTime2")
                        AppStorageHandler.shared.warningOnDriveTime2 = warningOnDriveTime2
                    }
                    if let warningBreakTime1 =  response.result?.rules?.first?.warningBreakTime1{
                       // UserDefaults.standard.set(warningBreakTime1, forKey: "warningBreakTime1")
                        AppStorageHandler.shared.warningBreakTime1 = warningBreakTime1
                    }
                if let warningBreakTime2 =  response.result?.rules?.first?.warningBreakTime2{
                       // UserDefaults.standard.set(warningBreakTime2, forKey: "warningBreakTime2")
                        AppStorageHandler.shared.warningBreakTime2 = warningBreakTime2
                    }
                
                // MARK: - Personal Use / Yard Move / Exempt flags
                if let personalUseFlag = response.result?.personalUse {
                    AppStorageHandler.shared.personalUseActive = personalUseFlag
                    // print(" Personal Use Flag: \(personalUseFlag)")
                }
                
                if let yardMoveFlag = response.result?.yardMoves {
                    AppStorageHandler.shared.yardMovesActive = yardMoveFlag
                    // print(" Yard Move Flag: \(yardMoveFlag)")
                }
                
                if let exemptFlag = response.result?.exempt {
                    AppStorageHandler.shared.exempt = exemptFlag
                    // print(" Exempt Flag: \(exemptFlag)")
                }
                   // session.logIn(token: token)
                }
            
            //MARK: - Logout /Login data saved
                let loginLogoutLog = response.result?.loginLogoutLog ?? []
                let logs = response.result?.driverLog ?? []
                // Save logs to DB
                if !logs.isEmpty {
                    DatabaseManager.shared.saveDriverLogsToSQLite(from: logs)
                }
                
                // MARK: - Save Login/Logout Logs to Database
                if let loginLogoutLogs = response.result?.loginLogoutLog, !loginLogoutLogs.isEmpty {
                    DatabaseManager.shared.saveLoginLogoutLogsToSQLite(from: loginLogoutLogs)
                    //print("Saved \(loginLogoutLogs.count) login/logout logs to database")
                }
                
                // MARK: - Save Server DVIR Records from Login Response
                if let driverDvirLog = driverDvirLogArray, !driverDvirLog.isEmpty {
                    DvirDatabaseManager.shared.saveServerDvirRecords(from: driverDvirLog)
                    let savedRecords = DvirDatabaseManager.shared.fetchAllRecords()
                    // print(" Total records in database after save: \(savedRecords.count)")
                                                   // Post notification to refresh EmailDvir list
                //    NotificationCenter.default.post(name: NSNotification.Name("DVIRRecordUpdated"), object: nil)
                    // print(" Posted DVIRRecordUpdated notification")
               
                } else {
                     print("  No driverDvirLog found in login response or array is empty")
                }
                
                // MARK: - Save Server Certify Records from Login Response (same pattern as DVIR)
                if let driverCertifiedLog = driverCertifiedLogArray, !driverCertifiedLog.isEmpty {
                    CertifyDatabaseManager.shared.saveServerCertifyRecords(from: driverCertifiedLog)
                    // print(" Saved \(driverCertifiedLog.count) certify records from login API to database")
                } else {
                     print("  No driverCertifiedLog found in login response or array is empty")
                }
            
                isLoading = false
                // print(" Login finished successfully")
                return true
                
            } catch {
                // Better error handling for decoding errors
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .keyNotFound(let key, let context):
                        self.errorMessage = "Missing field: \(key.stringValue). \(context.debugDescription)"
                        print("Decoding Error - Missing key: \(key.stringValue)")
                        print("   Context: \(context.debugDescription)")
                    case .typeMismatch(let type, let context):
                        self.errorMessage = "Type mismatch for \(type). \(context.debugDescription)"
                        print(" Decoding Error - Type mismatch: \(type)")
                        print("   Context: \(context.debugDescription)")
                    case .valueNotFound(let type, let context):
                        self.errorMessage = "Value not found for \(type). \(context.debugDescription)"
                        print(" Decoding Error - Value not found: \(type)")
                        print("   Context: \(context.debugDescription)")
                    case .dataCorrupted(let context):
                        self.errorMessage = "Data corrupted: \(context.debugDescription)"
                        print(" Decoding Error - Data corrupted")
                        print("   Context: \(context.debugDescription)")
                    @unknown default:
                        self.errorMessage = "Decoding error: \(error.localizedDescription)"
                        print(" Decoding Error - Unknown: \(error.localizedDescription)")
                    }
                } else {
                    self.errorMessage = error.localizedDescription
                    print(" Network/Other Error: \(error.localizedDescription)")
                }
                
                isLoading = false
                return false
            }
        }
        
        func saveUserData(_ user: LoginRequestModel) {
            if let encoded = try? JSONEncoder().encode(user) {
                UserDefaults.standard.set(encoded, forKey: "userData")
                // print(" User data saved in UserDefaults: \(user)")
            }
        }
        func loadUserData() -> LoginRequestModel? {
            if let data = UserDefaults.standard.data(forKey: "userData"),
               let decoded = try? JSONDecoder().decode(LoginRequestModel.self, from: data) {
                // print(" Loaded user data from UserDefaults: \(decoded)")
                return decoded
            }
            // print(" No saved user data found in UserDefaults")
            return nil
        }
        
        func autoLoginIfPossible() async {
            guard let savedUser = loadUserData() else {
                // print("No saved user data found.")
                return
            }
            
            // print(" Auto-login with saved data: \(savedUser.username)")
            await login(email: savedUser.username, password: savedUser.password)
        }
        
        
        private func urlEncodedForm(from dict: [String: String]) -> Data? {
            var components = URLComponents()
            components.queryItems = dict.map { URLQueryItem(name: $0.key, value: $0.value) }
            return components.query?.data(using: .utf8)
        }
    
        
    }
    













































