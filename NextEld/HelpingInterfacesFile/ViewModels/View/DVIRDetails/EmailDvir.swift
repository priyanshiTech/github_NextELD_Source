//
//  EmailDvir.swift
//  NextEld
//
//  Created by Inurum   on 21/05/25.
//

import SwiftUI

import SwiftUI

struct EmailDvir: View {
    @EnvironmentObject var navmanager: NavigationManager
   @State var tittle: String

    var body: some View {
        VStack(spacing: 0) {
            // Top Color Bar
            Color(UIColor.colorPrimary)
                .edgesIgnoringSafeArea(.top)
                .frame(height: 5)

            // MARK: - Header
            ZStack {
                Color.white
                    .frame(height: 50)
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

                    Text("Email Dvir")
                        .bold()
                        .font(.headline)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)

                    Spacer()

                    Button(action: {
                        navmanager.navigate(to: .AddDvirScreenView(selectedVehicle: ""))
                    }) {
                        Image(systemName: "plus")
                            .bold()
                            .foregroundColor(.white)
                            .imageScale(.large)
                            
                    }
                    .padding(5 )
                    Button(action: {
                      //  navmanager.goBack()
                        navmanager.navigate(to: .DvirHostory(tittle: "Dvir History"))
                    }) {
                        Image("email_icon")
                            .bold()
                            .foregroundColor(.white)
                            .imageScale(.large)
                    }
                }
                .padding()
                .background(Color.blue)
            }

            // Centered Text
            Spacer()
            Text("No Records Available for DVIR.")
                .foregroundColor(.gray)
                .font(.subheadline)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    EmailDvir(tittle: "Email Dvir")
}
