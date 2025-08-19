//
//  AddVichleMode.swift
//  NextEld
//
//  Created by Priyanshi on 27/05/25.
//

import SwiftUI

struct AddVichleMode: View {
    
    @EnvironmentObject var navmanager: NavigationManager
    @Binding var selectedVehicle: String
    var tittle:String = "Add Vehicle"
    
    var body: some View {
        
        VStack(spacing:0){
            
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
                
                Text(tittle)
                    .font(.headline)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            .padding()
            .background( Color(uiColor: .wine).shadow(radius: 1))
            
            //MARK: -  Vehicle selection
            CardContainer {
                Button(action: {
                    navmanager.navigate(to: .ADDVehicle)
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
                        }
                        Spacer()
                        Image("pencil").foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(20)
            
            Button(action: {
                navmanager.navigate(to: .Scanner)
            }) {
                Text("Submit")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: 150)
                    .padding()
                    .background( Color(uiColor: .wine))
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            Spacer()
            
        }.navigationBarBackButtonHidden()
                   }
        }
//
//#Preview {
//    AddVichleMode(, selectedVehicle: "")
//}
