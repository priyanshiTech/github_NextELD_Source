//
//  SupportView.swift
//  NextEld
//
//  Created by priyanshi   on 30/05/25.
//



import SwiftUI

struct SupportView: View {
    @State private var queryText: String = ""
    @State private var showAlert = false
    private let phoneNumber = "+919876543210"
    @EnvironmentObject var navmanager: NavigationManager
    @StateObject private var viewModel = SupportViewModel(networkManager: NetworkManager())
    
    var body: some View {
        VStack {
            // Custom nav bar
            HStack {
                Button(action: { navmanager.goBack() }) {
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
                VStack(spacing: 16) {
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
                        if queryText.isEmpty {
                            Text("Type your query here")
                                .foregroundColor(.gray)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 12)
                        }
                        
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
                        Task {
                            await submit()
                        }
                    }) {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                            }
                            Text("Submit")
                                .bold()
                        }
                        .frame(maxWidth: 140)
                        .padding()
                        .background(Color(uiColor: .wine))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .disabled(viewModel.isLoading || queryText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    
                    Spacer(minLength: 20)
                }
                .padding()
            }
            
            // Bottom contact section
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
                    
                    Text(phoneNumber)
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
            //MARK: - To Call Connect in
            .onTapGesture {
                let cleanNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
                if let url = URL(string: "tel://\(cleanNumber)"),
                   UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                } else {
                    print("📞 Call not supported on this device")
                }
            }

        }
        .navigationBarBackButtonHidden()
        .background(Color.white.edgesIgnoringSafeArea(.all))
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(viewModel.successMessage != nil ? "Success" : "Error"),
                message: Text(viewModel.successMessage ?? viewModel.errorMessage ?? "Unknown error"),
                dismissButton: .default(Text("OK"), action: {
                    // reset messages when alert dismissed
                    viewModel.successMessage = nil
                    viewModel.errorMessage = nil
                })
            )
        }
    }
    
    // MARK: - Actions
    private func submit() async {
        await viewModel.sendSupportMessage(userMessage: queryText)
          //show alert if success or error
        if viewModel.successMessage != nil || viewModel.errorMessage != nil {
            showAlert = true
        }
        if viewModel.successMessage != nil {
            // clear input on success
            queryText = ""
        }
    }
}

#Preview {
    SupportView()
        .environmentObject(NavigationManager()) // provide stub nav manager for preview
}











































