//
//  LogOut.swift
//  NextEld
//
//  Created by priyanshi on 30/05/25.
//

import SwiftUI



struct LogOutPopup: View {
    @Binding var isCycleCompleted: Bool
    var currentStatus: String
    var onLogout: () -> Void
    var onCancel: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            
            Text("Log Out")
                .font(.title.bold())
                .foregroundColor(Color(uiColor: .wine))

            VStack(spacing: 20) {
                HStack {
                    Text("Your current status is:")
                    Text(currentStatus)
                        .foregroundColor(Color(uiColor: .wine))
                        //.underline()
                }

                HStack {
                    Text("Go Off-Duty before Log-out")
                        .font(.subheadline)
                        .foregroundColor(.black)
                }
                
                HStack (spacing: 2){

                    CheckboxButton()
                    Text("Your Cycle is Completed ? ")
                    
                }
             
            }
            .padding(.top, 10)

            Button("Log-out", action: onLogout)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(uiColor: .wine))
                .foregroundColor(.white)
                .cornerRadius(10)

            Button("Back", action: onCancel)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
        }
        .padding()
    }
}

struct LogOut: View {
    @State private var isPresented: Bool = true
    @State private var isCycleCompleted: Bool = false
    @StateObject private var logoutVM = APILogoutViewModel()

    var body: some View {
        ZStack {
            Color.black.opacity(0.1)
                .ignoresSafeArea()

            if isPresented {
                PopupContainer(isPresented: $isPresented) {
                    LogOutPopup(
                        isCycleCompleted: $isCycleCompleted,
                        currentStatus: "OffDuty",
                        onLogout: {
                            print("Logging out…")
                            Task {
                                await logoutVM.callLogoutAPI()  
                                isPresented = false
                            }
                            isPresented = false
                        },
                        onCancel: {
                            print("Cancel logout")
                            isPresented = false
                        }
                    )
                }
            }
        }
    }
}


//#Preview {
//    LogOut()
//}
