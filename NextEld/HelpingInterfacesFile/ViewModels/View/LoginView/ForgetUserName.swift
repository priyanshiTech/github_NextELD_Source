//
//  ForgetUserName.swift
//  NextEld
//  Created by Priyanshi on 05/05/25.
//


import SwiftUI

struct ForgetUserName: View {
    var title: String
    @State  var mobNumber  = ""
   // @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var navManager: NavigationManager
    @FocusState  private var istextfieldFocus: Bool

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
                       // presentationMode.wrappedValue.dismiss()
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
                HStack{
                    Image("phone-call")
                        .foregroundColor(.blue)
                    TextField("Enter Mobile Number", text: $mobNumber)
                        .focused($istextfieldFocus)
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
                            .padding()
                
                if istextfieldFocus {
                               Button("Continue") {
                                   //MARK: button action here
                                   print("Continue tapped with number: \(mobNumber)")
                               }
                               .bold()
                               .padding()
                               .background(Color.blue)
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
    }
}
#Preview {
    ForgetUserName( title: "Forget UserName")
}
