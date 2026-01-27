//
//  LoginScreen.swift
//  NextEld
//
//  Created by Priyanshi on 05/05/25.
//

import SwiftUI



import SwiftUI

struct LoginScreen: View {
    
    @EnvironmentObject var appRootManager: AppRootManager
    @StateObject var navManager: NavigationManager = NavigationManager()
    @StateObject var loginVM: LoginViewModel = LoginViewModel()
    @StateObject private var viewModel = APILoginLogViewModel()
    
    
    @State private var alertVisible = false
    @State private var UserName: String = ""
    //  @State private var email = ""
    
    @State private var password: String = ""
    @State private var hasLoadedSavedCredentials = false
    @State private var isPasswordShowing = false
    @State private var txtFieldHeight: CGFloat = 56
    @State private var txtFieldWidth: CGFloat = 320
    // @Binding var isLoggedIn: Bool
    @State private var hasNavigated = false
    @State private var selectedVehicleNumber: String = ""
    @State private var selectedVehicleId: Int = 0

    
    var body: some View {
        
        NavigationStack(path: $navManager.path) {
            ZStack {
                VStack(spacing: 15) {
                    Spacer()
                    Text("All Star Elogs")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(Color(uiColor: .white))
                        .padding()
                    //  Email field with validation
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(Color(uiColor: .wine))
                        TextField("UserName", text: $UserName)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .foregroundColor(Color.primary)
                    }
                    .inputBoxStyle(isValid: UserName.isEmpty)
                    
                    // Inline validation message
                    //                if !UserName.isEmpty {
                    //                    // Text("Enter a valid email address")
                    //                    Text("Enter a  UserName")
                    //
                    //                        .foregroundColor(.red)
                    //                        .font(.caption)
                    //                        .frame(maxWidth: .infinity, alignment: .leading)
                    //                        .padding(.horizontal, 5)
                    //                }
                    
                    //  Password field with validation
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(Color(uiColor: .wine))
                        
                        if isPasswordShowing {
                            TextField("Password", text: $password)
                                .autocapitalization(.none)
                                .foregroundColor(Color.primary)
                        } else {
                            SecureField("Password", text: $password)
                                .autocapitalization(.none)
                                .foregroundColor(Color.primary)
                        }
                        
                        Button {
                            isPasswordShowing.toggle()
                        } label: {
                            Image(systemName: isPasswordShowing ? "eye.fill" : "eye.slash.fill")
                                .foregroundColor(Color(uiColor: .wine))
                        }
                    }
                    .inputBoxStyle(isValid: password.isEmpty)
                    
                    // Inline validation message
                    //                if !password.isEmpty && !isValidPassword(password) {
                    //                    // Text("Password must be 8+ chars, 1 uppercase, 1 number & 1 symbol")
                    //                    Text( "Password must be numeric (min 6 digits)")
                    //                        .foregroundColor(Color(uiColor:.red))
                    //                        .font(.caption)
                    //                        .frame(maxWidth: .infinity, alignment: .leading)
                    //                        .padding(.horizontal, 5)
                    //                }
                    
                    // Forget Password
                    Button {
                        navManager.navigate(to: AppRoute.LoginFlow.forgetPassword(tittle: "Forget Password"))
                    } label: {
                        Text("Forget Password?")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(uiColor:.white))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.horizontal, 20)
                    }
                    
                    //MARK:  With API Verification
                    
                    Button {
                        if !isValidPassword(password) {
                            alertVisible = true
                            return
                        }
                        
                        Task {
                            let success = await loginVM.login(email: UserName, password: password)
                            if success && AppStorageHandler.shared.authToken != nil {
                                
                                await viewModel.callLoginLogUpdateAPI()
                                handlePostLoginNavigation()
                                
                            } else {
                                alertVisible = true
                            }
                        }
                        
                    } label: {
                        Text("Log - In")
                            .foregroundColor(Color(uiColor: .wine))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(UIColor.systemGray4))
                            .cornerRadius(10)
                    }
                    
                    .frame(width: txtFieldWidth, height: txtFieldHeight)
                    // .disabled(!isValidPassword(password))
                    
                    // Loading indicator
                    
                    
                    Spacer()
                    
                    // Forget Username
                    Button {
                        navManager.navigate(to: AppRoute.LoginFlow.forgetUser(tittle: "Forget Username"))
                    } label: {
                        Text("Forget Username?")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(uiColor:.white))
                    }
                    
                    Spacer()
                    
                    // Error message from API
                    if let error = loginVM.errorMessage {
                        Text(error)
                            .foregroundColor(Color(uiColor:.red))
                            .padding(.horizontal)
                    }
                }
                
                if loginVM.isLoading {
                    LoadingView()
                        .foregroundStyle(Color.white)
                }
            }
            
            .navigationDestination(for: AppRoute.LoginFlow.self, destination: { route in
                switch route {
                case .forgetPassword(let title):
                    ForgetPasswordView(title: title)
                case .forgetUser(let title):
                    ForgetUserName(title: title)
                }
            })
            .navigationDestination(for: AppRoute.HomeFlow.self, destination: { route in
                switch route {
                case .AddVichleMode:
                    AddVichleMode(
                        selectedVehicle: $selectedVehicleNumber,
                        selectedVehicleId: $selectedVehicleId
                    )
                case .ADDVehicle:
                    ADDVehicle(
                        selectedVehicleNumber: $selectedVehicleNumber,
                        VechicleID: $selectedVehicleId
                    )
                default:
                    EmptyView()
                }
            })
            
            .padding()
            .navigationBarBackButtonHidden()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(uiColor: .wine).ignoresSafeArea())
            .alert(isPresented: $alertVisible) {
                Alert(
                    title: Text("Validation Error"),
                    message: Text("Please enter a valid Username and password."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .onAppear {
            guard !hasLoadedSavedCredentials,
                  let savedUser = loginVM.loadUserData()
            else { return }
            
            UserName = savedUser.username
            password = savedUser.password
            hasLoadedSavedCredentials = true
        }
        .environmentObject(navManager)
    }
    
    private func handlePostLoginNavigation() {
        let disclaimerValue = AppStorageHandler.shared.disclaimerRead ?? 0
        if disclaimerValue == 0 {
            appRootManager.currentRoot = .DisclaimerView
            return
        }
        
        if hasValidVehicleInfo() {
            appRootManager.currentRoot = .scanner(moveToHome: false)
        } else {
            navManager.reset()
            navManager.navigate(to: AppRoute.HomeFlow.AddVichleMode)
        }
    }
    
    private func hasValidVehicleInfo() -> Bool {
        if let vehicleId = AppStorageHandler.shared.vehicleId, vehicleId != 0 {
            return true
        }
        
        if let vehicleNumber = AppStorageHandler.shared.vehicleNo?
            .trimmingCharacters(in: .whitespacesAndNewlines),
           !vehicleNumber.isEmpty,
           vehicleNumber.lowercased() != "none" {
            return true
        }
        
        return false
    }
    
}

//  Email Validation
func isValidEmail(_ email: String) -> Bool {
    let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
    return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
}


// MARK: - Username Validation
func isValidUsername(_ username: String) -> Bool {
    //  letters, numbers 7 underscore allowed, length 3-15
    let usernameRegex = "^[A-Za-z0-9_ ]{3,15}$"
    return NSPredicate(format: "SELF MATCHES %@", usernameRegex).evaluate(with: username)
}


//  Password Validation (Only Numbers, min 4 digits)
func isValidPassword(_ password: String) -> Bool {
    
    return password.count >= 6
}































