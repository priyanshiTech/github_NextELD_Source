//
//  SelectedCoDriverPopup.swift
//  NextEld
//
//  Created by Priyanshi  on 27/05/25.
//

import Foundation
import SwiftUI

struct SelectCoDriverPopup: View {
    @Binding var selectedCoDriver: String?
    @Binding var isPresented: Bool

    let coDrivers = ["None", "Aman ELD", "Beer Khan", "sachin Kumar", "Raman wadhwa","shubham jain","Divya Bilthare","Rishubh soni","Hemant Kumawat","ganga india "]

    var body: some View {
        
        VStack(spacing: 16) {
            Text("Select Co-Driver")
                .font(.headline)
                .padding(.top)

            Divider()

            UniversalScrollView {
                VStack(spacing: 12) {
                    ForEach(coDrivers, id: \.self) { driver in
                        HStack {
                            Text(driver)
                                .foregroundColor(.black)

                            Spacer()

                            Image(systemName: selectedCoDriver == driver ? "checkmark.circle.fill" : "checkmark.circle")
                                .foregroundColor(.blue)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedCoDriver = driver
                        }

                        Divider()
                    }
                }
                .padding(.horizontal)
            }

            Spacer()

            Button(action: {
                isPresented = false
            }) {
                Text("Add Co-Driver")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
