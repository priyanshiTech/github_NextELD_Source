//
//  DailyLogView.swift
//  NextEld
//
//  Created by priyanshi  on 13/05/25.
//

import SwiftUI

struct DailyLogView: View {
    
    @State var lbldate: String = ""
    var title: String
    @EnvironmentObject var navManager: NavigationManager
    let entry: WorkEntry  //passed from previous screen

    //MARK: -  Sample list of dates
    
    let dateList: [Date] = [
        Date(),
        Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
        Calendar.current.date(byAdding: .day, value: -2, to: Date())!
    ]
    
    var body: some View {
        
        //MARK: top Header Colour
        VStack(spacing: 0) {
            ZStack(alignment: .topLeading){
                Color(uiColor: .wine)
                    .edgesIgnoringSafeArea(.top)
                    .frame(height:0)
                
            }
            //MARK: -  Header
            ZStack(alignment: .top) {
                Color(uiColor: .wine)
                    .frame(height: 50)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
                HStack {
                    Button(action: {
                        navManager.goBack()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .bold()
                            .imageScale(.large)
                    }
                    
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                    Spacer()
                    
                    HStack(spacing: 5) {
                        CustomIconButton(iconName: "email_icon", title: "", action: { navManager.navigate(to: .emailLogs(tittle: " Daily Logs"))})
                            .padding()
                        CustomIconButton(iconName: "alarm_icon", title: "", action: { navManager.navigate(to: .RecapHours(tittle: "Hours Recap"))})
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal)
            }
            
            
            HStack{
                
                Image(systemName: "exclamationmark.circle.fill")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, Color(uiColor: .wine)) // mark = white, circle = blue
                    .font(.system(size: 25))
                
                Text("Please display required logs as per FMCSA and CCATM")
                    .font(.callout)
                    .foregroundColor(.gray)
            }
            .padding()
            
            //MARK: -  List Section
            
            List(dateList, id: \.self) { date in
                Button {
                    //MARK: -  Navigate to LogsDetails screen with selected date wrapped in WorkEntry
                    let selectedEntry = WorkEntry(date: date, hoursWorked: 0) // Replace hoursWorked if you want real data
                    navManager.navigate(to: .LogsDetails(title: "Daily Logs", entry: selectedEntry))
                } label: {
                    HStack {
                        Text(dateFormatted(date))
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Button(action: {
                            navManager.navigate(to: .CertifySelectedView(tittle: "\(dateFormatted(date))"))
                            print("Uncertified button tapped for \(dateFormatted(date))")
                        }) {
                            Text("Uncertified")
                                .foregroundColor(.red)
                                .padding(8)
                        }
                    }
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
    let sampleEntry = WorkEntry(date: Date(), hoursWorked: 8.0)
    return DailyLogView(title: "Daily Logs", entry: sampleEntry)
        .environmentObject(NavigationManager())
}

