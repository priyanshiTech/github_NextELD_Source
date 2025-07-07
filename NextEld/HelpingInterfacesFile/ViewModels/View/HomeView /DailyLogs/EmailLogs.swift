//
//  EmailLogs.swift
//  NextEld
//
//  Created by Priyanshi  on 14/05/25.
//

import SwiftUI

struct EmailLogs: View {
    @EnvironmentObject var navManager: NavigationManager
    @State var email:String = ""
    @State var title: String
    @State private var fromDate = Date()
    @State private var toDate = Date()
    @State private var showFromDatePicker = false
    @State private var isFromDateSelected = false
    
    let dateList: [Date] = [
        Date(),
        Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
        Calendar.current.date(byAdding: .day, value: -2, to: Date())!
    ]
    var body: some View {
        
        
        VStack (spacing:0){
            
            ZStack(alignment: .topLeading){
              //  Color(UIColor.blue)
                Color(.blue)
                    .edgesIgnoringSafeArea(.top)
                    .frame(height:2)
              
            }
            
            HStack {
                Button(action: {
                    navManager.goBack()
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
            .background(Color.blue.shadow(radius: 1))
            .frame(height: 40, alignment: .topLeading)
            Spacer(minLength: 20)
            HStack{
                Text("Email Logs")
                    .font(.system(size: 35))
                    .bold()
                    .foregroundColor(.blue)
                Image("email_icon_blue")
            }
            .padding()
            VStack(spacing:0){
                HStack(spacing: 16) {
             
                    Button(action: {
                        showFromDatePicker = true
                    }) {
                        Text(isFromDateSelected ? " \(dateFormatted(fromDate))" : "From Date")
                            .foregroundColor(isFromDateSelected ? .black : .gray)
                            .font(.system(size: 18))
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                    }
                    .sheet(isPresented: $showFromDatePicker) {
                        DatePickerPopup(
                            selectedDate: $fromDate,
                            isPresented: $showFromDatePicker,
                            onDateSelected: {
                                isFromDateSelected = true
                            }
                        )
                    }

                    Button(action: {
                        showFromDatePicker = true
                    }) {
                        Text(isFromDateSelected ? " \(dateFormatted(toDate))" : "Current Date")
                            .foregroundColor(isFromDateSelected ? .black : .gray)
                            .font(.system(size: 18))
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                    }
                    .sheet(isPresented: $showFromDatePicker) {
                        DatePickerPopup(
                            selectedDate: $fromDate,
                            isPresented: $showFromDatePicker,
                            onDateSelected: {
                                isFromDateSelected = true
                            }
                        )
                    }

                }
                .padding(.horizontal)
                .padding(.top, 12)

                   //MARK: -  change a textfield custom colour

                HStack(spacing: 12) {
                    
                    TextField(
                        "",
                        text: $email,
                        prompt: Text("Enter Email")
                            .foregroundColor(.gray)
                            .font(.system(size: 18))
                    )
                    .padding()
                    .font(.system(size: 18))
                    .frame(height: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.blue, lineWidth: 2)
                    )

                    Button(action: {
                        // Send email action
                    }) {
                        Text("Send")
                            .foregroundColor(.white)
                            .font(.title3)
                            .frame(width: 90, height: 40)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
            }
            
            List(dateList, id: \.self) { date in
                HStack {
                    Text(dateFormatted(date))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    CheckboxButton()

                }
            }
            .listStyle(.plain)
            
        }
        .navigationBarBackButtonHidden()
        
  
    }
    // MARK: - Helper Function
    private func dateFormatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: date)
        
    }
}
#Preview {
    EmailLogs(title: "Daily Logs")
}
