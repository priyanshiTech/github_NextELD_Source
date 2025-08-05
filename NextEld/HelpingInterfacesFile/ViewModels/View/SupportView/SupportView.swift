//
//  SupportView.swift
//  NextEld
//
//  Created by priyanshi   on 30/05/25.
//

import SwiftUI

struct SupportView: View {
    
    @State private var queryText: String = ""
    @EnvironmentObject var navmanager: NavigationManager
    
    
    var body: some View {
                
                VStack {
                    // Custom navigation bar
                    HStack {
                        Button(action: {
                            navmanager.goBack()
                        }) {
                            Image(systemName: "arrow.left")
                                .bold()
                                .foregroundColor(.white)
                                .imageScale(.large)
                        }
                        Text("Help and Support")
                            .font(.headline)
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    .padding()
                    .background(Color(uiColor: .wine))
                    
                    UniversalScrollView {
                        VStack(/*alignment: .leading,*/ spacing: 16) {
                            Text("If you are experiencing any issue, please let us know. We will try to solve them as soon as possible.")
                                .font(.body)
                                .bold()
                                .foregroundColor(.gray)
                            
                            Text("Explain the problem")
                                .font(.body)
                                .bold()
                                .foregroundColor(.gray)
                            
                            // Multiline text field
                            ZStack(alignment: .topLeading) {
                                // Placeholder
                                if queryText.isEmpty {
                                    Text("Type your query here")
                                        .foregroundColor(.gray)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 12)
                                }

                                // TextEditor
                                TextEditor(text: $queryText)
                                    .padding(8)
                                    .background(Color.white)
                                    .frame(height: 200)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(uiColor: .wine), lineWidth: 2)
                                    )
                            }


                            // Submit button
                            Button(action: {
                                // Submit action here
                            }) {
                                Text("Submit")
                                    .frame(maxWidth: 100)
                                    .padding()
                                    .bold()
                                    .background(Color(uiColor: .wine))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }

                            Spacer()
                        }
                        .padding()
                    }

                    //MARK: -  Bottom contact section
                    HStack {
                        Image(systemName: "headphones")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)

                        VStack(alignment: .leading, spacing: 5) {
                            Text("Contact Us")
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(.white)
                                
                            Text("+919876543210")
                                .bold()
                                .font(.footnote)
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color(uiColor: .wine))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                }.navigationBarBackButtonHidden()
                .background(Color.white.edgesIgnoringSafeArea(.all))
            }
        }

#Preview {
    SupportView()
}
