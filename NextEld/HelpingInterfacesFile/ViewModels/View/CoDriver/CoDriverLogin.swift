//
//  CoDriverLogin.swift
//  NextEld
//
//  Created by Inurum   on 27/05/25.
//

import SwiftUI

struct CoDriverLogin: View {
    //@State private var selectionCoDriver: String? = nil
    @State private var selectionCoDriver: String = ""

    @State private var ShowDriver = false
    @EnvironmentObject var navmanager: NavigationManager

    var tittle : String = "Co-Driver Log-in"
    
    var body: some View {


        VStack(spacing: 0){
                   
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
                   .background(Color(uiColor: .wine).shadow(radius: 1))

                            Text("Select Co-Driver")
                                   .font(.title2)
                                   .fontWeight(.semibold)
                                   .padding()

                   CardContainer {
                       Button(action: {
                           ShowDriver = true
                           
                       }) {
                           HStack {
                               VStack(alignment: .leading, spacing: 4) {
                                   Text("Co-Driver")
                                       .font(.headline)
                                       .foregroundColor(.black)

                        //MARK: -  to show a selected data
                                   Text(selectionCoDriver ?? "None")
                                      
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
                   .padding()
                   

                               Spacer()

                               Button(action: {
                                   navmanager.navigate(to: .NewDriverLogin(title: tittle))
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
                              // .padding()
                   
                   PopupContainer(isPresented: $ShowDriver) {
                       SelectCoDriverPopup(selectedCoDriver: $selectionCoDriver, isPresented: $ShowDriver)
                   }
                }.navigationBarBackButtonHidden()

                }

            }




#Preview {
    CoDriverLogin()
}
