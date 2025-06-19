//
//  SplashView.swift
//  NextEld
//
//  Created by Priyanshi on 07/05/25.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject var navManager: NavigationManager
    @State private var offSetImage: CGFloat = 300
    @State var fadeOut : Bool = false

    var body: some View {
        
        VStack {
            Image("NextEld")
                .padding(0.0)
                .scaledToFit()
                .frame(width: 150, height: 150)
                .offset(y: offSetImage)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.blue))
        .ignoresSafeArea()
        .onAppear {
            // Run animation
            withAnimation(.easeOut(duration: 2.0)) {
                offSetImage = 0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                         withAnimation(.easeInOut(duration: 0.5)) {
                             fadeOut = true
                         }
                     }
                     // Navigate to Login screen after fade
                     DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                         navManager.navigate(to: .Login)
                     }
        }
    }
}

//#Preview {
//    RootView()
//        .environmentObject(NavigationManager())
//
//}
