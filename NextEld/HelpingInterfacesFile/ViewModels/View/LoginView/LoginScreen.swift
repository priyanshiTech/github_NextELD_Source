//
//  LoginScreen.swift
//  NextEld
//
//  Created by Priyanshi on 05/05/25.
//





import SwiftUI

struct LoginScreen: View {
    @EnvironmentObject var navManager: NavigationManager
    @EnvironmentObject var session: SessionManager
    @EnvironmentObject var loginVM: LoginViewModel

    @State private var alertVisible = false
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordShowing = false
    @State private var txtFieldHeight: CGFloat = 56
    @State private var txtFieldWidth: CGFloat = 320
    @Binding var isLoggedIn: Bool

    var body: some View {
        VStack(spacing: 15) {
            Text("Next ELD")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 80)

            //  Email field with validation
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(.blue)
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
            }
            .inputBoxStyle(isValid: email.isEmpty || isValidEmail(email))

            // Inline validation message
            if !email.isEmpty && !isValidEmail(email) {
                Text("Enter a valid email address")
                    .foregroundColor(.red)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 5)
            }

            //  Password field with validation
            HStack {
                Image(systemName: "lock")
                    .foregroundColor(.blue)

                if isPasswordShowing {
                    TextField("Password", text: $password)
                        .autocapitalization(.none)
                } else {
                    SecureField("Password", text: $password)
                        .autocapitalization(.none)
                }

                Button {
                    isPasswordShowing.toggle()
                } label: {
                    Image(systemName: isPasswordShowing ? "eye.fill" : "eye.slash.fill")
                        .foregroundColor(.blue)
                }
            }
            .inputBoxStyle(isValid: password.isEmpty || isValidPassword(password))

            // Inline validation message
            if !password.isEmpty && !isValidPassword(password) {
               // Text("Password must be 8+ chars, 1 uppercase, 1 number & 1 symbol")
                   Text( "Password must be numeric (min 4 digits)")
                    .foregroundColor(.red)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 5)
            }

            // Forget Password
            Button {
                navManager.navigate(to: .ForgetPassword(tittle: "Forget Password"))
            } label: {
                Text("Forget Password?")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal, 20)
            }
            
            //MARK:  With API Verification
            Button {
                if !isValidEmail(email) || !isValidPassword(password) {
                    alertVisible = true
                    return
                }

                Task {
                    let success = await loginVM.login(email: email, password: password)

                    if success && SessionManagerClass.shared.isLoggedIn() {
                        isLoggedIn = true
                        navManager.navigate(to: .Scanner)
                    } else {
                        alertVisible = true
                    }
                }
            } label: {
                Text("Log - In")
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background((isValidEmail(email) && isValidPassword(password)) ? Color.white : Color.gray.opacity(0.3))
                    .cornerRadius(10)
            }
            .frame(width: txtFieldWidth, height: txtFieldHeight)
            .disabled(!isValidEmail(email) || !isValidPassword(password))


            // Loading indicator
            if loginVM.isLoading {
                ProgressView("Logging in...")
                    .padding()
            }

            Spacer()

            // Forget Username
            Button {
                navManager.navigate(to: .ForgetUser(tittle: "Forget Username"))
            } label: {
                Text("Forget Username?")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }

            Spacer()

            // Error message from API
            if let error = loginVM.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.blue.ignoresSafeArea())
        .alert(isPresented: $alertVisible) {
            Alert(
                title: Text("Validation Error"),
                message: Text("Please enter a valid email and password."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

//  Email Validation
func isValidEmail(_ email: String) -> Bool {
    let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
    return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
}

//  Password Validation
//func isValidPassword(_ password: String) -> Bool {
//    // At least 8 chars, 1 uppercase, 1 lowercase, 1 number, 1 special char
//    let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"
//    return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
//}


//  Password Validation (Only Numbers, min 4 digits)
func isValidPassword(_ password: String) -> Bool {
    let passwordRegex = "^[0-9]{4,}$"
    return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
}


extension View {
    func inputBoxStyle(
        width: CGFloat = 320,
        height: CGFloat = 56,
        isValid: Bool = true
    ) -> some View {
        self
            .padding(.horizontal)
            .frame(width: width, height: height)
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isValid ? Color.gray.opacity(0.5) : Color.red, lineWidth: 1.5)
            )
    }
}




















   












































/*struct LoginScreen: View {
    @EnvironmentObject var navManager: NavigationManager
    @EnvironmentObject var session: SessionManager
    @EnvironmentObject var loginVM: LoginViewModel

    @State private var alertVisible = false
    @State private var email = ""
    @State private var password = ""
    @State private var alertAction = false
    @State private var navigateForgetPassword = false
    @State private var navigateUserName = false
    @State private var selectedTitle = ""
    @State private var isPasswordShowing = false
    @State private var txtFieldHeight: CGFloat = 56
    @State private var txtFieldWidth: CGFloat = 320
    @Binding var isLoggedIn: Bool
    

    var body: some View {
        VStack(spacing: 30) {
            Text("Next ELD")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 80)

            // Email field
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(.blue)
                TextField("Email", text: $email)
                    .autocapitalization(.none)
            }
            .inputBoxStyle()

            // Password field
            HStack {
                Image(systemName: "lock")
                    .foregroundColor(.blue)

                if isPasswordShowing {
                    TextField("Password", text: $password)
                        .autocapitalization(.none)
                        .textFieldStyle(PlainTextFieldStyle())
                } else {
                    SecureField("Password", text: $password)
                        .autocapitalization(.none)
                        .textFieldStyle(PlainTextFieldStyle())
                }

                Button {
                    isPasswordShowing.toggle()
                } label: {
                    Image(systemName: isPasswordShowing ? "eye.fill" : "eye.slash.fill")
                        .foregroundColor(.blue)
                }
            }
            .inputBoxStyle()

            // Forget Password
            Button {
                navManager.navigate(to: .ForgetPassword(tittle: "Forget Password"))
            } label: {
                Text("Forget Password?")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal, 20)
            }

            Button {
                if email.isEmpty || password.isEmpty{
                    alertVisible = true
                }
                else{
                    Task {
                        await loginVM.login(email: email, password: password)
                        navManager.navigate(to: .Scanner)
                        if SessionManagerClass.shared.isLoggedIn() {
                            isLoggedIn = true
                            
                        }
                    }
                }
            } label: {
                Text("Log - In")
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
            }
            .frame(width: txtFieldWidth, height: txtFieldHeight)




            // Loading indicator
            if loginVM.isLoading {
                ProgressView("Logging in...")
                    .padding()
            }

            Spacer()

            // Forget Username
            Button {
                navManager.navigate(to: .ForgetUser(tittle: "Forget Username"))
            } label: {
                Text("Forget Username?")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }

            Spacer()

            // Error message
            if let error = loginVM.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.blue.ignoresSafeArea())
        .alert(isPresented: $alertVisible) {
            Alert(
                title: Text("Input Error"),
                message: Text("Email and Password cannot be empty."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

extension View {
    func inputBoxStyle(width: CGFloat = 320, height: CGFloat = 56) -> some View {
        self
            .padding(.horizontal)
            .frame(width: width, height: height)
            .background(Color.white)
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.5)))
    }
}*/





















































