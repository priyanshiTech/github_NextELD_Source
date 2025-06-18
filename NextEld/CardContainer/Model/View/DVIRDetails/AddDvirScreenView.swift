//
//  AddDvirScreenView.swift
//  NextEld
//
//  Created by Priyanshi on 21/05/25.
//

import SwiftUI

struct AddDvirScreenView: View  {
    
    @EnvironmentObject var navmanager: NavigationManager
    @State private var notesText: String = ""
    @State private var showSignaturePopup = false
    @State private var signaturePath = Path()
  //MARK: -  to show a selected data @binding use
    @Binding var selectedVehicle: String
    @State private var truckDefectSelection: String? = nil
    @State private var trailerDefectSelection: String? = nil

    @State private var Showpopup: Bool = false
    @State private var selectedTab = ""

    var body: some View {
        ZStack {
            VStack(spacing: 0) {

                // MARK: - Top Strip
                ZStack(alignment: .topLeading) {
                    Color(UIColor.colorPrimary)
                        .edgesIgnoringSafeArea(.top)
                        .frame(height: 10)
                }

                // MARK: - Header
                ZStack(alignment: .top) {
                    Color.white
                        .frame(height: 52)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)

                    HStack {
                        Button(action: {
                            navmanager.goBack()
                        }) {
                            Image(systemName: "arrow.left")
                                .bold()
                                .foregroundColor(.white)
                                .imageScale(.large)
                        }

                        Text("Add Dvir")
                            .font(.headline)
                            .foregroundColor(.white)
                            .fontWeight(.semibold)

                        Spacer()
                    }
                    .padding()
                    .background(Color.blue.shadow(radius: 1))
                    .frame(height: 40, alignment: .topLeading)
                }

                // MARK: - Main Content Scroll
                UniversalScrollView {
                    VStack(spacing: 8) {

                        // Driver Info
                        CardContainer {
                            VStack(alignment: .leading, spacing: 15) {
                                DvirField(label: "Driver", value: "MARK Joseph ELD")
                                DvirField(label: "Time", value: "12:16 PM")
                                DvirField(label: "Date", value: "2025-05-21")
                                DvirField(label: "Odometer", value: "0")
                                DvirField(label: "Company", value: "Eld Solutions - India")
                                DvirField(label: "Location", value: "349, Vijay Nagar, Scheme 54 PU4, Indore, Madhya Pradesh 452010, India")
                            }
                        }

                        // Vehicle
                        CardContainer {
                            Button(action: {
                                navmanager.navigate(to: .ADDVehicle)
                               // showVehicleSelection = true
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Vehicle")
                                            .font(.headline)
                                            .foregroundColor(.black)

                             //MARK: -  to show a selected data
                                        Text("\(selectedVehicle)")
                                           
                                            .font(.headline)
                                            .foregroundColor(.black)
                                      //  print(selectedVehicle)
                                    }

                                    Spacer()
                                    Image("pencil").foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.white)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }

                        // Trailer
                        CardContainer {
                            Button(action: {
                                navmanager.goBack()
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Trailer")
                                            .font(.headline)
                                            .foregroundColor(.black)

                                        Text("None")
                                            .font(.headline)
                                            .foregroundColor(.black)
                                    }

                                    Spacer()
                                    Image("pencil").foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.white)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }

                        // Truck/Trailer Defects
                        CardContainer {
                            VStack(alignment: .center, spacing: 16) {
                                Text("Truck 1894")
                                    .font(.headline)

                                VStack(spacing: 10) {
                                    Button(action: {
                                        truckDefectSelection = "no"
                                    }) {
                                        Text("No Defects")
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(truckDefectSelection == "no" ? Color.blue : Color.white)
                                            .foregroundColor(truckDefectSelection == "no" ? .white : .blue)
                                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 1))
                                            .cornerRadius(8)
                                    }

                                    Button(action: {
                                        truckDefectSelection = "yes"
                                        Showpopup = true
                                    }) {
                                        Text("Has Defects")
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(truckDefectSelection == "yes" ? Color.blue : Color.white)
                                            .foregroundColor(truckDefectSelection == "yes" ? .white : .blue)
                                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 1))
                                            .cornerRadius(8)
                                    }
                                }

                                Text("Trailer None")
                                    .font(.headline)

                                VStack(spacing: 10) {
                                    Button(action: {
                                        trailerDefectSelection = "no"
                                    }) {
                                        Text("No Defects")
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(trailerDefectSelection == "no" ? Color.blue : Color.white)
                                            .foregroundColor(trailerDefectSelection == "no" ? .white : .blue)
                                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 1))
                                            .cornerRadius(8)
                                    }

                                    Button(action: {
                                        trailerDefectSelection = "yes"
                                        Showpopup = true
                                    }) {
                                        Text("Has Defects")
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(trailerDefectSelection == "yes" ? Color.blue : Color.white)
                                            .foregroundColor(trailerDefectSelection == "yes" ? .white : .blue)
                                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 1))
                                            .cornerRadius(8)
                                    }
                                }
                            }
                        }

                        // Notes
                        CardContainer {
                            Text("Notes")
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding()

                            ZStack(alignment: .topLeading) {
                                TextEditor(text: $notesText)
                                    .frame(height: 200)
                                    .padding(2)
                                    .background(Color(UIColor.systemGray6))
                                    .cornerRadius(10)

                                if notesText.isEmpty {
                                    Text("Write note here...")
                                        .foregroundColor(.gray)
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 12)
                                }
                            }

                            HStack {
                                Button(action: {
                                    print("Vehicle Condition Added")
                                }) {
                                    Text("Vehicle Condition")
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                        .background(Color.clear)
                                }
                            }
                        }

                        // Signature Button
                        CardContainer {
                            Button(action: {
                                selectedTab = "Driver Signature"
                                showSignaturePopup = true
                            }) {
                                Text("Add Driver Signature")
                                    .foregroundColor(.black)
                                    .font(.headline)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .cornerRadius(10)
                            }
                            .frame(width: 350, height: 80)
                        }
//                        .padding()

                        // Add DVIR Button
                        HStack {
                            Button(action: {
                                print("Add Dvir tapped")
                            }) {
                                Text("Add Dvir")
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 10)
                                    .frame(width: 350, height: 50)
                                    .foregroundColor(.white)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                    .bold()
                            }
                        }

                    }
                    .padding(.horizontal, 5)
                }
                .navigationBarBackButtonHidden()
            }

            // MARK: - Signature Popup Overlay
            if showSignaturePopup {
                PopupContainer(isPresented: $showSignaturePopup) {
                    SignatureCertifyView(signaturePath: $signaturePath)
                }

            }

            // MARK: - Defect Popup Overlay
            if Showpopup {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .zIndex(1)

                DefectPopupView(isPresented: $Showpopup)
                    .frame(width: 300, height: 400)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 10)
                    .zIndex(2)
                    .transition(.scale)
            }
        }
        .animation(.easeInOut, value: showSignaturePopup)
        .animation(.easeInOut, value: Showpopup)
    }
}

//
//#Preview {
//    AddDvirScreenView()
//        .environmentObject(NavigationManager())
//}
//
