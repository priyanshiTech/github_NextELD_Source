//
//  SessionExpireUIView.swift
//  NextEld
//
//  Created by priyanshi on 11/11/25.
//

import SwiftUI

struct SessionExpireUIView: View {

        @EnvironmentObject var navManager: NavigationManager
        var onSignInAgain: (() -> Void)? = nil
        
        var body: some View {
            
            VStack(spacing: 30) {
                
             
                // replace with your truck image asset
                   Image("Excel")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(.top, 10)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 5, y: 5)
                    .padding()
               
                Text("Session Expired")
                    .font(.title)
                    .bold()
                    .fontWeight(.medium)
                    .foregroundColor(.black)

                
                
                  //Message
                Text("You have been logged out and logged-in on another device")
                
                    .font(.system(size: 20))
                    .bold()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 30) //  Adds left & right space
                    .fixedSize(horizontal: false, vertical: true)
                  
         
                // Sign-In Again button
                Button(action: {
                    onSignInAgain?()
                    
                }) {
                    Text("SIGN-IN AGAIN")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(uiColor: .wine))
                        .cornerRadius(25)
                        .padding(.horizontal, 30)
                }
                .padding(.bottom, 40)
            }
            .background(Color.white.ignoresSafeArea())
        }
    }

#Preview {
    SessionExpireUIView()
}
