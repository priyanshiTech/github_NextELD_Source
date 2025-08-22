//
//  DotInspection.swift
//  NextEld
//
//  Created by priyanshi on 22/05/25.
//

import SwiftUI

struct DotInspection: View {
    @EnvironmentObject var navManager: NavigationManager
    var title: String
    let dateList: [Date] = [
        Date(),
        Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
        Calendar.current.date(byAdding: .day, value: -2, to: Date())!
    ]
    var body: some View {
        
        VStack (spacing:0){
            ZStack(alignment: .topLeading){
                Color(uiColor: .wine)
                    .edgesIgnoringSafeArea(.top)
                    .frame(height:0)
                
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
            .background( Color(uiColor: .wine).shadow(radius: 1))
            .frame(height: 40, alignment: .topLeading)
            Spacer(minLength: 20)
            VStack(alignment: .center, spacing: 20) {
                
                VStack{
                    Text("Email logs for the 24-hour period and the previous day for one HOS cycle")
                        .font(.body)
                        .padding(.bottom)
                    Text ("Email your logs in the pdf format")
                        .foregroundColor(.gray)
                        .font(.callout)
                    
                    
                    Button(action: {
                        navManager.navigate(to: .emailLogs(tittle: "Road Side inspection"))
                    }) {
                        Text("Email Logs")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(uiColor: .wine))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    
                }
                
                VStack(spacing: 10){
                    Text("Send logs for the 24-hour period and the previous days for one HOS cycle")
                        .font(.body)
                    
                    
                    Text ("Send  your logs to the officer if they request")
                        .foregroundColor(.gray)
                        .font(.callout)
                    
                    
                    Button(action: {
                        // Data Transfer action
                        navManager.navigate(to: AppRoute.DataTransferView)
                    }) {
                        Text("Data Transfer")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(uiColor: .wine))                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                
                VStack (spacing:10){
                    
                    Text("Inspect logs for the 24-hour period and the previous days for men HOS cycle")
                        .font(.body)
                    
                    
                    Text ("Select 'review ON Device'and give your Device to the Officer ")
                        .foregroundColor(.gray)
                        .font(.callout)
                    
                        Button(action: {
                            let selectedEntry = WorkEntry(date: Date(), hoursWorked: 0)
                                    navManager.navigate(to: .LogsDetails(title: "Road Side Inspection", entry: selectedEntry))
                        }) {
                            Text("Review On Device")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(uiColor: .wine))                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    VStack (spacing: 10){
                        Text("Email DVIR for the 24-hour period and the previous day for one HOS cycle")
                            .font(.body)
                        
                        
                        Text ("Email  your logs to the officer if they request")
                            .foregroundColor(.gray)
                            .font(.callout)
                        
                        Button(action: {
                            navManager.navigate(to: .DvirHostory(tittle: title))
                        }) {
                            Text("Email Dvir")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(uiColor: .wine))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        
                        Spacer()
                    }
                }
                .padding(.horizontal) // Equal leading/trailing padding
                .padding(.bottom)
                
                .padding()
        }.navigationBarBackButtonHidden()
        }
        
    }

#Preview {
    DotInspection(title: "Road Side inspection")
}
