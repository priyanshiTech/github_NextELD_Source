//
//  SettingsLanguageView.swift
//  NextEld
//  Created by Priyanshi   on 30/05/25.
//

import SwiftUI

struct SettingsLanguageView: View {
    
    @EnvironmentObject var navmanager: NavigationManager
    var tittle:String = "Settings"
    @State private var SelectedLanguage: String? = nil
    @State private var ShowlanguagePicker: Bool =  false
    
    var body: some View {
        
        VStack(spacing:0){
                
                Color(.blue)
                    .edgesIgnoringSafeArea(.top)
                    .frame(height: 1)
                HStack {
                    Button(action: {
                        navmanager.goBack()
                    }) {
                        Image(systemName: "arrow.left")
                            .bold()
                            .foregroundColor(.white)
                            .imageScale(.large)
                    }
                    
                    Text(tittle)
                        .font(.headline)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                    
                    Spacer()
                }
                .padding()
                .background(Color.blue.shadow(radius: 1))
                
                //MARK: -  Vehicle selection
                CardContainer {
                    Button(action: {
                        ShowlanguagePicker =  true
                    }) {
                        HStack {
                            // Globe icon
                            Image("globe")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding(.top, 4)

                            // Language text + selected language stacked vertically
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Language")
                                    .font(.headline)
                                    .foregroundColor(.black)

                                Text(SelectedLanguage ?? "Select language")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            // Right arrow
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.black)
                        }
                        .padding(.vertical, 12)
                        .padding()
                        .background(Color.white)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(20)

                Spacer()
            
            PopupContainer(isPresented: $ShowlanguagePicker) {
                SelectLanguagepopup(selectedlanguage: $SelectedLanguage, isPresented: $ShowlanguagePicker)
            }
            
            }.navigationBarBackButtonHidden()
            
        }
    }


//#Preview {
//    SettingsLanguageView( SelectedLanguage: <#Binding<String>#>)
//}
