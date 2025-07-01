//
//  AppLauncCode.swift
//  NextEld
//
//  Created by priyanshi    on 30/06/25.
//
//



import SwiftUI


//struct AppStartupView: View {
//    @EnvironmentObject var loginVM: LoginViewModel
//    @AppStorage("hasLoggedIn") var hasLoggedIn: Bool = false
//    @State private var checkedToken = false
//
//    var body: some View {
//        Group {
//            if !checkedToken {
//                ProgressView("Loading...")
//            } else {
//                if hasLoggedIn, loginVM.token != nil {
//                    RootView() // ✅ Correctly navigate to home
//                } else {
//                    LoginScreen()
//                }
//            }
//        }
//        .onAppear {
//            if !checkedToken {
//                loginVM.loadSavedSession()
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                    checkedToken = true
//                }
//            }
//        }
//    }
//}



struct AppStartupView: View {
    @EnvironmentObject var loginVM: LoginViewModel
    @AppStorage("hasLoggedIn") var hasLoggedIn: Bool = false
    @State private var checkedToken = false

    var body: some View {
        Group {
            if !checkedToken {
                ProgressView("Loading...")
            } else {
                if hasLoggedIn, let _ = loginVM.token {
//                    HomeScreenView(
//                        presentSideMenu: .constant(false),
//                        selectedSideMenuTab: .constant(0)
//                    )
                    RootView()

                } else {
                    LoginScreen()
                }
            }
        }
        .onAppear {
            if !checkedToken {
                loginVM.loadSavedSession()
                checkedToken = true
            }
        }
    }
}
































