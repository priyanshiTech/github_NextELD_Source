//
//  CompanyInformationView.swift
//  NextEld
//
//  Created by priyanshi on 27/05/25.
//

import SwiftUI

struct CompanyInformationView: View {
    
    @EnvironmentObject var navmanager: NavigationManager
    @EnvironmentObject var appRootManager: AppRootManager
    @StateObject private var viewModel = EmployeeViewModel(networkManager: NetworkManager.shared)
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Color(uiColor: .wine)
                .edgesIgnoringSafeArea(.top)
                .frame(height: 1)
            
            HStack {
                Button(action: { navmanager.goBack() }) {
                    Image(systemName: "arrow.left")
                        .bold()
                        .foregroundColor(.white)
                        .imageScale(.large)
                }
                
                Text("Company Information")
                    .font(.headline)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            .padding()
            .background(Color(uiColor: .wine).shadow(radius: 1))
            
            UniversalScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    
                    InputField(label: "Driver Name", text: .constant("\(viewModel.companyInfo?.firstName ?? "")\(viewModel.companyInfo?.lastName ?? "")"))
                    InputField(label: "Driver Email", text: .constant(viewModel.companyInfo?.email ?? ""))
                    InputField(label: "Driver Phone", text: .constant("\(viewModel.companyInfo?.mobileNo ?? 0)"))
                    InputField(label: "Driver Licence", text: .constant(viewModel.companyInfo?.cdlNo ?? ""))
                    InputField(label: "Company Name", text: .constant(viewModel.companyInfo?.companyName ?? ""))
                    InputField(label: "Main Office Address", text: .constant(viewModel.companyInfo?.mainOfficeAddress ?? ""))
                    InputField(label: "Home Terminal Address", text: .constant(viewModel.companyInfo?.homeTerminalAddress ?? ""))
                    InputField(label: "Time Zone", text: .constant(viewModel.companyInfo?.timeZone ?? ""))
                    InputField(label: "Language", text: .constant(viewModel.companyInfo?.languageName ?? ""))
                    
                }
                .padding()
            }
            .task {
                viewModel.appRootManager = appRootManager
                let success = await viewModel.fetchEmployeeData(
                    employeeId: AppStorageHandler.shared.driverId ?? 0,
                    tokenNo: AppStorageHandler.shared.authToken ?? "",
                        //"60ea2fbd-4585-4c27-a47b-8ee8101ffb41"
                )
                if viewModel.isSessionExpired {
                             // print(" Session expired detected - staying on SessionExpireUIView")
                             return // Don't proceed with any further processing
                         }
                if !success, let error = viewModel.errorMessage {
                    // print(" Employee info error: \(error)")
                }

            }
        }
        .navigationBarBackButtonHidden()
    }
}
struct InputField: View {
    var label: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.callout)
                .foregroundColor(Color(uiColor:.black))
                .bold()
            TextField("", text: $text)
                .padding(10)
                .frame(height:50)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color(uiColor: .wine), lineWidth: 2)
                )
        }
    }
}


//#Preview {
//    CompanyInformationView()
//}


