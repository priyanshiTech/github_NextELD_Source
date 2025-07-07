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

            // Login Button
//            Button(action: {
//                if email.isEmpty || password.isEmpty {
//                    alertVisible = true
//                } else {
//                    Task {
//                        await loginVM.login(email: email, password: password)
//                        if session.isLoggedIn {
//                            navManager.navigate(to: .Scanner)
//                        }
//                    }
//                }
//            })
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
}
























































/*import SwiftUI
struct LoginScreen: View {
    
    @EnvironmentObject var navManager: NavigationManager
   // @StateObject private var loginVM = LoginViewModel(session: <#SessionManager#>)   // MARK: - referance
 

    @State private var alertVisible = false

    @State private var email = ""
    @State private var password = ""
    @State private var alertAction = false
    @State private var navigateForgetPassword = false
    @State private var navigateUserName = false
    @State private var selectedTitle = ""
    @State private var isPasswordShowing = Bool()
    @State private var txtFieldHeight: CGFloat = 56
    @State private var txtFieldWidth: CGFloat = 320
    
    var body: some View {
        
            VStack(spacing: 30) {
                Text("Next ELD")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 80)
                
             
                
                HStack {
                    Image(systemName: "gmail")
                        .foregroundColor(.blue)
                    TextField("Email", text: $email)
                        .autocapitalization(.none)
                }
                .padding(.horizontal)
                .frame(width: txtFieldWidth, height: txtFieldHeight)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.5), lineWidth: 0))
                .frame(width: txtFieldWidth, height: txtFieldHeight)
                
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
                    Button(action: {
                        isPasswordShowing.toggle()
                    }) {
                        Image(systemName: isPasswordShowing ? "eye.fill" : "eye.slash.fill")
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)
                .frame(width: txtFieldWidth, height: txtFieldHeight)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.5), lineWidth: 0))
                
                .frame(width: txtFieldWidth, height: txtFieldHeight)
                
                
                Button(action: {
                    navManager.navigate(to: .ForgetPassword(tittle: "Forget Password"))
                    print("Forget Password tapped!")
                    
                }) {
                    
                    Text("Forget Password?")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.horizontal, 20)
                }

//  Log In Button
 Button(action: {
     if email.isEmpty || password.isEmpty {
         alertVisible = true
     } else {
         Task {
             await loginVM.login(email: email, password: password)
             navManager.navigate(to: AppRoute.Scanner)
         }
     }
 }){
     Text("Log - In")
         .foregroundColor(.blue)
         .frame(maxWidth: .infinity)
         .padding()
         .background(Color.white)
         .cornerRadius(10)
 }
 
 .frame(width: txtFieldWidth, height: txtFieldHeight)



                
                
 if loginVM.isLoading {
     ProgressView("Logging in...")
         .padding()
 }

 Spacer()
 .padding()
 .background(Color.blue.ignoresSafeArea())
 .alert(isPresented: $alertVisible) {
     Alert(
         title: Text("Input Error"),
         message: Text("Email and Password cannot be empty."),
         dismissButton: .default(Text("OK"))
     )
 }
                // Forget Username
                Button(action: {
                    navManager.navigate(to: .ForgetUser(tittle: "Forget Password"))

                    print("Forget Username tapped!")
                }) {
                    Text("Forget Username?")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }

                Spacer()
                if let error = loginVM.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.blue)
            .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    //LoginScreen()
//    RootView()
//        .environmentObject(NavigationManager())
//}*/
