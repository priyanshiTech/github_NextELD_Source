//
//  SettingsLanguageView.swift
//  NextEld
//  Created by Priyanshi   on 30/05/25.
//
import Foundation
import SwiftUI


struct SettingsLanguageView: View {
    
    @EnvironmentObject var navmanager: NavigationManager
  
    
    @State private var selectedLanguage: String? = nil
    @State private var showLanguagePicker: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Top line
                Color(uiColor: .wine)
                    .edgesIgnoringSafeArea(.top)
                    .frame(height: 1)
                
                // Header bar
                HStack {
                    Button(action: {
                        navmanager.goBack()
                    }) {
                        Image(systemName: "arrow.left")
                            .bold()
                            .foregroundColor(.white)
                            .imageScale(.large)
                    }
                    
                    Text(AppConstants.settingTittle)
                        .font(.headline)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                    
                    Spacer()
                }
                .padding()
                .background(Color(uiColor: .wine).shadow(radius: 1))
                
                // MARK: - Language Selection Card
                CardContainer {
                    Button(action: {
                        showLanguagePicker = true
                    }) {
                        HStack {
                            Image("globe")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding(.top, 4)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Language")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                
                                Text(selectedLanguage ?? "Select language")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.black)
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal)
                        .background(Color.white)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(20)
                
                Spacer()
                
                // MARK: - Terms & Privacy Button
                HStack {
                    Button(action: {
                        //MARK: -  Add navigation here
                        print("Terms & Privacy tapped")
                    }) {
                        HStack(spacing: 4) {
                            Text("Terms & Privacy Policy")
                                .bold()
                                .foregroundColor(.gray)
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.leading, 25)
                    .padding(.bottom, 20)
                    
                    Spacer()
                }
            }
            .navigationBarBackButtonHidden()
            
            // MARK: - Centered Popup (150x150)
            if showLanguagePicker {
                // Dim background
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showLanguagePicker = false
                    }
                
                // Small centered popup
                VStack {
                    SelectLanguagepopup(
                        selectedlanguage: $selectedLanguage,
                        isPresented: $showLanguagePicker
                    )
                    .frame(width: 250, height: 250)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.scale)
                .animation(.spring(), value: showLanguagePicker)
            }
        }
    }
}






//#Preview {
//    SettingsLanguageView( SelectedLanguage: <#Binding<String>#>)
//}
