//
//  CompanyInformationView.swift
//  NextEld
//
//  Created by Inurum   on 27/05/25.
//

import SwiftUI


struct CompanyInformationView: View {
    

    @State private var driverName = "Mark Josheph"
    @State private var driverEmail = "amanjosheph@gmail.com"
    @State private var driverPhone = "1234567890"
    @State private var driverLicence = "464465"
    @State private var companyName = "Eld Solutions - India"
    @State private var mainOfficeAddress = "Main Terminal 1"
    @State private var homeTerminalAddress = "Main Terminal 1"
    @EnvironmentObject var navmanager: NavigationManager

    var body: some View {
        VStack(spacing: 0) {
            // Top Blue Bar
            
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
                
                Text("Company Information")
                    .font(.headline)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            .padding()
            .background(Color.blue.shadow(radius: 1))
            
            UniversalScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    
                    InputField(label: "Driver Name", text: $driverName)
                    InputField(label: "Driver Email", text: $driverEmail)
                    InputField(label: "Driver Phone", text: $driverPhone)
                    InputField(label: "Driver Licence", text: $driverLicence)
                    InputField(label: "Company Name", text: $companyName)
                    InputField(label: "Main Office Address", text: $mainOfficeAddress)
                    InputField(label: "Home Terminal Address", text: $homeTerminalAddress)

                }
                .padding()
            }
        }.navigationBarBackButtonHidden()
    }
}

// Reusable Field View
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
                        .stroke(Color.blue, lineWidth: 2)
                )
        }
    }
}


//#Preview {
//    CompanyInformationView()
//}
