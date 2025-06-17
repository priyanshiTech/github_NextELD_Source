//
//  CertifySelectedView.swift
//  NextEld
//
//  Created by Inurum   on 19/05/25.
//

import SwiftUI

struct CertifySelectedView: View {
    
    
    @State private var selectedTab = "Form"
    @State private var vehicle = "1894"
    @State private var trailer = "None"
    @State private var shippingDocs = "de"
    @State private var coDriver = "None"
    @EnvironmentObject var navManager: NavigationManager
    //MARK: add a signature pad variable
    @State private var showSignaturePad = false
    @State private var signaturePath = Path()
    
    var title: String
    var body: some View {
        
        
        VStack(spacing: 0) {
            ZStack(alignment: .topLeading){
                Color.blue
                    .edgesIgnoringSafeArea(.top)
                    .frame(height:50)
            }
            
            ZStack(alignment: .top) {
                Color.blue
                    .frame(height: 50)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
                HStack {
                    Button(action: {
                        navManager.goBack()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .imageScale(.large)
                    }
                    .padding()
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                    Spacer()
                    
                    HStack() {
                        CustomIconButton(
                            iconName: "alarm_icon",
                            title: "Event",
                            action: {
                                navManager.navigate(to: .RecapHours(tittle: "Hours Recap"))
                            }
                        )
                    }
                    .padding()
                }
            }
            Spacer(minLength: 20)
            HStack(spacing: 0) {
                    Button("Form") {
                        selectedTab = "Form"
                        showSignaturePad = false
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedTab == "Form" ? Color.blue : Color.white.opacity(0.2))
                    .foregroundColor(selectedTab == "Form" ? .white : .black)

                    Button("Certify") {
                            selectedTab = "Certify"
                           // showSignaturePad = true
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedTab == "Certify" ? Color.blue : Color.white.opacity(0.2))
                    .foregroundColor(selectedTab == "Certify" ? .white : .black)
                }
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
                .cornerRadius(5)
                .padding(.horizontal)
            Spacer()
            
            if selectedTab == "Form"{
                
                VStack{
                    FormField(label: "Driver", value: "Mark Joseph ID - 17", editable: false)
                    FormField(label: "Vehicle", value: vehicle)
                    FormField(label: "Trailer", value: trailer)
                    FormField(label: "Shipping Docs", value: shippingDocs)
                    FormField(label: "Co-Driver", value: coDriver)
                    // Save Button
                    Button(action: {

                    }) {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
                    Spacer()
                }
            }
            //MARK: -  show driver signature view
            if selectedTab == "Certify" {
                SignatureCertifyView(signaturePath: $signaturePath)
                    .transition(.slide)
            }
            Spacer()
            .padding(.top)
            
        }.navigationBarBackButtonHidden()
        .edgesIgnoringSafeArea(.top)
    }
}

        struct FormField: View {
            let label: String
            @State var value: String
            var editable: Bool = true

            var body: some View {
                HStack {
                    VStack(alignment: .leading) {
                        Text(label)
                            .bold()
                           
                            .foregroundColor(.black)
                        Text(value)
                            .foregroundColor(.black)
                    }
                    Spacer()
                    if editable {
                        Button(action: {
                            // Edit action
                        }) {
                            Image("pencil")
                                .foregroundColor(.black)
                                .bold()
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                Divider()
            }
        }

     




#Preview {
    CertifySelectedView(title: "date")
}
