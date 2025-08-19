//
//  ShippingDocView.swift
//  NextEld
//
//  Created by priyanshi   on 13/08/25.
//


import SwiftUI

struct ShippingDocView: View {
    @EnvironmentObject var navmanager: NavigationManager
    @EnvironmentObject var shippingVM: ShippingDocViewModel
    
    var tittle: String
    @State private var inputText: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Bar
            HStack {
                Button(action: { navmanager.goBack() }) {
                    Image(systemName: "arrow.left")
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
            .background(Color(uiColor: .wine))
            .frame(height: 50)

            Spacer(minLength: 20)
            
            VStack(spacing: 20) {
                // TextField + Add Button
                HStack {
                    TextField("Enter text here", text: $inputText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Button("Add") {
                        guard !inputText.isEmpty else { return }
                        
                        // Just append directly
                        shippingVM.ShippingDoc.append(inputText)
                        inputText = ""
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 15)
                    .background(Color(uiColor: .wine))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                
                // List
                List {
                    ForEach(shippingVM.ShippingDoc, id: \.self) { item in
                        HStack {
                            Text(item)
                            Spacer()
                            Button("Delete") {
                                if let index = shippingVM.ShippingDoc.firstIndex(of: item) {
                                    shippingVM.ShippingDoc.remove(at: index)
                                }
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 15)
                            .background(Color(uiColor: .wine))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)
                .background(Color.clear)
            }
            .padding()
        }
        .navigationBarBackButtonHidden()
    }
}



































