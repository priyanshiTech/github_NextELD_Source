//
//  RulesView.swift
//  NextEld
//
//  Created by priyanshi   on 27/05/25.
//

import SwiftUI

struct RulesView: View {
    
    @EnvironmentObject var navmanager: NavigationManager
    @StateObject private var viewModel = EmployeeRulesViewModel(
        networkManager: NetworkManager()
    )
    @State private var isShortHaulEnabled = false
    
    var body: some View {
        VStack(spacing:0){
            
            // Top bar
            Color(uiColor: .wine)
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
                
                Text("Rules")
                    .font(.headline)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            .padding()
            .background(Color(uiColor: .wine).shadow(radius: 1))
            
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .padding()
                Spacer()
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
                Spacer()
            } else if let employee = viewModel.employees.first {
                
                VStack(spacing:15){
                    
                    HStack {
                        Text("Cycle Rule")
                        Spacer()
                        Text(employee.cycleUsaName.first ?? "-")
                            .foregroundColor(.gray)
                    }
                    Divider().background(Color.gray)
                    
                    HStack {
                        Text("Cargo Type")
                        Spacer()
                        Text(employee.cargoTypeName.first ?? "-")
                            .foregroundColor(.gray)
                    }
                    Divider().background(Color.gray)
                    
                    HStack {
                        Text("Restart")
                        Spacer()
                        Text(employee.restartName.first ?? "-")
                            .foregroundColor(.gray)
                    }
                    Divider().background(Color.gray)
                    
                    HStack {
                        Text("Rest Break")
                        Spacer()
                        Text(employee.restBreakName.first ?? "-")
                            .foregroundColor(.gray)
                    }
                    Divider().background(Color.gray)
                    
                    Toggle(isOn: $isShortHaulEnabled) {
                        Text("16Hr Short Haul Exception")
                    }
                    .onAppear {
                        isShortHaulEnabled = (employee.shortHaulException.lowercased() == "active")
                    }
                    .tint(Color(uiColor: .wine))
                    Divider().background(Color.gray)
                    
                    HStack {
                        Text("Personal Conveyance")
                        Spacer()
                        Text(employee.personalUse.capitalized)
                            .foregroundColor(.gray)
                    }
                    Divider().background(Color.gray)
                    
                    HStack {
                        Text("Yard Moves")
                        Spacer()
                        Text(employee.yardMoves.capitalized)
                            .foregroundColor(.gray)
                    }
                    Divider().background(Color.gray)
                    
                    HStack {
                        Text("Unlimited Trailers")
                        Spacer()
                        Text(employee.unlimitedTrailers.capitalized)
                            .foregroundColor(.gray)
                    }
                    Divider().background(Color.gray)
                    
                    HStack {
                        Text("Unlimited Shipping Documents")
                        Spacer()
                        Text(employee.unlimitedShippingDocs.capitalized)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
            }
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .task {
            // API call when screen appears
            await viewModel.fetchEmployeeRules(employeeId: 30, clientId: 3)
        }
    }
}

#Preview {
    RulesView()
}

























//import SwiftUI
//
//struct RulesView: View {
//    
//    @EnvironmentObject var navmanager: NavigationManager
//    @State private var isShortHaulEnabled = false
//
//    var body: some View {
//        
//        VStack(spacing:0){
//            
//            
//            Color(uiColor: .wine)
//                .edgesIgnoringSafeArea(.top)
//                .frame(height: 1)
//
//            HStack {
//                Button(action: {
//                    navmanager.goBack()
//                }) {
//                    Image(systemName: "arrow.left")
//                        .bold()
//                        .foregroundColor(.white)
//                        .imageScale(.large)
//                }
//                
//                Text("Rules")
//                    .font(.headline)
//                    .foregroundColor(.white)
//                    .fontWeight(.semibold)
//                
//                Spacer()
//            }
//            .padding()
//            .background(Color(uiColor: .wine).shadow(radius: 1))
//            
//            VStack(spacing:15){
//
//                HStack {
//                                    Text("Cycle Rule")
//                                    Spacer()
//                                    Text("70 hrs/8 days")
//                                        .foregroundColor(.gray)
//                }
//                Divider().background(Color.gray)
//
//                                HStack {
//                                    Text("Cargo Type")
//                                    Spacer()
//                                    Text("Cargo Type 1")
//                                        .foregroundColor(.gray)
//                                }
//                Divider().background(Color.gray)
//
//                                HStack {
//                                    Text("Restart")
//                                    Spacer()
//                                    Text("34 Hours restart")
//                                        .foregroundColor(.gray)
//                                }
//                Divider().background(Color.gray)
//
//                                HStack {
//                                    Text("Rest Break")
//                                    Spacer()
//                                    Text("30 Minutes rest required")
//                                        .foregroundColor(.gray)
//                                }
//                Divider().background(Color.gray)
//
//                
//                                Toggle(isOn: $isShortHaulEnabled) {
//                                    Text("16Hr Short Haul Exception")
//                                }.tint(Color(uiColor: .wine))
//                Divider().background(Color.gray)
//
//                                HStack {
//                                    Text("Personal Conveyance")
//                                    Spacer()
//                                    Text("Active")
//                                        .foregroundColor(.gray)
//                                }
//                Divider().background(Color.gray)
//
//                                HStack {
//                                    Text("Yard Moves")
//                                    Spacer()
//                                    Text("Active")
//                                        .foregroundColor(.gray)
//                                }
//                Divider().background(Color.gray)
//
//                                HStack {
//                                    Text("Unlimited Trailers")
//                                    Spacer()
//                                    Text("Allowed")
//                                        .foregroundColor(.gray)
//                                }
//                Divider().background(Color.gray)
//
//                                HStack {
//                                    Text("Unlimited Shipping Documents")
//                                    Spacer()
//                                    Text("Allowed")
//                                        .foregroundColor(.gray)
//                                }
//            }.padding()
//            Spacer()
//        }.navigationBarBackButtonHidden()
//            
//            
//        }
//      
//    }
//
//
//#Preview {
//    RulesView()
//}
