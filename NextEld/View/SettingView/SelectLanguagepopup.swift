//
//  SelectLanguagepopup.swift
//  NextEld
//
//  Created by priyanshi on 30/05/25.
//

import Foundation
import SwiftUI

struct SelectLanguagepopup: View {
    
    let options: [LanguageOption]
    @Binding var selectedLanguageCode: String
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            Text("language")
                .font(.headline)
                .padding(.top)
            
            Divider()
            
            VStack(spacing: 12) {
                ForEach(options) { option in
                    HStack {
                        Text(option.displayName)
                            .foregroundColor(Color(uiColor:.black))
                        
                        Spacer()
                        
                        Image(systemName: selectedLanguageCode == option.code ? "checkmark.circle.fill" : "checkmark.circle")
                            .foregroundColor(Color(uiColor: .wine))
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedLanguageCode = option.code
                        isPresented = false
                    }
                    
                    Divider()
                }
            }
            .padding(.horizontal)
            
            Button(action: {
                isPresented = false
            }) {
                Text("ok")
                    .fontWeight(.bold)
                    .foregroundColor(Color(uiColor:.white))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(uiColor: .wine))
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
