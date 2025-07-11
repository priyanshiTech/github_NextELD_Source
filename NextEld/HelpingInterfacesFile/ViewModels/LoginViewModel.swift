//
//  LoginViewModel.swift
//  NextEld
//
//  Created by Priyanshi on 19/06/25.
//

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
              

                // Saving  Driver Username

                if let driverName = response.result?.driverLog?.first?.driverName {
                    UserDefaults.standard.set(driverName, forKey: "driverName")
                    print(" Saved full name to UserDefaults: \(driverName)")
                } else {
                    print(" Full name not found in API response.")
                }

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
}




























/*
 struct LoginRequestModel: Encodable {
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


     func login(email: String, password: String) async {
         print("🚀 Starting login...")
         isLoading = true
         errorMessage = nil

         // 1️⃣ Create request body
         let requestBody = LoginRequestModel(
             username: email,
             password: password,
             mobileDeviceId: "jay12345",
             isCoDriver: true
         )
         print("📤 Request Body: \(requestBody)")
         do {
             // 2️⃣ Call API
             let response: TokenModelLog = try await NetworkManager.shared.post(
                 .login,
                 body: requestBody
             )
             print("📬 API Response: \(response)")
             // 3️⃣ Store token if present
             if let token = response.token {
                 self.token = token
                 print("✅ Token received: \(token)")
             }
             // 4️⃣ Save driver logs to SQLite
             if let logs = response.result?.driverLog {
                 print("🧩 Driver logs received from API: \(logs.count)")
                 // ✅ Print each log before saving
                 for (index, log) in logs.enumerated() {
                     print("📄 Log \(index + 1): Status: \(log.status ?? "nil"), StartTime: \(log.dateTime ?? "nil")")
                 }
                 // ✅ Save into SQLite
                 DatabaseManager.shared.saveDriverLogsToSQLite(from: logs)
             } else {
                 print("❌ No driver logs found in API response.")
             }
         } catch {
             // 5️⃣ Handle error
             self.errorMessage = error.localizedDescription
             print("❌ Network error: \(error.localizedDescription)")
         }

         isLoading = false
         print("🔚 Login finished")
     }


     private func urlEncodedForm(from dict: [String: String]) -> Data? {
         var components = URLComponents()
         components.queryItems = dict.map { URLQueryItem(name: $0.key, value: $0.value) }
         return components.query?.data(using: .utf8)
     }
 }








*/
