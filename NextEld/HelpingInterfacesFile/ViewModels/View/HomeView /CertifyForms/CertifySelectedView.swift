//
//  CertifySelectedView.swift
//  NextEld
//
//  Created by priyanshi   on 19/05/25.
//
import SwiftUI
import Foundation

struct CertifySelectedView: View {
    
    // MARK: - States
    @State private var selectedTab = "Form"
    @State private var trailer = "None"
    @State private var shippingDocs = "docwriting"
    @State private var coDriver = "none"
    @State private var selectedCoDriver: String = ""

    @State private var SelectedTraller: String? = nil
    @State private var showSignaturePad = false
    @State private var signaturePath = Path()
    @State private var showCoDriverPopup = false
    @Binding var vehiclesc: String
    @EnvironmentObject var navManager: NavigationManager
    @EnvironmentObject var trailerVM: TrailerViewModel
    @EnvironmentObject var shippingVM: ShippingDocViewModel
    var title: String
    
    var body: some View {
        ZStack { // Root ZStack to overlay popup
            VStack(spacing: 0) {
                
                // MARK: - Top Bar
                ZStack(alignment: .topLeading){
                    Color(UIColor.wine)
                        .edgesIgnoringSafeArea(.top)
                        .frame(height: 30)
                }
                
                ZStack(alignment: .top) {
                    Color(UIColor.wine)
                        .frame(height: 50)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
                    
                    HStack {
                        Button(action: { navManager.goBack() }) {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white)
                                .imageScale(.large)
                        }.padding()
                        
                        Text(title)
                            .font(.headline)
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        CustomIconButton(
                            iconName: "alarm_icon",
                            title: "Event",
                            action: { navManager.navigate(to: .RecapHours(tittle: "Hours Recap")) }
                        )
                        .padding()
                    }
                }
                
                Spacer(minLength: 20)
                
                // MARK: - Tabs
                HStack(spacing: 0) {
                    Button("Form") {
                        selectedTab = "Form"
                        showSignaturePad = false
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedTab == "Form" ? Color(UIColor.wine) : Color.white.opacity(0.2))
                    .foregroundColor(selectedTab == "Form" ? .white : .black)
                    
                    Button("Certify") {
                        selectedTab = "Certify"
                        showSignaturePad = true
                        showCoDriverPopup = false // hide popup
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedTab == "Certify" ? Color(UIColor.wine) : Color.white.opacity(0.2))
                    .foregroundColor(selectedTab == "Certify" ? .white : .black)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .cornerRadius(5)
                .padding(.horizontal)
                
                Spacer()
                
                // MARK: - Form Tab Content
                if selectedTab == "Form" {
                    VStack(spacing: 10) {
                        FormField(label: "Driver", value: .constant("Mark Joseph ID - 17"), editable: false)
                        FormField(
                            label: "Vehicle",
                            value: $vehiclesc , // Direct binding
                            editable: true
                        ) {
                            navManager.navigate(to: .ADDVehicle)
                        }
                        
                        FormField(
                            label: "Trailer",
                            value: Binding(
                                get: { trailerVM.trailers.last ?? "None" },
                                set: { newValue in
                                    if trailerVM.trailers.isEmpty {
                                        trailerVM.trailers.append(newValue)
                                    } else {
                                        trailerVM.trailers[trailerVM.trailers.count - 1] = newValue
                                    }
                                }
                            ),
                            editable: true
                        ) {
                            navManager.navigate(to: .trailerScreen)
                        }
                        
                        
                        FormField(
                            label: "Shipping Docs",
                            value: Binding(
                                get: { shippingVM.ShippingDoc.last ?? "None" },
                                set: { newValue in
                                    if shippingVM.ShippingDoc.isEmpty {
                                        shippingVM.ShippingDoc.append(newValue)
                                    } else {
                                        shippingVM.ShippingDoc[shippingVM.ShippingDoc.count - 1] = newValue
                                    }
                                }
                            ),
                            editable: true
                        ) {
                            navManager.navigate(to: .ShippingDocment) // shipping screen
                        }
                        
                        FormField(
                            label: "Co-Driver",
                            value: Binding(
                                get: { selectedCoDriver ?? coDriver },
                                set: { selectedCoDriver = $0 }
                            ),
                            editable: true
                        ) {
                            showCoDriverPopup = true
                        }
                        Button(action: {
                            let record = CertifyRecord(
                                    userID: "17", // Or get from your logged-in user data
                                    userName: "Mark Joseph",
                                    startTime: DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short),
                                    date: DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none),
                                    shift: "Day", // Or dynamically from your shift logic
                                    selectedVehicle: vehiclesc,
                                    selectedTrailer: trailerVM.trailers.last ?? "None",
                                    selectedShippingDoc: shippingVM.ShippingDoc.last ?? "None",
                                    selectedCoDriver: selectedCoDriver ?? "None",
                                    vehicleID: "V123", // Replace with actual vehicle ID if available
                                    coDriverID: "C123" // Replace with actual co-driver ID if available
                                )
                                
                                CertifyDatabaseManager.shared.insertRecord(record)
                                print("@@@@@@@@@@@@@@@@@@ Record saved successfully!")
                                navManager.navigate(to: AppRoute.DatabaseCertifyView)
                                
                        }) {
                            Text("Save")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(uiColor: .wine))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                        Spacer()
                    }
                    .padding(.top)
                }
                
                // MARK: - Signature Tab Content
                if selectedTab == "Certify" {
                    SignatureCertifyView(signaturePath: $signaturePath)
                        .transition(.slide)
                }
                
                Spacer()
            }
            
            .navigationBarBackButtonHidden()
            .edgesIgnoringSafeArea(.top)
            
            // MARK: - CoDriver Popup Overlay (Centered)
            if showCoDriverPopup && selectedTab == "Form" {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture { showCoDriverPopup = false }
                
                SelectCoDriverPopup(
                    selectedCoDriver: $selectedCoDriver,
                    isPresented: $showCoDriverPopup
                )

                .frame(width: 300, height: 400)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 8)
                .position(
                    x: UIScreen.main.bounds.width / 2,
                    y: UIScreen.main.bounds.height / 2
                )
                .zIndex(1)
            }
        }
    }
}

// MARK: - FormField View
struct FormField: View {
    let label: String
    @Binding var value: String
    var editable: Bool = true
    var onTap: (() -> Void)? = nil
    
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
                Button(action: { onTap?() }) {
                    Image("pencil")
                        .foregroundColor(.black)
                        .bold()
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .contentShape(Rectangle())
        .onTapGesture { onTap?() }
        Divider()
    }
}
//
//// MARK: - Preview
//#Preview {
//    CertifySelectedView(title: "Certify Form")
//        .environmentObject(NavigationManager())
//}
//
