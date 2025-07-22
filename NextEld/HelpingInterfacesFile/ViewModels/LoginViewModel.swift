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

                //Save Driver Name
                if let driverName = response.result?.driverLog?.first?.driverName {
                    UserDefaults.standard.set(driverName, forKey: "driverName")
                    print(" Saved full name to UserDefaults: \(driverName)")
                }
                // Save Driver Name
                if let driverName = response.result?.driverLog?.first?.driverName {
                    print(" API Returned driverName: \(driverName)")
                    UserDefaults.standard.set(driverName, forKey: "driverName")
                    UserDefaults.standard.synchronize()
                    print(" Saved to UserDefaults: \(driverName)")
                } else if let firstName = response.result?.firstName,
                          let lastName = response.result?.lastName {
                    let fullName = "\(firstName) \(lastName)"
                    UserDefaults.standard.set(fullName, forKey: "driverName")
                    print(" Saved from TokenResult: \(fullName)")
                } else {
                    print("❌ No driverName found anywhere, not saving")
                }

                // Save Timezone
                if let timeZone = response.result?.timezone {
                    UserDefaults.standard.set(timeZone, forKey: "timezone")
                } else if let timeZoneOffSet = response.result?.timezoneOffSet {
                    UserDefaults.standard.set(timeZoneOffSet, forKey: "timezoneOffSet")
                }

                //Save Timers
                if let onDutyTime = response.result?.onDutyTime {
                    UserDefaults.standard.set(onDutyTime, forKey: "onDutyTime")
                }
                if let onDriveTime = response.result?.onDriveTime {
                    UserDefaults.standard.set(onDriveTime, forKey: "onDriveTime")
                }
                if let onSleepTime = response.result?.onSleepTime {
                    UserDefaults.standard.set(onSleepTime, forKey: "onSleepTime")
                }
                if let driverId = response.result?.driverLog?.first?.driverId {
                    UserDefaults.standard.set(driverId, forKey: "userId")
                    print(" Saved userId to UserDefaults: \(driverId)")
                } else {
                    print(" No driverId found in API response, defaulting to 0")
                }

                //Save Shift
                if let shiftValue = response.result?.driverLog?.first?.shift {
                    UserDefaults.standard.set(shiftValue, forKey: "shift")
                    print(" Saved shift: \(shiftValue)")
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
                
                if let dateIs =  response.result?.driverLog?.first?.days{
                    UserDefaults.standard.set(dateIs, forKey: "day")
                    print(" Saved current day: \(dateIs)")
                }
                if let DutyType =  response.result?.driverLog?.first?.logType{
                    UserDefaults.standard.set(DutyType , forKey: "logType")
                    print(" Saved Logtype: \(DutyType)")
                }
                if let VechicleID = response.result?.driverLog?.first?.vehicleId{
                    UserDefaults.standard.set(VechicleID, forKey: "vehicleId")
                    print(" Saved VechicleID: \(VechicleID)")
                }
                if let originAddres = response.result?.driverLog?.first?.origin{
                    UserDefaults.standard.set(originAddres, forKey: "origin")
                    print(" Saved Origin: \(originAddres)")
                }
                
                if let vechicle =  response.result?.driverLog?.first?.truckNo{
                    UserDefaults.standard.set(vechicle, forKey: "truckNo")
                    print(" Saved Origin: \(vechicle)")
                }
                if let voilation = response.result?.driverLog?.first?.isVoilation{
                    UserDefaults.standard.set(voilation , forKey: "isVoilation")
                    print(" Saved Origin: \(voilation)")
                }
                if let  trailer  =  response.result?.driverLog?.first?.trailers{
                    UserDefaults.standard.set(trailer, forKey: "trailer ")
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










































/*
import Foundation
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

    func login(email: String, password: String) async {
        print(" Starting login...")
        isLoading = true
        errorMessage = nil

        //  Create request body
        let requestBody = LoginRequestModel(
            username: email,
            password: password,
            mobileDeviceId: "jay12345",
            isCoDriver: true
        )
        saveUserData(requestBody)
        print("Request Body: \(requestBody)")
        do {
            //MARK: -   Call API
            let response: TokenModelLog = try await NetworkManager.shared.post(
                .login,
                body: requestBody
            )
            print(" API Response: \(response)")
            //MARK: -   Store token if present
//            if let token = response.token {
//                self.token = token
//                print(" Token received: \(token)")
//                session.logIn(token: token)
//            }
            if let token = response.token {
                self.token = token
                print(" Token received: \(token)")
                
                 // Save token in Keychain
                SessionManagerClass.shared.saveToken(token)
                
                // Save login session
                UserDefaults.standard.set(token, forKey: "authToken")
                UserDefaults.standard.set(email, forKey: "userEmail")
              

                //Saving  Driver Username

                if let driverName = response.result?.driverLog?.first?.driverName {
                    UserDefaults.standard.set(driverName, forKey: "driverName")
                    print(" Saved full name to UserDefaults: \(driverName)")
                } else {
                    print(" Full name not found in API response.")
                }
                //MARK: -  SAVE Timer ZONE / OFFSET IN API
                if let timeZone = response.result?.timezone{
                    UserDefaults.standard.set(timeZone, forKey: "timezone")
                    print(" Saved Timezone in UD: \(timeZone)")
                    
                    
                } else if let timeZoneOffSet  =  response.result?.timezoneOffSet{
                    UserDefaults.standard.set(timeZoneOffSet, forKey: "timezoneOffSet")
                    print(" Saved TimezoneOffset in UD: \(timeZoneOffSet)")

                    
                }else {
                    print(" Full name not found in API response.")
                }
                // Optional I  Print current values from UserDefaults to confirm
                let tz = UserDefaults.standard.string(forKey: "timezone") ?? "nil"
                let tzOffset = UserDefaults.standard.string(forKey: "timezoneOffSet") ?? "nil"
                print(" Current UD Values → timezone: \(tz), timezoneOffSet: \(tzOffset)")
                //MARK: -  Saving data into Static for Timers
                
                if let OndutyTIme =  response.result?.onDutyTime {
                    UserDefaults.standard.set(OndutyTIme, forKey: "OndutyTIme")
                }
                if let OndriveTime =  response.result?.onDriveTime {
                    UserDefaults.standard.set(OndriveTime, forKey: "onDriveTime")
                }
                if let OnsleepTime =  response.result?.onSleepTime {
                    UserDefaults.standard.set(OnsleepTime, forKey: "onSleepTime")
                }else  {
                    print(" Full name not found in API response.")
                }

                session.logIn(token: token)
            }

            
            //  Save driver logs to SQLite
            if let logs = response.result?.driverLog {
                print("________ Driver logs received from API: \(logs.count)")
                //  Print each log before saving
                for (index, log) in logs.enumerated() {
                    print(" Log \(index + 1): Status: \(log.status ?? "nil"), StartTime: \(log.dateTime ?? "nil")")
                }
                //  Save into SQLite
                DatabaseManager.shared.saveDriverLogsToSQLite(from: logs)
            } else {
                print(" No driver logs found in API response.")
            }
        } catch {
            //  Handle error
            self.errorMessage = error.localizedDescription
            print(" Network error: \(error.localizedDescription)")
        }

        isLoading = false
        print(" Login finished")
    }
 //MARK: -  Save Data
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
}*/











