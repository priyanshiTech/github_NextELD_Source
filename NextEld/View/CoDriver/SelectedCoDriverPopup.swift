//
//  SelectedCoDriverPopup.swift
//  NextEld
//
//  Created by Priyanshi on 27/05/25.
//
import Foundation
import SwiftUI

struct SelectCoDriverPopup: View {
    @Binding var selectedCoDriver: String
    @Binding var isPresented: Bool
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
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(viewModel.certifyRecords, id: \.employeeId) { driver in
                            HStack {
                                Text("\(driver.firstName ?? "") \(driver.lastName ?? "")")
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: selectedCoDriver == "\(driver.firstName ?? "") \(driver.lastName ?? "")" ? "checkmark.circle.fill" : "checkmark.circle")
                                    .foregroundColor(Color(uiColor: .wine))
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedCoDriver = "\(driver.firstName ?? "") \(driver.lastName ?? "")"
                            }
                            Divider()
                        }
                    }
                    .padding(.horizontal)
                    Divider()
                }
            }

            Spacer()

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
        .onAppear {
            Task {
                await viewModel.fetchCertifyDataFromStoredSession()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
extension CertifyViewModel {
    func fetchCertifyDataFromStoredSession() async {
       
        let storedDriverId = 1
        let storedEmployeeId = UserDefaults.standard.integer(forKey: "employeeId")
        let storedToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
       
        await fetchCertifyData(driverId: storedDriverId, employeeID: storedEmployeeId, tokenNo: storedToken)
    }
}

