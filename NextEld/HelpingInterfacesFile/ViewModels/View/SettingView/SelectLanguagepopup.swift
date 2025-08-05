//
//  SelectLanguagepopup.swift
//  NextEld
//
//  Created by priyanshi on 30/05/25.
//

import Foundation
import SwiftUI

struct SelectLanguagepopup:View {
    
    @Binding var selectedlanguage: String?
    @Binding var isPresented: Bool
    let languagesSelect: [String] = ["English" , "Hindi" , "Panjabi"]
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Language")
                .font(.headline)
                .padding(.top)

            Divider()
                VStack(spacing: 12) {
                    ForEach(languagesSelect, id: \.self) { lang in
                        HStack {
                            Text(lang)
                                .foregroundColor(.black)

                            Spacer()

                            Image(systemName: selectedlanguage == lang ? "checkmark.circle.fill" : "checkmark.circle")
                                .foregroundColor(Color(uiColor: .wine))
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedlanguage = lang
                        }
                        Divider()
                    }
                }
                .padding(.horizontal)
      

            Button(action: {
                isPresented = false
            }) {
                Text("Ok")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
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

