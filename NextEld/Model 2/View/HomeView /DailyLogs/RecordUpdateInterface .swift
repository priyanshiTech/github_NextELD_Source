//
//  RecordUpdateInterface .swift
//  NextEld
//
//  Created by priyanshi on 19/08/25.
//

import Foundation
import SwiftUI

struct ReportConfirmationView: View {
    @EnvironmentObject var navManager: NavigationManager

    var body: some View {
        VStack(spacing: 30) {
            
            // Title Bar
            HStack {
                Spacer()
                Text("Log Report")
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.top, 16)
            
            Spacer()
            
            // Center Image
            Image(systemName: "envelope.circle.fill") // Replace with your custom image
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundColor(Color(uiColor: .wine))
            
            // Message
            Text("Log report sent successfully, please check your mail.")
                .multilineTextAlignment(.center)
                .font(.system(size: 18))
                .foregroundColor(.black)
                .padding(.horizontal, 24)
            
            Spacer()
            
            // Go Back Button
            Button(action: {
                navManager.goBack()
            }) {
                Text("Go Back")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(uiColor: .wine))
                    .foregroundColor(.white)
                    .cornerRadius(25)
                    .padding(.horizontal, 32)
            }
            
            Spacer(minLength: 20)
        }
        .background(Color.white.ignoresSafeArea())
    }
}

#Preview {
    ReportConfirmationView()
}
