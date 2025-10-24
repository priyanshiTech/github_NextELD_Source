//
//  ForgetPasswordView.swift
//  NextEld
//
//  Created by Priyanshi on 05/05/25.
//


import SwiftUI

struct ForgetPasswordView: View {

    @State var EntEmail = ""
    var title: String
    @EnvironmentObject var navManager: NavigationManager
    @StateObject private var viewModel = ForgetPasswordViewModel()
    @FocusState private var isfocusState: Bool

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Custom Top Header
            ZStack(alignment: .topLeading) {
                Color(uiColor: .wine)
                    .edgesIgnoringSafeArea(.top)
                    .frame(height: 0)
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
            .frame(height: 80, alignment: .topLeading)


            VStack(spacing: 20) {
                // MARK: - Email Field
         
                HStack {
                    Image("gmail")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color(uiColor: .wine))

                    TextField("Enter Email", text: $EntEmail)
                        .focused($isfocusState)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                .padding()
                .frame(height: 50)
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(uiColor: .wine), lineWidth: 2)
                )
                .padding(.horizontal)

                // MARK: - Hint Text
                Text("Please Enter Valid Email Address")
                    .font(.system(size: 18))
                    .foregroundColor(.gray)
                    .padding(.horizontal)

                // MARK: - Continue Button
                if isfocusState {
                    Button("Continue") {
                        print("Continue tapped with number: \(EntEmail)")
                        viewModel.username = EntEmail //  pass to ViewModel

                        Task {
                            await viewModel.submitForgetPassword()
                        }
                    }
                    .bold()
                    .padding()
                    .background(Color(uiColor: .wine))
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .cornerRadius(5)
                    .transition(.opacity)
                    .animation(.easeInOut, value: isfocusState)
                }

                Spacer()
            }

            Spacer()
        }
        .navigationBarHidden(true)
        .alert("Response", isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.message)
        }
    }
}



#Preview {
    ForgetPasswordView( title: "Forget Password")
}
