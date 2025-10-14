//
//  LoginFlowView.swift
//  NextEld
//
//  Created by priyanshi   on 09/10/25.
//

import Foundation
import SwiftUI
import SwiftUI

struct LoginFlowView: View {
    @Binding var isLoggedIn: Bool

    var body: some View {
        
        NavigationStack {
            
            LoginScreen(isLoggedIn: $isLoggedIn)
                .navigationDestination(for: AppRoute.LoginFlow.self) { route in
                    switch route {
                    case .login:
                        LoginScreen(isLoggedIn: $isLoggedIn)
                    case .ForgetPassword(let title):
                        ForgetPasswordView(title: title)
                    case .ForgetUser(let title):
                        ForgetUserName(title: title)
                    case .newDriverLogin(let title, let email):
                        NewDriverLogin(isLoggedIn: $isLoggedIn, tittle: title, UserName: email)
                    case .CoDriverLogin:
                        CoDriverLogin()
                    }
                }
        }
    }
}



