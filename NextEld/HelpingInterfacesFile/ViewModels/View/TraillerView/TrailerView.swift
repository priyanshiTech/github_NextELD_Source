//
//  TrailerView.swift
//  NextEld
//
//  Created by priyanshi on 26/07/25.
//



import SwiftUI

struct TrailerView: View {
    
    @EnvironmentObject var navmanager: NavigationManager
    @EnvironmentObject var trailerVM: TrailerViewModel
    
    var tittle: String
    @State private var inputText: String = ""
    @State private var items: [String] = []

    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: - Top Bar
            ZStack(alignment: .topLeading){
                Color(uiColor: .wine)
                    .edgesIgnoringSafeArea(.top)
                    .frame(height:0.1)
            }
            HStack {
                Button(action: {
                    navmanager.goBack()
                }) {
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
            .background(Color(uiColor: .wine).shadow(radius: 1))
            .frame(height: 30, alignment: .topLeading)

            
            Spacer(minLength: 20)
            
            VStack(spacing: 20) {
                
                // MARK: - TextField + Add Button
                HStack {
                    TextField("Enter text here", text: $inputText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Button(action: {
                        if !inputText.isEmpty {
                           // items.append(inputText)
                            trailerVM.trailers.append(inputText)
                          
                            inputText = ""
                        }
                     
                    }) {
                        Text("Add")
                            .padding(.vertical, 8)
                            .padding(.horizontal, 15)
                            .background(Color(uiColor: .wine))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                
                // MARK: - List (Clear Background)
                List {
                    ForEach(trailerVM.trailers, id: \.self) { item in
                        HStack {
                            Text(item)
                            Spacer()
                            Button("Delete") {
                                if let index = trailerVM.trailers.firstIndex(of: item) {
                                    trailerVM.trailers.remove(at: index)
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
        }.navigationBarBackButtonHidden()
    }
}

#Preview {
    TrailerView(tittle: "Trailers")
}

