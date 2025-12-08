//
//  TrailerView.swift
//  NextEld
//
//  Created by priyanshi on 26/07/25.
//



import SwiftUI

struct TrailerView: View {
    
    @EnvironmentObject var navmanager: NavigationManager
    @ObservedObject var trailerVM: TrailerViewModel

    var tittle: String
    @State private var inputText: String = ""

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
                        .onChange(of: inputText) { newValue in
                                  // Allow only alphabets, numbers, space
                                  let allowed = CharacterSet.alphanumerics.union(.whitespaces)
                                  inputText = String(newValue.unicodeScalars.filter { allowed.contains($0) })
                              }
                    
                    Button(action: {
                        
                        if !inputText.isEmpty {
                            let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
                            if !trimmed.isEmpty {
                                // Add to ViewModel (which updates the binding automatically since binding is $trailerVM.trailers)
                                trailerVM.addTrailer(trimmed)
                                inputText = ""
                            }
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
                                // Remove from ViewModel (which updates the binding automatically)
                                trailerVM.removeTrailer(item)
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

//#Preview {
//    TrailerView(trailerVM: TrailerViewModel(), tittle: "Trailers", trailers: <#Binding<[String]>#>)
//        .environmentObject(NavigationManager())
//}

