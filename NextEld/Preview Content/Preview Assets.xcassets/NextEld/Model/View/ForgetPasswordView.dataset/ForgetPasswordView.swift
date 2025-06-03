//
//  ForgetPasswordView.swift
//  NextEld
//
//  Created by AroGeek11 on 05/05/25.
//

import SwiftUI

struct ForgetPasswordView: View {
    
    @State var EntEmail = ""
    var title: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        VStack(spacing: 5) {
            //MARK: -  Custom Header
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
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
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
    
}

#Preview {
    ForgetPasswordView( title: "Forget Password")
}
