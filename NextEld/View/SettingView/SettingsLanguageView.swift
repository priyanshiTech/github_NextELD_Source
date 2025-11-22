//
//  SettingsLanguageView.swift
//  NextEld
//  Created by Priyanshi   on 30/05/25.
//
import Foundation
import SwiftUI

struct LanguageOption: Identifiable, Equatable {
    let code: String
    let displayName: String
    
    var id: String { code }
}

struct SettingsLanguageView: View {
    
    @EnvironmentObject var navmanager: NavigationManager
    @EnvironmentObject var appRootManager: AppRootManager
    @AppStorage("selectedLanguageCode") private var selectedLanguageCode: String = "en"
    
    @State private var showLanguagePicker: Bool = false
    @State private var appliedLanguageCode: String = ""
    
    private let languageOptions: [LanguageOption] = [
        LanguageOption(code: "en", displayName: "English"),
        LanguageOption(code: "pa", displayName: "ਪੰਜਾਬੀ")
    ]
    
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
                                Text("language")
                                    .font(.headline)
                                    .foregroundColor(Color(uiColor:.black))
                                
                                Text(displayName(for: selectedLanguageCode))
                                    .font(.footnote)
                                    .foregroundColor(Color(uiColor:.gray))
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color(uiColor:.black))
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal)
                        .background(Color(uiColor:.white))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(20)
                
                Spacer()
                
                // MARK: - Terms & Privacy Button
                HStack {
                    Button(action: {
                        navmanager.path.append(AppRoute.HomeFlow.TermsAndCondition)
                        print("Terms & Privacy tapped")
                    }) {
                        HStack(spacing: 4) {
                            Text("terms_privacy_policy")
                                .bold()
                                .foregroundColor(Color(uiColor:.gray))
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Color(uiColor:.gray))
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
                Color(uiColor:.black).opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showLanguagePicker = false
                    }
                
                // Small centered popup
                VStack {
                    SelectLanguagepopup(
                        options: languageOptions,
                        selectedLanguageCode: $selectedLanguageCode,
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
        .onAppear {
            appliedLanguageCode = selectedLanguageCode
        }
        .onChange(of: selectedLanguageCode) { newValue in
            guard newValue != appliedLanguageCode else { return }
            appliedLanguageCode = newValue
            appRootManager.currentRoot = .splashScreen
        }
    }
    
    private func displayName(for code: String) -> String {
        languageOptions.first(where: { $0.code == code })?.displayName
        ?? String(localized: "select_language")
    }
}






//#Preview {
//    SettingsLanguageView( SelectedLanguage: <#Binding<String>#>)
//}
