//
//  SelectedCoDriverPopup.swift
//  NextEld
//
//  Created by Priyanshi on 27/05/25.
//
import Foundation
import SwiftUI
extension CertifyViewModel {
    func fetchCertifyDataFromStoredSession() async {
       
        let storedDriverId = 1
        let storedEmployeeId = UserDefaults.standard.integer(forKey: "employeeId")
        let storedToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
       
        await fetchCertifyData(driverId: storedDriverId, employeeID: storedEmployeeId, tokenNo: storedToken)
    }
}

struct SelectCoDriverPopup: View {
    @Binding var selectedCoDriver: String
    @Binding var isPresented: Bool
    @Binding var selectedCoDriverEmail: String

    @StateObject private var viewModel = CertifyViewModel(networkManager: NetworkManager())

    var body: some View {
        VStack(spacing: 16) {
            Text("Select Co-Driver")
                .font(.headline)
                .padding(.top)

            Divider()

            if viewModel.isLoading {
                ProgressView("Loading co-drivers...")
                    .padding()
            } else if let error = viewModel.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .padding()
            } else {
                UniversalScrollView {
                    VStack(spacing: 12) {
                        ForEach(viewModel.certifyRecords, id: \.employeeId) { driver in
                            let fullName = "\(driver.firstName ?? "") \(driver.lastName ?? "")"
                            
                            HStack {
                                Text(fullName)
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: selectedCoDriver == fullName
                                      ? "checkmark.circle.fill"
                                      : "checkmark.circle")
                                    .foregroundColor(Color(uiColor: .wine))
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedCoDriver = fullName
                                selectedCoDriverEmail = driver.email ?? ""
                                print("Selected Email: \(driver.email ?? "nil")")
                            }
                            
                            Divider()
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(maxHeight: 250)
            }

            Button(action: {
                isPresented = false
            }) {
                Text("Add Co-Driver")
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
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 10)
        .padding(.horizontal, 24)
        .onAppear {
            Task {
                await viewModel.fetchCertifyDataFromStoredSession()
            }
        }
    }
}
