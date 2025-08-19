//
//  NewDriverLogin.swift
//  NextEld
//
//  Created by Priyanshi   on 27/05/25.
//

import SwiftUI

struct NewDriverLogin: View {
    
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
    
    var tittle : String = "Co-Driver Log-In"
    
    
    var body: some View {
        
               VStack(spacing: 30) {
         
                   HStack {
                       Button(action: {
                           navManager.goBack()
                       }) {
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
                   .frame(height: 1) // increased for better spacing
                   
                   
                   
                   
                   
                   Text("Next ELD")
                       .font(.largeTitle)
                       .fontWeight(.bold)
                       .foregroundColor(.white)
                       .padding(.top, 80)
                   
                
                   
                   HStack {
                       Image(systemName: "gmail")
                           .foregroundColor( Color(uiColor: .wine))
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
                           .foregroundColor( Color(uiColor: .wine))

                
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
                               .foregroundColor( Color(uiColor: .wine))
                       }
                   }
                   .padding(.horizontal)
                   .frame(width: txtFieldWidth, height: txtFieldHeight)
                   .background(Color.white)
                   .cornerRadius(10)
                   .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.5), lineWidth: 0))
                   
                   .frame(width: txtFieldWidth, height: txtFieldHeight)
                   
        
                   //MARK: -  adding a Co- driver inspection Details
                   
                  HStack{
                       Text("The Current driver will be signed out and you will become Driver. Notice as per requirements from FMCSA and CCMTA")
                           .font(.callout)
                           .bold()
                           .foregroundColor(.white)
                           .frame(width: txtFieldWidth, alignment: .leading)

                   }
               
                   
                   // Login Button
                   Button(action: {
                       print("Login tapped!")
                       //alertAction = true
                       navManager.navigate(to: .Scanner)
                       
                   }) {
                      
                       Text("Log - In")
                           .font(.callout)
                           .foregroundColor( Color(uiColor: .wine))
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
    
                   
                   
                   Spacer()
               }
               .frame(maxWidth: .infinity, maxHeight: .infinity)
               .background( Color(uiColor: .wine))
               .navigationBarTitleDisplayMode(.inline)
        
       }
}

#Preview {
    NewDriverLogin()
}
