//
//  LogsDetails.swift
//  NextEld
//
//  Created by priyanshi   on 17/05/25.
//

import SwiftUI

struct LogsDetails: View {
    @EnvironmentObject var navManager: NavigationManager
    var title: String
    let entry: WorkEntry
    @State private var selectedDate: Date
    
    init(title: String, entry: WorkEntry) {
        self.title = title
        self.entry = entry
        self._selectedDate = State(initialValue: entry.date)
    }
    
    var body: some View {
        //MARK: -  Header
        
        
        VStack(spacing: 0){
            ZStack(alignment: .topLeading){
                Color(uiColor: .wine)
                    .edgesIgnoringSafeArea(.top)
                    .frame(height:0)
                
            }
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
                            .imageScale(.large)
                    }
                    Spacer()
                    //MARK: - previous page click date show
                    // Text(DateUtils.formatDate(entry.date, format: "dd-MM-yyyy"))
                    Text(title)
                    
                        .font(.headline)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                    Spacer()
                    
                    HStack(spacing: 5) {
                       // CustomIconButton(iconName: "eye_fill_icon", title: "", action: { navManager.navigate(to: .EyeViewData(tittle: "daily Logs"))})
                        CustomIconButton(iconName: "eye_fill_icon", title: "", action: {
                            
                          //  navManager.navigate(to: .logsFlow(.EyeViewData(title: "Daily Logs", entry: entry)))
                            
                            navManager.navigate(to: AppRoute.EyeViewData(
                                tittle: "Daily Logs",
                                entry: entry))

                        })


                    }
                }
                .padding(.horizontal) // or even remove entirely to test
                .frame(height: 50)
                .alignmentGuide(.top) { _ in 0 } // optional, helps align precisely
//                .padding()
            }
            //MARK: -  show a date Format
            HStack{
                DateStepperView(currentDate: $selectedDate)
            }  .background(Color.white.shadow(radius: 5))
            VStack {
                HOSEventsChartScreen(events: [])
            }.padding()
            VStack(alignment: .leading) {
                Text("Version - OS/02/May")
            }
            Spacer()
        }.navigationBarBackButtonHidden()
        Spacer()
        
    }
    func List(){
        //MARK: -  impliment The exact data for  on - duty , off-duty, new shift and all
        
    }
    
}
        


//#Preview {
//    LogsDetails()
//}
