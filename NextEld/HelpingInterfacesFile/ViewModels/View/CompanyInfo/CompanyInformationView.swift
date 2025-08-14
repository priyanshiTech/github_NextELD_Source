//
//  CompanyInformationView.swift
//  NextEld
//
//  Created by priyanshi on 27/05/25.
//

import SwiftUI

struct CompanyInformationView: View {
    @EnvironmentObject var navmanager: NavigationManager
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
                    
                    InputField(label: "Driver Name", text: .constant("\(viewModel.companyInfo?.firstName ?? "") \(viewModel.companyInfo?.lastName ?? "")"))
                    InputField(label: "Driver Email", text: .constant(viewModel.companyInfo?.email ?? ""))
                    InputField(label: "Driver Phone", text: .constant("\(viewModel.companyInfo?.mobileNo ?? 0)"))
                    InputField(label: "Driver Licence", text: .constant(viewModel.companyInfo?.cdlNo ?? ""))
                    InputField(label: "Company Name", text: .constant(viewModel.companyInfo?.companyName ?? ""))
                    InputField(label: "Main Office Address", text: .constant(viewModel.companyInfo?.mainOfficeAddress ?? ""))
                    InputField(label: "Home Terminal Address", text: .constant(viewModel.companyInfo?.homeTerminalAddress ?? ""))
                }
                .padding()
            }
            .task {
                await viewModel.fetchEmployeeData(
                    employeeId: 17,
                    tokenNo: "60ea2fbd-4585-4c27-a47b-8ee8101ffb41"
                )
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
                .foregroundColor(.black)
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


