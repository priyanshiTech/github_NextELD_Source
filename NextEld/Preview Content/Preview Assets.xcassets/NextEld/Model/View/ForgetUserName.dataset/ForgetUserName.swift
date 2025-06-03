//
//  ForgetUserName.swift
//  NextEld
//  Created by AroGeek11 on 05/05/25.
//


import SwiftUI

struct ForgetUserName: View {
    var title: String
    @State  var mobNumber  = ""
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
                HStack{
                    Image(systemName: "gmail")
                        .foregroundColor(.blue)
                    TextField("Enter Mobile Number", text: $mobNumber)
                }
                .padding()
                .frame(height: 50)
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.blue, lineWidth: 2)
                )
                .padding()
        
                Text("We'll Send a sms for User Name")
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
    ForgetUserName( title: "Forget UserName")
}
