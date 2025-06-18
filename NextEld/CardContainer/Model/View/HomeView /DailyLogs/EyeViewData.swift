//
//  EyeViewData.swift
//  NextEld
//
//  Created by Priyanshi   on 23/05/25.
//

import SwiftUI

struct EyeViewData: View {
    
    @State var tittle: String
    @EnvironmentObject var navManager: NavigationManager
    var selectedDate: Date
    
    
    var body: some View {
        
        VStack(spacing:0){
            ZStack(alignment: .topLeading){
                Color.blue
                    .edgesIgnoringSafeArea(.top)
                    .frame(height:2)
                
            }

            ZStack(alignment: .top) {
                Color.blue
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
                    Text(tittle)
                    
                        .font(.headline)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                    Spacer()
                    
                    HStack(spacing: 5) {
                        CustomIconButton(iconName: "eye_fill_icon", title: "", action: { navManager.navigate(to: .EyeViewData(tittle: "daily Logs"))})
                    }
                }
                .padding(.horizontal) // or even remove entirely to test
                .frame(height: 50)
                .alignmentGuide(.top) { _ in 0 } // optional, helps align precisely


//                .padding()
            }
            //MARK: -  show a date Format
            HStack{
                DateStepperView(currentDate: .constant(selectedDate))
            }  .background(Color.white.shadow(radius: 5))
            Spacer()
            
            UniversalScrollView{
                
                // Section 1: Driver Info
                sectionGrid(
                    headers: ["Driver Name", "Driver ID", "Driver License", "Driver License State"],
                    values: ["Mark Josheph", "amanjosh\neph@gmail.com", "464465", "Madhya Pradesh"]
                )
                
                sectionGrid(
                    headers: ["Exempt Driver Status", "Unidentified Driving Records", "Co-Driver", "Co-Driver ID"],
                    values: ["NA", "NA", "NA", "NA"]
                )
                
          
                // Section 2: Log Info
                sectionGrid(
                    headers: ["Log Date", "Display Date", "Display Location", "Driver Certified"],
                    values: [
                        "May 16, 2025",
                        "May 23, 2025",
                        "390, Vijay Nagar,\nScheme 54 PU4,\nIndore, Madhya Pradesh\n452010, India",
                        "No"
                    ]
                )
                
                // Section 3: ELD Info
                sectionGrid(
                    headers: ["Eld Registration ID", "ELD Identifier", "Provider"],
                    values: ["NA", "NA", "Nexxtec"]
                )
                
                sectionGrid(
                    headers: ["24 Period Starting Time", "Data Dig. Indicators", "Device Malfn. Indicators"],
                    values: ["00:00", "NA", "NA"]
                )
                
                sectionGrid(
                    headers: ["Vehicle", "VIN", "Odometer", "Distance"],
                    values: [
                        "1234",
                        "",
                        "0.0",
                        "0.0"
                    ]
                )
                sectionGrid(
                    headers: ["Trailer", "Shipping Docs", "carrier", "Main Office"],
                    values: [
                        "",
                        "",
                        "ELD Solution India",
                        "455,Electronic Complex Indore"
                    ]
                )
                sectionGrid(
                    headers: ["Engine Hours", "Home Terminal"],
                    values: [
                        "0",
                        "Main Terminal 1",
                        
                    ]
                )
                VStack {
                    HOSEventsChartScreen()
                }
                //.padding()
                
                VStack(alignment: .leading) {
                    Text("Version - OS/02/May")
                }
                
                sectionSmallGrid(
                    smallheaders: ["Time", "Status","Location","Origin","OdoMeter","Engine Hours","Engine","Notes"],
                    smallvalues: [
                        "May 23,01:59:14",
                        "new Shift Start",
                        "389,vijay Nagar Scheme 54 Pu4 Indore Madhya Pradesh 452010 India","Driver","0","0","Off",""
                        
                    ]
                )
            }
        }.navigationBarBackButtonHidden()
    }
}



        //MARK: -  Reusable Section Grid
        @ViewBuilder
        func sectionGrid(headers: [String], values: [String]) -> some View {
            VStack(spacing: 0) {
                // Header row with single background
                HStack {
                    ForEach(headers, id: \.self) { header in
                        Text(header)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(6)
                    }
                }
                .background(Color.gray.opacity(0.2)) // <-- Apply to entire header row
                
                // Values row
                HStack(alignment: .top) {
                    ForEach(values, id: \.self) { value in
                        Text(value)
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(6)
                    }
                }
                
                Divider()
            }
        }
        
        //MARK: - For samll Details
        
        func sectionSmallGrid(smallheaders: [String], smallvalues: [String]) -> some View {
            VStack(spacing: 0) {
                // Header row with single background
                HStack {
                    ForEach(smallheaders, id: \.self) { header in
                        Text(header)
                            .font(.caption)
                        // .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(6)
                    }
                }
                .background(Color.gray.opacity(0.2)) // <-- Apply to entire header row
                
                // Values row
                HStack(alignment: .top) {
                    ForEach(smallvalues, id: \.self) { value in
                        Text(value)
                            .font(.footnote)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(6)
                    }
                }
                
                Divider()
            }
        }

//
//
//#Preview {
//    EyeViewData(tittle: "", selectedDate: Date())
//}
