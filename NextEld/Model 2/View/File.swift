//
//  File.swift
//  NextEld
//
//  Created by AroGeek11 on 06/05/25.
//
import SwiftUI
import Foundation
struct ForgtUserName: View {
    var title: String
    @State var mobNumber = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 5) {

            // MARK: - Custom Header
            ZStack(alignment: .topLeading) {
                Color.blue
                    .edgesIgnoringSafeArea(.top)

                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .imageScale(.large)
                    }

                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)

                    Spacer()
                }
                .padding()
            }
            .frame(height: 60) // You can adjust this as needed

            Spacer()

            // MARK: - Body Content
            VStack(alignment: .leading) {
                HStack {
                    Image("phone-call")
                        .foregroundColor(.blue)
                    TextField("Enter Mobile Number", text: $mobNumber)
                }
                .padding()
                .frame(height: 50)
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.blue, lineWidth: 2)
                )
                .padding()

                HStack {
                    Text("We'll send an SMS for User Name")
                        .font(.system(size: 18))
                        .foregroundColor(.gray)
                        .padding(.horizontal, 5)
                    Spacer()
                }

                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}
