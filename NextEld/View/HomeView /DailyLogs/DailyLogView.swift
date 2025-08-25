//
//  DailyLogView.swift
//  NextEld
//
//  Created by priyanshi  on 13/05/25.
//

import SwiftUI


struct LogDate: Identifiable {
    let id = UUID()
    let date: String
    let isMissing: Bool
}

struct DailyLogView: View {
    
    @State var lbldate: String = ""
    var title: String
    @EnvironmentObject var navManager: NavigationManager
    let entry: WorkEntry  //passed from previous screen

    //MARK: -  Sample list of dates
        private var logDates: [LogDate] {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        // DB se dates nikalo
        let logs = DatabaseManager.shared.fetchLogs()
        let logDatesFromDB = Set(logs.compactMap { $0.startTime.toDate() }).map { formatter.string(from: $0) }
        
        // Last 7 din ki continuous list banao
        let last7Days = (0..<5).compactMap { i -> String? in
            guard let date = calendar.date(byAdding: .day, value: -i, to: Date()) else { return nil }
            return formatter.string(from: date)
        }
        
        // Ab list banani hai with missing check
        let finalList: [LogDate] = last7Days.map { day in
            if logDatesFromDB.contains(day) {
                return LogDate(date: day, isMissing: false)
            } else {
                return LogDate(date: day, isMissing: true)
            }
        }
        return finalList.sorted { $0.date > $1.date } // latest -> oldest
    }

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

            List(logDates) { log in
                HStack {
                    Text(dateFormattedString(log.date))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Button(action: {
                        navManager.navigate(to: .CertifySelectedView(tittle: dateFormattedString(log.date)))
                        print("Uncertified tapped for \(dateFormattedString(log.date))")
                    }) {
                        Text("Uncertified")
                            .foregroundColor(.red)
                            .padding(8)
                    }
                }
                .contentShape(Rectangle())
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
    
    private func dateFormattedString(_ date: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let d = formatter.date(from: date) {
            formatter.dateFormat = "dd-MM-yyyy"
            return formatter.string(from: d)
        }
        return date
    }
  
}
extension String {
    func toDate() -> Date? {
        let formats = [
            "yyyy-MM-dd'T'HH:mm:ss",
            "yyyy-MM-dd HH:mm:ss",
            "yyyy-MM-dd'T'HH:mm:ssZ",
            "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        ]
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        
        for format in formats {
            formatter.dateFormat = format
            if let date = formatter.date(from: self) {
                return date
            }
        }
        return nil
    }

}



//#Preview {
//    let sampleEntry = WorkEntry(date: Date(), hoursWorked: 8.0)
//    DailyLogView(title: "Daily Logs", entry: sampleEntry, logs: [DriverLogModel])
//        .environmentObject(NavigationManager())
//}

























