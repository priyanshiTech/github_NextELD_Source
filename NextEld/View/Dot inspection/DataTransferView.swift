//
//  DataTransferView.swift
//  NextEld
//
//  Created by priyanshi on 22/08/25.
//

import Foundation
import SwiftUI

struct DataTransferInspectionView: View {
    
    @StateObject private var viewModel = DataTransferViewModel(networkManager: NetworkManager())
    @EnvironmentObject var navmanager : NavigationManager
    
    
    var body: some View {
        ZStack {
            content
            
            if viewModel.isLoading {
                Color(uiColor:.black).opacity(0.2)
                    .ignoresSafeArea()
                ProgressView("Sending data...")
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
            }
            
            PopupContainer(isPresented: $viewModel.showDataTransferTypePicker) {
                VStack(spacing: 16) {
                    Text("Select Data Transfer Type")
                        .font(.headline)
                        .foregroundColor(Color(uiColor:.black))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ForEach(viewModel.dataTransferTypes, id: \.self) { type in
                        Button(action: {
                            viewModel.dataTransferType = type
                            viewModel.showDataTransferTypePicker = false
                        }) {
                            HStack {
                                Text(type)
                                    .foregroundColor(Color(uiColor:.black))
                                Spacer()
                                if viewModel.dataTransferType == type {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(Color(uiColor: .wine))
                                }
                            }
                            .padding()
                            // .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                }
            }
        }
        .alert(viewModel.alertMessage, isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) {
                if viewModel.errorMessage == nil {
                    navmanager.goBack()
                }
            }
        }
    }
    
    private var content: some View {
        VStack (spacing: 0) {
            ZStack(alignment: .topLeading) {
                Color(uiColor: .wine)
                    .edgesIgnoringSafeArea(.top)
                    .frame(height: 0)
            }
            
            // Header
            HStack {
                Button(action: {
                    navmanager.goBack()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                        .imageScale(.large)
                }
                Text("Road side inspection")
                    .font(.headline)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                Spacer()
                
            }
            
            .padding()
            .background(Color(uiColor: .wine).shadow(radius: 1))
            .frame(height: 40, alignment: .topLeading)
            
            // Information Banner
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.blue)
                Text("Send 8 daily logs via FMCSA data transfer")
                    .font(.subheadline)
                    .foregroundColor(Color(uiColor:.black))
            }
            
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    HStack {
                        // From Date Field
                        VStack(alignment: .leading, spacing: 8) {
                            Button(action: {
                                viewModel.showFromDatePicker = true
                            }) {
                                Text(viewModel.fromDateSelected ? viewModel.formatDate(viewModel.fromDate) : "From Date")
                                    .foregroundColor(viewModel.fromDateSelected ? Color(uiColor:.black) : Color(uiColor:.gray))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                    .background(Color(uiColor:.white))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(uiColor:.gray).opacity(0.3), lineWidth: 1)
                                    )
                            }
                        }
                        
                        // To Date Field
                        VStack(alignment: .leading, spacing: 8) {
                            Button(action: {
                                viewModel.showToDatePicker = true
                            }) {
                                Text(viewModel.toDateSelected ? viewModel.formatDate(viewModel.toDate) : "To Date")
                                    .foregroundColor(viewModel.toDateSelected ? Color(uiColor:.black) : Color(uiColor:.gray))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                    .background(Color(uiColor:.white))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(uiColor:.gray).opacity(0.3), lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Data Transfer Type Field
//                    VStack(alignment: .leading, spacing: 8) {
//                        Text("Data Transfer Type")
//                            .font(.caption)
//                            .foregroundColor(Color(uiColor:.black))
//                        Button(action: {
//                            viewModel.showDataTransferTypePicker = true
//                        }) {
//                            VStack(alignment: .leading, spacing: 4) {
//                                Text("Data Transfer Type")
//                                    .foregroundColor(Color(uiColor:.black))
//                                Text(viewModel.dataTransferType)
//                                    .font(.caption)
//                                    .foregroundColor(Color(uiColor:.gray))
//                            }
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .padding()
//                            .background(Color(uiColor:.white))
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 8)
//                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
//                            )
//                        }
//                    }
                //    .padding(.horizontal)
                    
                    // Email Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.caption)
                            .foregroundColor(Color(uiColor:.gray))
                        TextField("Enter Email", text: $viewModel.email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color(uiColor:.white))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal)
                    
                    // Comments Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Comments")
                            .font(.caption)
                            .foregroundColor(Color(uiColor:.gray))
                        TextField("Enter Comments", text: $viewModel.comments)
                            .padding()
                            .background(Color(uiColor:.white))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal)
                    
                    // Reminder text
                    Text("Please remember this will send 8 days of daily logs via FMCSA Data Transfer.")
                        .font(.footnote)
                        .foregroundColor(Color(uiColor:.gray))
                        .padding(.horizontal)
                        .padding(.top, 10)
                }
                .padding(.vertical, 20)
            }
            
            // Send Button
            Button(action: {
                submitDataTransfer()
            }) {
                Text("Send Data Transfer")
                    .font(.headline)
                    .foregroundColor(Color(uiColor:.white))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(uiColor: .wine))
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .navigationBarBackButtonHidden()
        .background(Color(.systemBackground))
        .sheet(isPresented: $viewModel.showFromDatePicker) {
            DatePickerPopup(
                selectedDate: $viewModel.fromDate,
                isPresented: $viewModel.showFromDatePicker
            ) {
                viewModel.fromDateSelected = true
            }
        }
        .sheet(isPresented: $viewModel.showToDatePicker) {
            DatePickerPopup(
                selectedDate: $viewModel.toDate,
                isPresented: $viewModel.showToDatePicker
            ) {
                viewModel.toDateSelected = true
            }
        }
    }
    
    private func submitDataTransfer() {
        guard viewModel.fromDateSelected else {
            presentAlert("Please select From Date")
            return
        }
        guard viewModel.toDateSelected else {
            presentAlert("Please select To Date")
            return
        }
        let trimmedEmail = viewModel.email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedEmail.isEmpty else {
            presentAlert("Please enter Email")
            return
        }
        guard isValidEmail(trimmedEmail) else {
            presentAlert("Please enter a valid Email")
            return
        }
        
        Task {
            let apiFromDate = viewModel.apiDateString(for: viewModel.fromDate, isStartOfDay: true)
            let apiToDate = viewModel.apiDateString(for: viewModel.toDate, isStartOfDay: false)
            await viewModel.transferData(email: trimmedEmail, fromDate: apiFromDate, toDate: apiToDate)
            if let error = viewModel.errorMessage {
                presentAlert(error)
            } else if let signature = viewModel.signature {
                presentAlert("Data transfer request sent successfully.\nSignature:\n\(signature)")
            } else {
                presentAlert("Data transfer request sent successfully.")
            }
        }
    }
    
    //    private func presentAlert(_ message: String) {
    //        if viewModel.errorMessage == nil {
    //            viewModel.alertMessage = "Data Sent Successfully"
    //        } else {
    //            viewModel.alertMessage = message
    //        }
    //        viewModel.showAlert = true
    //    }
    
    private func presentAlert(_ message: String) {
        viewModel.alertMessage = message
        viewModel.showAlert = true
    }
    
}

#Preview {
    DataTransferInspectionView()
}
