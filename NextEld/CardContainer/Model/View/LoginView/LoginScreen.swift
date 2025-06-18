//
//  LoginScreen.swift
//  NextEld
//
//  Created by Priyanshi on 05/05/25.
//

import SwiftUI



struct LoginScreen: View {
    
    @EnvironmentObject var navManager: NavigationManager
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
        
     //   NavigationStack(path: $navManager.path){
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
                
            
                
                // Login Button
                Button(action: {
                    print("Login tapped!")
                    //alertAction = true
                    navManager.navigate(to: .Scanner)
                    
                }) {
                   
                    Text("Log - In")
                        .font(.callout)
                        .foregroundColor(.blue)
                        .frame(width: txtFieldWidth, height: txtFieldHeight)
                        .background(Color.white)
                        .cornerRadius(10)
                        .alert(isPresented:$alertAction) {
                                    Alert(
                                        title: Text(" Email is Empty"),
                                        message: Text("Fill the email Correctly"),
                                        dismissButton: .default(Text("Ok"))
                                    )
                                }
                }
                .padding(.top, 10)
                
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
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.blue)
            .navigationBarTitleDisplayMode(.inline)
     //  }
    }
}

//#Preview {
//    //LoginScreen()
//    RootView()
//        .environmentObject(NavigationManager())
//}
