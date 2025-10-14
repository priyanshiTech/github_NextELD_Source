//
//  CoDriverLogin.swift
//  NextEld
//
//  Created by priyanshi on 27/05/25.
//
import SwiftUI

struct CoDriverLogin: View {
    @State private var selectionCoDriver: String? = nil
    @State private var selectedCoDriverId: Int? = nil

    @State private var showDriver = false
    @EnvironmentObject var navmanager: NavigationManager
    @State private var showAlert = false
    @EnvironmentObject var dutyManager: DutyStatusManager   //  shared object
    @State private var selectedCoDriverEmail: String = "" // Hidden Email

    var tittle: String = "Co-Driver Log-in"
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Color(uiColor: .wine)
                    .edgesIgnoringSafeArea(.top)
                    .frame(height: 1)
                
                // Header
                HStack {
                    Button(action: { navmanager.goBack() }) {
                        Image(systemName: "arrow.left")
                            .bold()
                            .foregroundColor(.white)
                            .imageScale(.large)
                    }
                    Text(tittle)
                        .font(.headline)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                    Spacer()
                }
                .padding()
                .background(Color(uiColor: .wine).shadow(radius: 1))

                // Title
                Text("Select Co-Driver")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding()

                // Co-Driver selector card
                CardContainer {
                    Button(action: { showDriver = true }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Co-Driver")
                                    .font(.headline)
                                    .foregroundColor(.black)

                                // Show selected value
                                //Text((((selectionCoDriver?.isEmpty) != nil) ? "None" : selectionCoDriver) ?? "")
                                Text(selectionCoDriver ?? "None")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .lineLimit(1)

                            }
                            Spacer()
                            Image("pencil").foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding()
                Spacer()
                // Submit button
                Button(action: {
                                   if dutyManager.dutyStatus == DriverStatusConstants.offDuty {
                                       print(" Going to NewDriverLogin with email:", selectedCoDriverEmail)
                                    //   navmanager.navigate(to: .loginFlow(.newDriverLogin(title: tittle, email: selectedCoDriverEmail)))

                                       
                                   } else {
                                       showAlert = true
                                   }
                               }) {
                                   Text("Submit")
                                       .font(.headline)
                                       .foregroundColor(.white)
                                       .frame(maxWidth: .infinity)
                                       .padding()
                                       .background(Color(uiColor: .wine))
                                       .cornerRadius(10)
                               }
                               .padding(.horizontal)
                               .disabled(((selectionCoDriver?.isEmpty) != nil))
                               .alert("Switch to Off-Duty before Co-Driver can login.", isPresented: $showAlert) {
                                   Button("OK", role: .cancel) { }
                               }
            }
            .blur(radius: showDriver ? 1 : 0) // blur background when popup is open

            //  Popup overlay (only shows when showDriver == true)
            if showDriver {
                Color.black.opacity(0.4) // dim background
                    .ignoresSafeArea()
                    .onTapGesture { showDriver = false } // tap outside to close

                SelectCoDriverPopup(
                    selectedCoDriver: $selectionCoDriver, selectedCodriverID: $selectedCoDriverId,
                    isPresented: $showDriver, selectedCoDriverEmail: $selectedCoDriverEmail
                )

            }
        }
        .animation(.easeInOut, value: showDriver)
        .navigationBarBackButtonHidden()
    }
}


#Preview {
    CoDriverLogin()
}





