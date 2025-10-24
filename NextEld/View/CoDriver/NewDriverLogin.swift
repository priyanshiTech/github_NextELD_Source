//
//  NewDriverLogin.swift
//  NextEld
//
//  Created by Priyanshi  on 27/05/25.
//
import SwiftUI

struct NewDriverLogin: View {
    @EnvironmentObject var navManager: NavigationManager
    @EnvironmentObject var session: SessionManager
    @EnvironmentObject var loginVM: LoginViewModel
    @StateObject private var viewModel = APILoginLogViewModel()
    @StateObject private var logoutVM = APILogoutViewModel()

    @Binding var isLoggedIn: Bool
    
    @State private var UserText: String = ""   // start empty, sync later
   // @State private var emailText: String = ""   // start empty, sync later

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
            
            //  Email TextField (auto-filled)
            HStack {
                Image(systemName: "envelope.fill")
                    .foregroundColor(Color(uiColor: .wine))
                TextField("UserName", text: $UserText)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
            }
            .padding(.horizontal)
            .frame(width: txtFieldWidth, height: txtFieldHeight)
            .background(Color.white)
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.5)))
            
            //  Password TextField
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
            .padding(.horizontal)
            .frame(width: txtFieldWidth, height: txtFieldHeight)
            .background(Color.white)
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.5)))
            
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
                Task {
                       // First check if someone is logged in
                       if SessionManagerClass.shared.isLoggedIn() {
                           // Logout current user before logging in new one
                           await logoutVM.callLogoutAPI()
                       }
                       //  Now run login API
                       let success = await loginVM.login(email: UserText, password: password)
                       if success && SessionManagerClass.shared.isLoggedIn() {
                           await viewModel.callLoginLogUpdateAPI()
                           isLoggedIn = true
                           //navManager.navigate(to: AppRoute.homeFlow(.Scanner))
                           navManager.navigate(to: ApplicationRoot.scanner)
                       } else {
                           alertVisible = true
                       }
                   }
            }) {
                Text("Log - In")
                    .font(.callout)
                    .foregroundColor(Color(uiColor: .wine))
                    .frame(width: txtFieldWidth, height: txtFieldHeight)
                    .background(Color.white)
                    .cornerRadius(10)
            }
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .wine))
        .navigationBarTitleDisplayMode(.inline)
        .alert("Login Failed", isPresented: $alertVisible) {
            Button("OK", role: .cancel) { }
        }
        //  Auto-fill email whenever screen appears
        .onAppear {
            self.UserText = UserText
        }
    }
}

//#Preview {
//    NewDriverLogin()
//}
