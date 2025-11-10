//
//  NewDriverLogin.swift
//  NextEld
//
//  Created by Priyanshi  on 27/05/25.
//
import SwiftUI

struct NewDriverLogin: View {
    @EnvironmentObject var navManager: NavigationManager
    @EnvironmentObject var appRootManager: AppRootManager
    @EnvironmentObject var session: SessionManager
    @StateObject var loginVM = LoginViewModel()
    @StateObject private var viewModel = APILoginLogViewModel()
    @StateObject private var logoutVM = APILogoutViewModel()
    @Binding var isLoggedIn: Bool
    
    @State private var UserText: String = ""   // start empty, sync later

    @State private var password = ""
    @State private var isPasswordShowing = false
    @State private var alertVisible = false
    @State private var txtFieldHeight: CGFloat = 56
    @State private var txtFieldWidth: CGFloat = 320
    
    var tittle: String
  //  var email: String   // coming from CoDriverLogin
    var UserName: String
    var body: some View {
        VStack(spacing: 30) {
            //  Header
            HStack {
                Button(action: { navManager.goBack() }) {
                    Image(systemName: "arrow.left")
                        .bold()
                        .foregroundColor(.white)
                        .imageScale(.large)
                }
                Text(tittle)
                    .font(.headline)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding()
            .background(Color(uiColor: .wine).shadow(radius: 1))
            
            Text("Next ELD")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 80)
            
            //  Username TextField with validation
            HStack {
                Image(systemName: "envelope.fill")
                    .foregroundColor(Color(uiColor: .wine))
                TextField("UserName", text: $UserText)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
            }
            .inputBoxStyle(width: txtFieldWidth, height: txtFieldHeight, isValid: UserText.isEmpty || isValidUsername(UserText))
            
            // Inline validation message for username
            if !UserText.isEmpty && !isValidUsername(UserText) {
                Text("Enter a UserName")
                    .foregroundColor(.red)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 5)
            }
            
            //  Password TextField with validation
            HStack {
                Image(systemName: "lock")
                    .foregroundColor(Color(uiColor: .wine))
                if isPasswordShowing {
                    TextField("Password", text: $password)
                        .autocapitalization(.none)
                } else {
                    SecureField("Password", text: $password)
                        .autocapitalization(.none)
                }
                Button(action: { isPasswordShowing.toggle() }) {
                    Image(systemName: isPasswordShowing ? "eye.fill" : "eye.slash.fill")
                        .foregroundColor(Color(uiColor: .wine))
                }
            }
            .inputBoxStyle(width: txtFieldWidth, height: txtFieldHeight, isValid: password.isEmpty || isValidPassword(password))
            
            // Inline validation message for password
            if !password.isEmpty && !isValidPassword(password) {
                Text("Password must be numeric (min 4 digits)")
                    .foregroundColor(.red)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 5)
            }
            // Info
            HStack {
                Text("The Current driver will be signed out and you will become Driver. Notice as per requirements from FMCSA and CCMTA")
                    .font(.callout)
                    .bold()
                    .foregroundColor(.white)
                    .frame(width: txtFieldWidth, alignment: .leading)
            }
            
            //  Login button
            Button(action: {
                // Validate before attempting login
                if !isValidUsername(UserText) || !isValidPassword(password) {
                    alertVisible = true
                    return
                }
                
                Task {
                    // Step 1: First check if someone is logged in - Logout old user with all data
                    if SessionManagerClass.shared.isLoggedIn() {
                        print(" Old user logged in, calling logout API...")
                        // Logout current user before logging in new one
                        await logoutVM.callLogoutAPI()
                        
                        // Check if logout was successful
                        if logoutVM.status != "SUCCESS" {
                            print(" Logout failed: \(logoutVM.apiMessage)")
                            DispatchQueue.main.async {
                                alertVisible = true
                            }
                            return
                        }
                        print(" Old user logged out successfully with all data")
                    }
                    
                    // Step 2: Now run login API for new codriver
                    print(" Starting login for new codriver: \(UserText)")
                    let success = await loginVM.login(email: UserText, password: password)
                    
                    // Step 3: Check if login was successful
                    if success && SessionManagerClass.shared.isLoggedIn() {
                        print(" Login successful! Calling loginLogUpdate API...")
                        
                        // Step 4: Call loginLogUpdate API
                        await viewModel.callLoginLogUpdateAPI()
                        print(" LoginLogUpdate API called successfully")
                        
                        isLoggedIn = true
                        
                        // Step 5: Navigate to Home screen - new user and their data will show
                        DispatchQueue.main.async {
                            navManager.reset()
                            appRootManager.currentRoot = .scanner(moveToHome: false)
                        }
                        print(" Navigation completed - New user data will be displayed")
                    } else {
                        // Login failed - show error message
                        print(" Login failed. Success: \(success), IsLoggedIn: \(SessionManagerClass.shared.isLoggedIn())")
                        print(" Error message: \(loginVM.errorMessage ?? "No error message")")
                        DispatchQueue.main.async {
                            alertVisible = true
                        }
                    }
                }
            }) {
                Text("Log - In")
                    .font(.callout)
                    .foregroundColor(Color(uiColor: .wine))
                    .frame(width: txtFieldWidth, height: txtFieldHeight)
                    .background((isValidUsername(UserText) && isValidPassword(password)) ? Color.white : Color.gray.opacity(0.3))
                    .cornerRadius(10)
            }
            .disabled(!isValidUsername(UserText) || !isValidPassword(password))
            
            // Loading indicator
            if loginVM.isLoading {
                ProgressView("Logging in...")
                    .padding()
            }
            
            // Error message from API
            if let error = loginVM.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .wine))
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $alertVisible) {
            Alert(
                title: Text(loginVM.errorMessage != nil ? "Login Failed" : (logoutVM.status != "SUCCESS" && !logoutVM.apiMessage.isEmpty ? "Logout Failed" : "Validation Error")),
                message: Text(loginVM.errorMessage ?? (logoutVM.apiMessage.isEmpty ? "Please enter a valid Username and password." : logoutVM.apiMessage)),
                dismissButton: .default(Text("OK"))
            )
        }
        //  Auto-fill email whenever screen appears
        .onAppear {
            if !UserName.isEmpty {
                self.UserText = UserName
                print(" Auto-filled email from co-driver: \(UserName)")
            }
        }
    }
}

// MARK: - Username Validation
//func isValidUsername(_ username: String) -> Bool {
//    //  letters, numbers, underscore and spaces allowed, length 3-50 (for names like "SARTAJ GILL")
//    let usernameRegex = "^[A-Za-z0-9_ ]{3,50}$"
//    return NSPredicate(format: "SELF MATCHES %@", usernameRegex).evaluate(with: username)
//}
//
//// MARK: - Password Validation (Only Numbers, min 4 digits)
//func isValidPassword(_ password: String) -> Bool {
//    let passwordRegex = "^[0-9]{4,}$"
//    return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
//}

//#Preview {
//    NewDriverLogin()
//}
