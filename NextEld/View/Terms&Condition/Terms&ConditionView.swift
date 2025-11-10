//
//  Terms&ConditionView.swift
//  NextEld
//
//  Created by Inurum   on 08/11/25.
//

import SwiftUI

struct Terms_ConditionView: View {
    
    @EnvironmentObject var navmanager: NavigationManager
    var tittle: String
    @State private var isLoading = true

    
    var body: some View {
        VStack(spacing: 0) {
            
            Color(uiColor: .wine)
                .edgesIgnoringSafeArea(.top)
                .frame(height: 1)
            // MARK: - Top Bar
            HStack(spacing: 12) {
                Button(action: {
                    navmanager.goBack()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                        .imageScale(.large)
                        .frame(width: 44, height: 44)
                }
                Text(tittle)
                    .font(.headline)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(Color(uiColor: .wine).shadow(radius: 1))
            
            // MARK: - WebView
            if let url = URL(string: API.privacyPolicyURL) {
                ZStack {
                    WebView(url: url ,isLoading: $isLoading)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    if isLoading {
                        VStack(spacing: 8) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                            Text("Loading…")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                        .padding(16)
                        .background(Color.black.opacity(0.15))
                        .cornerRadius(10)
                    }
                }
            } else {
                Text("Invalid URL")
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    Terms_ConditionView( tittle: "Terms & condition")
}
