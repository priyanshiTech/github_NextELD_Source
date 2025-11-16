//
//  DisclamerView.swift
//  NextEld
//
//  Created by priyanshi  on 15/11/25.
//

import SwiftUI

struct DisclamerView: View {
    
    @EnvironmentObject var navmanager: NavigationManager
    @EnvironmentObject var appRootManager: AppRootManager
    
    @StateObject private var viewModel = DisclamerViewModel(networkManager: NetworkManager())
    @AppStorage("driverId") private var driverId: Int = 0
    
    @State private var isLoading = true
    @State private var isAccepted = false
    @State private var showError = false
    
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
                Text(AppConstants.Disclaimer)
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
            
            // HTML View
            WebView(url: localHTML(), isLoading: $isLoading)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Bottom Section
            bottomSection
        }
        .overlay(loadingOverlay)
        .navigationBarBackButtonHidden()
    }
    
    
    // MARK: - Load Local HTML File
    func localHTML() -> URL {
        // Try both possible file names
        if let path = Bundle.main.path(forResource: "eld_disclaimer 1", ofType: "html") {
            return URL(fileURLWithPath: path)
        } else if let path = Bundle.main.path(forResource: "eld_disclaimer", ofType: "html") {
            return URL(fileURLWithPath: path)
        } else {
            // Return a dummy URL for preview to work
            return URL(string: "https://example.com")!
        }
    }
    
    
    // MARK: - Bottom Accept Section
    var bottomSection: some View {
        VStack(spacing: 12) {
            
            HStack {
                Button(action: {
                    isAccepted.toggle()
                }) {
                    Image(systemName: isAccepted ? "checkmark.circle.fill" : "circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(isAccepted ? Color(uiColor: .wine) : .gray)
                }
                .buttonStyle(PlainButtonStyle())
                
                Text("I agree to Disclaimer & Terms")
                    .font(.subheadline)
                Spacer()
            }
            .padding(.horizontal)
            
            Button(action: {
                Task {
                    await viewModel.Disclamerrecord(driverId: driverId)
                    if viewModel.errorMessage == nil {
                        // Check if API response is successful
                        if let response = viewModel.Disclamerdata, response.status.lowercased() == "success" {
                            // API call successful, navigate back
                            let disclaimer = AppStorageHandler.shared.disclaimerRead
                            appRootManager.currentRoot = .scanner()
                           // navmanager.goBack()
                        } else {
                            // API returned error status
                            showError = true
                        }
                    } else {
                        // Network or other error
                        showError = true
                    }
                }
            }) {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Accept & Continue")
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isAccepted && !viewModel.isLoading ? Color(uiColor: .wine) : Color.gray)
            .cornerRadius(12)
            .disabled(!isAccepted || viewModel.isLoading)
            .padding(.horizontal)
            .padding(.bottom, 10)
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "Failed to accept disclaimer")
            }
        }
        .background(Color.white)
    }
    
    
    // MARK: - Loading Overlay
    var loadingOverlay: some View {
        Group {
            if isLoading {
                ZStack {
                    Color.black.opacity(0.2).ignoresSafeArea()
                    ProgressView("Loading...")
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                }
            }
        }
    }
}


