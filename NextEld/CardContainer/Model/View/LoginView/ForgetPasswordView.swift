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

    @FocusState private var isfocusState:Bool
    var body: some View {
        
        VStack(spacing: 0) {
            //MARK: -  Custom Header
            ZStack(alignment: .topLeading){
                Color.blue
                    .edgesIgnoringSafeArea(.top)
                    .frame(height:20)
              
            }
            HStack {
                Button(action: {
                 //   presentationMode.wrappedValue.dismiss()
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
            .background(Color.blue.shadow(radius: 1))
            .frame(height: 40, alignment: .topLeading)
            Spacer()
            VStack {
                HStack {
                    Image("gmail")
                        .foregroundColor(.blue)
                    TextField("Enter Email ", text: $EntEmail)
                        .focused($isfocusState)
                       
                }
                .padding()
                .frame(height: 50)
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.blue, lineWidth: 2)
                )
                .padding()
                
                
                Text("Please Enter Valid Email Address")
                    .font(.system(size: 18))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 5)
                
                    .padding()
                
                
                if isfocusState {
                               Button("Continue") {
                                   //MARK: button action here
                                   print("Continue tapped with number: \(EntEmail)")
                               }
                               .bold()
                               .padding()
                               .background(Color.blue)
                               .foregroundColor(.white)
                               .font(.system(size: 18))
                               .cornerRadius(5)
                               .transition(.opacity)
                               .animation(.easeInOut, value: isfocusState)
                           }
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
    
}

#Preview {
    ForgetPasswordView( title: "Forget Password")
}
