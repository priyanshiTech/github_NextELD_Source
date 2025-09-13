//
//  ForgetUserName.swift
//  NextEld
//  Created by Priyanshi on 05/05/25.
//


import SwiftUI

struct ForgetUserName: View {
    var title: String
    @State  var mobNumber  = ""
    @EnvironmentObject var navManager: NavigationManager
    @StateObject private var viewModel = ForgetUsernameViewModel()

    @FocusState  private var istextfieldFocus: Bool

   
    var body: some View {
        VStack(spacing: 0) {
            //MARK: -  Custom Header
            
            ZStack(alignment: .topLeading){
                Color(uiColor: .wine)
                    .edgesIgnoringSafeArea(.top)
                    .frame(height:20)
            }
                HStack {
                    Button(action: {
                        navManager.goBack()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .imageScale(.large)
                    }
                    
                    Text(title)
                     
                        .font(.headline)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                    Spacer()
                }
            
               
            .padding()
            .background(Color(uiColor: .wine).shadow(radius: 1))
            .frame(height: 60, alignment: .topLeading)
            Spacer()
            VStack {
                HStack{
                    Image("phone-call")
                        .foregroundColor(Color(uiColor: .wine))
                    TextField("Enter Mobile Number", text: $mobNumber)
                        .focused($istextfieldFocus)
                }
                .padding()
                .frame(height: 50)
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(uiColor: .wine), lineWidth: 2)
                )
                .padding()
                
                        Text("We'll Send a sms for User Name")
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 5)
                            .padding()
                
                if istextfieldFocus {
                               Button("Continue") {
                                   //MARK: button action here
                                   Task {
                                       await viewModel.submitForgetUsername()
                                   }
                                   print("Continue tapped with number: \(mobNumber)")
                               }
                               .bold()
                               .padding()
                               .background(Color(uiColor: .wine))
                               .foregroundColor(.white)
                               .cornerRadius(10)
                               .font(.system(size: 18))
                               .transition(.opacity)
                               .animation(.easeInOut, value: istextfieldFocus)
                           }
        
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .alert("Response", isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.message)
        }
    }
}
//#Preview {
//    ForgetUserName( title: "Forget UserName")
//}
